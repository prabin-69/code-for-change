import { Router } from 'express';
import { SearchController } from './search.controller';

const router = Router();
const controller = new SearchController();

// Public routes – no auth required
router.get('/', controller.search);
router.get('/professionals/:professionalId', controller.getProfessionalProfile);
router.get('/professionals/:professionalId/reviews', controller.getProfessionalReviews);

export default router;
