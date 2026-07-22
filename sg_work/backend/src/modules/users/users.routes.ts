import { Router } from 'express';
import { UsersController } from './users.controller';
import { authenticate } from '../../shared/middlewares/auth';

const router = Router();
const controller = new UsersController();

router.use(authenticate);

router.get('/profile', controller.getProfile);
router.put('/profile', controller.updateProfile);
router.post('/fcm-token', controller.saveFCMToken);
router.delete('/fcm-token', controller.removeFCMToken);
router.delete('/account', controller.deleteAccount);

export default router;
