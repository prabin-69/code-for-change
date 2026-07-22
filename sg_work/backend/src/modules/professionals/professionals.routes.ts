import { Router } from 'express';
import { ProfessionalsController } from './professionals.controller';
import { authenticate } from '../../shared/middlewares/auth';
import { validate } from '../../shared/middlewares/validation';
import { z } from 'zod';

const router = Router();
const controller = new ProfessionalsController();

// All routes require authentication and professional role (we'll check in service)
router.use(authenticate);

// Profile
router.get('/profile', controller.getProfile);
router.put('/profile', controller.updateProfile);
router.put('/availability', controller.updateAvailability);

// Verification
router.post('/verification', controller.submitVerification);
router.get('/verification/status', controller.getVerificationStatus);

// Certificates
router.post('/certificates', controller.addCertificate);
router.get('/certificates', controller.getCertificates);
router.delete('/certificates/:id', controller.deleteCertificate);

// Portfolio
router.post('/portfolio', controller.addPortfolio);
router.get('/portfolio', controller.getPortfolio);
router.delete('/portfolio/:id', controller.deletePortfolio);

// Jobs & Requests
router.get('/requests/pending', controller.getPendingRequests);
router.post('/requests/:requestId/accept', controller.acceptRequest);
router.get('/jobs', controller.getMyJobs);
router.get('/jobs/:jobId', controller.getJobDetails);
router.put('/jobs/:jobId/status', controller.updateJobStatus);

// Performance
router.get('/performance', controller.getPerformance);

router.put('/location', controller.updateLocation);
router.get('/location/:professionalId', controller.getLatestLocation);
router.get('/eta', controller.getEta);
export default router;