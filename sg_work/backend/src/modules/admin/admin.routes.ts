import { Router } from 'express';
import { AdminController } from './admin.controller';
import { authenticate } from '../../shared/middlewares/auth';
import { authorize } from '../../shared/middlewares/auth';

const router = Router();
const controller = new AdminController();

// All admin routes require authentication and admin role
router.use(authenticate);
router.use(authorize(['ADMIN', 'SUPER_ADMIN']));

// Dashboard
router.get('/dashboard/stats', controller.getDashboardStats);

// Users
router.get('/users', controller.getUsers);
router.get('/users/:userId', controller.getUserDetails);
router.put('/users/:userId/status', controller.updateUserStatus);

// Professionals
router.get('/professionals', controller.getProfessionals);
router.get('/professionals/:professionalId', controller.getProfessionalDetails);
router.put('/professionals/:professionalId/verification', controller.updateVerification);
router.put('/professionals/:professionalId/featured', controller.updateFeatured);

// Categories
router.post('/categories', controller.createCategory);
router.put('/categories/:categoryId', controller.updateCategory);
router.delete('/categories/:categoryId', controller.deleteCategory);

// Professions
router.post('/professions', controller.createProfession);
router.put('/professions/:professionId', controller.updateProfession);
router.delete('/professions/:professionId', controller.deleteProfession);

// Jobs
router.get('/jobs', controller.getJobs);

// Reports
router.get('/reports', controller.getReports);
router.put('/reports/:reportId/resolve', controller.resolveReport);

// Analytics
router.get('/analytics', controller.getAnalytics);

// Payments
router.get('/payments', controller.getPayments);

// Subscriptions
router.get('/subscriptions', controller.getSubscriptions);

// Broadcast
router.post('/notifications/broadcast', controller.broadcastNotification);

export default router;