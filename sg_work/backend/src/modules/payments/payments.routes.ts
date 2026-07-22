import { Router } from 'express';
import { z } from 'zod';
import { PaymentController } from './payment.controller';
import { authenticate, authorize } from '../../shared/middlewares/auth';
import { validate } from '../../shared/middlewares/validation';

const router = Router();
const controller = new PaymentController();

// ---- Zod validation schemas ----

const initiatePaymentSchema = z.object({
  body: z.object({
    amount: z.number().positive('Amount must be positive'),
    gateway: z.enum(['esewa', 'khalti', 'bank']),
    type: z.enum(['SUBSCRIPTION', 'VERIFICATION_FEE', 'FEATURED']),
    related_id: z.string().uuid().optional(),
    metadata: z.any().optional(),
    product_name: z.string().optional(),
    product_id: z.string().optional(),
    success_url: z.string().url().optional(),
    failure_url: z.string().url().optional(),
  }),
});

const verifyPaymentSchema = z.object({
  body: z.object({
    transaction_id: z.string().min(1, 'Transaction ID is required'),
  }),
});

// ---- Routes ----

router.use(authenticate);

// User routes
router.post('/initiate', validate(initiatePaymentSchema), controller.initiatePayment);
router.post('/verify/:paymentId', validate(verifyPaymentSchema), controller.verifyPayment);
router.get('/me', controller.getMyPayments);

// Admin route for manual bank verification
router.put(
  '/admin/bank-verify/:paymentId',
  authorize(['ADMIN', 'SUPER_ADMIN']),
  controller.adminVerifyBank,
);

export default router;
