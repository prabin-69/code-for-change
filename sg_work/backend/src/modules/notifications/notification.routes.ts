import { Router } from 'express';
import { NotificationController } from './notification.controller';
import { authenticate } from '../../shared/middlewares/auth';

const router = Router();
const controller = new NotificationController();

router.use(authenticate);

router.get('/', controller.getMyNotifications);
router.get('/unread/count', controller.getUnreadCount);
router.put('/read-all', controller.markAllAsRead);
router.put('/:id/read', controller.markAsRead);
router.delete('/:id', controller.deleteNotification);

export default router;
