import { Router } from 'express';
import { SubscriptionsController } from './subscriptions.controller';
import { authenticate } from '../../shared/middlewares/auth';

const router = Router();
const controller = new SubscriptionsController();

router.use(authenticate);

router.post('/', controller.subscribe);
router.get('/me', controller.getMySubscription);
router.get('/history', controller.getHistory);
router.delete('/me', controller.cancel);

export default router;
