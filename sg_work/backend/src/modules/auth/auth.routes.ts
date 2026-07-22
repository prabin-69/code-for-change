import { Router } from 'express';
import { AuthController } from './auth.controller';
import { validate } from '../../shared/middlewares/validation';
import { sendOtpSchema, verifyOtpSchema, refreshTokenSchema, selectRoleSchema } from './auth.validation';
import { authenticate } from '../../shared/middlewares/auth';

const router = Router();
const controller = new AuthController();

/**
 * @swagger
 * /auth/send-otp:
 *   post:
 *     summary: Send OTP
 *     tags:
 *       - Auth
 *     responses:
 *       200:
 *         description: OTP sent successfully
 *       400:
 *         description: Bad request
 */
router.post('/send-otp', validate(sendOtpSchema), controller.sendOtp);


router.post('/verify-otp', validate(verifyOtpSchema), controller.verifyOtp);

router.post('/refresh', validate(refreshTokenSchema), controller.refreshToken);

router.post('/logout', validate(refreshTokenSchema), controller.logout);

router.post('/logout-all', authenticate, controller.logoutAll);

router.get('/me', authenticate, controller.getMe);

router.post('/select-role', authenticate, validate(selectRoleSchema), controller.selectRole);

export default router;