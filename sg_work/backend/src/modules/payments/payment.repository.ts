import prisma from '../../config/database';
import { Payment, PaymentStatus, PaymentType } from '@prisma/client';

export class PaymentRepository {
  async createPayment(data: {
    user_id: string;
    amount: number;
    gateway: string;
    type: PaymentType;
    related_id?: string;
    metadata?: any;
  }): Promise<Payment> {
    return prisma.payment.create({
      data: {
        user_id: data.user_id,
        amount: data.amount,
        currency: 'NPR',
        gateway: data.gateway,
        status: 'PENDING',
        type: data.type,
        related_id: data.related_id,
        metadata: data.metadata,
      },
    });
  }

  async updatePayment(id: string, data: Partial<Payment>): Promise<Payment> {
    // Cast to any to avoid Prisma strict XOR union type for partial updates
    return prisma.payment.update({ where: { id }, data: data as any });
  }

  async findPaymentById(id: string): Promise<Payment | null> {
    return prisma.payment.findUnique({ where: { id } });
  }

  async findPaymentByTransactionId(transactionId: string): Promise<Payment | null> {
    return prisma.payment.findUnique({ where: { transaction_id: transactionId } });
  }

  async createPaymentLog(data: {
    payment_id: string;
    gateway: string;
    request_payload: any;
    response_payload: any;
    status_code?: number;
  }) {
    return prisma.paymentLog.create({ data });
  }

  async getPaymentsByUser(userId: string): Promise<Payment[]> {
    return prisma.payment.findMany({
      where: { user_id: userId },
      orderBy: { created_at: 'desc' },
    });
  }
}