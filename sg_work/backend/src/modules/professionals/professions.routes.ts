import { Router } from 'express';
import { ProfessionsController } from './professions.controller';

const router = Router();
const controller = new ProfessionsController();

router.get('/category/:categoryId', controller.getByCategory);

export default router;