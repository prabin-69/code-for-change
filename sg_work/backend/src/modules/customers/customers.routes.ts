import { Router } from 'express';
import { CustomersController } from './customers.controller';
import { authenticate } from '../../shared/middlewares/auth';
import { validate } from '../../shared/middlewares/validation';
import { createRequestSchema, cancelRequestSchema, createReviewSchema } from './customers.validation';

const router = Router();
const controller = new CustomersController();

// All customer routes require authentication
router.use(authenticate);

// Requests
router.post('/requests', validate(createRequestSchema), controller.createRequest);
router.get('/requests', controller.getMyRequests);
router.get('/requests/:id', controller.getRequestById);
router.put('/requests/:id/cancel', validate(cancelRequestSchema), controller.cancelRequest);

// Jobs
router.get('/jobs', controller.getMyJobs);
router.get('/jobs/:id', controller.getJobById);

// Favorites
router.get('/favorites', controller.getFavorites);
router.post('/favorites/:professionalId', controller.addFavorite);
router.delete('/favorites/:professionalId', controller.removeFavorite);

// Reviews
router.post('/reviews', validate(createReviewSchema), controller.createReview);
router.get('/reviews', controller.getMyReviews);

export default router;