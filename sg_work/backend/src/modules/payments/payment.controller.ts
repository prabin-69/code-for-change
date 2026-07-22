import { Request, Response, NextFunction } from 'express';
import { AuthRequest } from '../../shared/middlewares/auth';
import { PaymentService } from './payment.service';
import { InitiatePaymentDto, VerifyPaymentDto } from './payment.dto';

export class PaymentController {
  private service: PaymentService;

  constructor() {
    this.service = new PaymentService();
  }

  initiatePayment = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const data = req.body as InitiatePaymentDto;
      const result = await this.service.initiatePayment({
        userId,
        amount: data.amount,
        gateway: data.gateway,
        type: data.type,
        relatedId: data.related_id,
        metadata: data.metadata,
        productName: data.product_name,
        productId: data.product_id,
        successUrl: data.success_url,
        failureUrl: data.failure_url,
      });
      res.status(201).json({
        success: true,
        data: result,
        message: 'Payment initiated',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  verifyPayment = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { paymentId } = req.params;
      const { transaction_id } = req.body as VerifyPaymentDto;
      const payment = await this.service.verifyPayment(paymentId, transaction_id);
      res.status(200).json({
        success: true,
        data: payment,
        message: 'Payment verified successfully',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getMyPayments = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const payments = await this.service.getUserPayments(userId);
      res.status(200).json({
        success: true,
        data: payments,
        message: 'Payment history retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // Admin: verify bank payment manually
  adminVerifyBank = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const adminId = req.user!.id;
      const { paymentId } = req.params;
      const payment = await this.service.adminVerifyBankPayment(paymentId, adminId);
      res.status(200).json({
        success: true,
        data: payment,
        message: 'Bank payment verified by admin',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };
}