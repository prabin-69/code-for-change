import { PaymentRepository } from './payment.repository';
import { EsewaService } from './gateways/esewa.service';
import { KhaltiService } from './gateways/khalti.service';
import { BankService } from './gateways/bank.service';
import { eventBus } from '../../shared/events/event-bus';
import { AppError } from '../../shared/utils/AppError';
import { env } from '../../config/env';
import { Payment, PaymentType } from '@prisma/client';

export class PaymentService {
  private repository: PaymentRepository;
  private esewaService: EsewaService;
  private khaltiService: KhaltiService;
  private bankService: BankService;

  constructor() {
    this.repository = new PaymentRepository();
    this.esewaService = new EsewaService();
    this.khaltiService = new KhaltiService();
    this.bankService = new BankService();
  }

  // Initiate payment – create a pending record, then call the gateway
  async initiatePayment(data: {
    userId: string;
    amount: number;
    gateway: 'esewa' | 'khalti' | 'bank';
    type: PaymentType;
    relatedId?: string;
    metadata?: any;
    productName?: string;
    productId?: string;
    successUrl?: string;
    failureUrl?: string;
  }): Promise<{ payment: Payment; gatewayResponse: any }> {
    // Create pending payment record
    const payment = await this.repository.createPayment({
      user_id: data.userId,
      amount: data.amount,
      gateway: data.gateway,
      type: data.type,
      related_id: data.relatedId,
      metadata: data.metadata,
    });

    let gatewayResponse: any;

    switch (data.gateway) {
      case 'esewa': {
        const successUrl = data.successUrl ?? `${env.CLIENT_URL}/payment/success`;
        const failureUrl = data.failureUrl ?? `${env.CLIENT_URL}/payment/failure`;
        const productId = data.productId ?? `payment_${payment.id}`;
        const productName = data.productName ?? `Payment for ${data.type}`;
        gatewayResponse = await this.esewaService.initiatePayment({
          amount: data.amount,
          productId,
          productName,
          successUrl,
          failureUrl,
        });
        break;
      }
      case 'khalti': {
        const productId = data.productId ?? `payment_${payment.id}`;
        const productName = data.productName ?? `Payment for ${data.type}`;
        const returnUrl = data.successUrl ?? `${env.CLIENT_URL}/payment/success`;
        gatewayResponse = await this.khaltiService.initiatePayment({
          amount: data.amount,
          productName,
          productId,
          returnUrl,
        });
        break;
      }
      case 'bank': {
        const reference = `PAY-${payment.id.slice(0, 8).toUpperCase()}`;
        gatewayResponse = await this.bankService.getPaymentInstructions(data.amount, reference);
        break;
      }
      default:
        throw new AppError('Unsupported payment gateway', 400);
    }

    // Persist the gateway interaction log
    await this.repository.createPaymentLog({
      payment_id: payment.id,
      gateway: data.gateway,
      request_payload: data,
      response_payload: gatewayResponse,
    });

    return { payment, gatewayResponse };
  }

  // Verify payment after redirect / webhook
  async verifyPayment(paymentId: string, transactionId: string): Promise<Payment> {
    const payment = await this.repository.findPaymentById(paymentId);
    if (!payment) throw new AppError('Payment not found', 404);
    if (payment.status !== 'PENDING') {
      throw new AppError('Payment already processed', 400);
    }

    let isVerified = false;

    try {
      switch (payment.gateway) {
        case 'esewa':
          isVerified = await this.esewaService.verifyPayment(
            transactionId,
            Number(payment.amount),
          );
          break;
        case 'khalti':
          isVerified = await this.khaltiService.verifyPayment(transactionId);
          break;
        case 'bank':
          // Bank payments require admin manual verification (separate endpoint)
          throw new AppError(
            'Bank payments must be verified by an admin via /admin/bank-verify/:paymentId',
            400,
          );
        default:
          throw new AppError('Unsupported gateway', 400);
      }
    } catch (error) {
      if (error instanceof AppError) throw error;
      await this.repository.updatePayment(paymentId, { status: 'FAILED' });
      throw new AppError('Payment verification failed', 500);
    }

    if (!isVerified) {
      await this.repository.updatePayment(paymentId, { status: 'FAILED' });
      throw new AppError('Payment verification failed', 400);
    }

    const updatedPayment = await this.repository.updatePayment(paymentId, {
      status: 'SUCCESS',
      transaction_id: transactionId,
    });

    eventBus.emit('PaymentCompletedEvent', {
      paymentId: updatedPayment.id,
      userId: updatedPayment.user_id,
      type: updatedPayment.type,
      relatedId: updatedPayment.related_id,
      gateway: updatedPayment.gateway,
    });

    return updatedPayment;
  }

  // Admin: manually mark a bank payment as successful
  async adminVerifyBankPayment(paymentId: string, _adminId: string): Promise<Payment> {
    const payment = await this.repository.findPaymentById(paymentId);
    if (!payment) throw new AppError('Payment not found', 404);
    if (payment.gateway !== 'bank') {
      throw new AppError('Only bank payments can be manually verified', 400);
    }
    if (payment.status === 'SUCCESS') {
      throw new AppError('Payment is already marked as successful', 400);
    }

    const updatedPayment = await this.repository.updatePayment(paymentId, {
      status: 'SUCCESS',
    });

    eventBus.emit('PaymentCompletedEvent', {
      paymentId: updatedPayment.id,
      userId: updatedPayment.user_id,
      type: updatedPayment.type,
      relatedId: updatedPayment.related_id,
      gateway: updatedPayment.gateway,
    });

    return updatedPayment;
  }

  // Payment history for a user
  async getUserPayments(userId: string): Promise<Payment[]> {
    return this.repository.getPaymentsByUser(userId);
  }
}
