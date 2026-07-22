import { Router } from 'express';
import { ChatController } from './chat.controller';
import { authenticate } from '../../shared/middlewares/auth';

const router = Router();
const controller = new ChatController();

router.use(authenticate);

router.get('/recent', controller.getRecentChats);
router.get('/messages/:userId', controller.getMessages);
router.put('/messages/:userId/read', controller.markAsRead);
router.get('/unread', controller.getUnreadCount);

export default router;