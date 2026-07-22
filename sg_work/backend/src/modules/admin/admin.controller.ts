import { Request, Response, NextFunction } from 'express';
import { AuthRequest } from '../../shared/middlewares/auth';
import { AdminService } from './admin.service';
import {
  UpdateUserStatusDto,
  UpdateProfessionalVerificationDto,
  ManageFeaturedDto,
  CreateCategoryDto,
  CreateProfessionDto,
  ResolveReportDto,
  BroadcastNotificationDto,
} from './admin.dto';

export class AdminController {
  private service: AdminService;

  constructor() {
    this.service = new AdminService();
  }

  // --- Dashboard ---
  getDashboardStats = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const stats = await this.service.getDashboardStats();
      res.status(200).json({
        success: true,
        data: stats,
        message: 'Dashboard stats retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Users ---
  getUsers = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { role, is_active, search } = req.query;
      const users = await this.service.getAllUsers({
        role: role as string,
        is_active: is_active === 'true' ? true : is_active === 'false' ? false : undefined,
        search: search as string,
      });
      res.status(200).json({
        success: true,
        data: users,
        message: 'Users retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getUserDetails = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { userId } = req.params;
      const user = await this.service.getUserDetails(userId);
      res.status(200).json({
        success: true,
        data: user,
        message: 'User details retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  updateUserStatus = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { userId } = req.params;
      const { is_active } = req.body as UpdateUserStatusDto;
      const user = await this.service.updateUserStatus(userId, is_active);
      res.status(200).json({
        success: true,
        data: user,
        message: 'User status updated',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Professionals ---
  getProfessionals = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { verification_status, is_featured, availability, search } = req.query;
      const professionals = await this.service.getAllProfessionals({
        verification_status: verification_status as string,
        is_featured: is_featured === 'true' ? true : is_featured === 'false' ? false : undefined,
        availability: availability as string,
        search: search as string,
      });
      res.status(200).json({
        success: true,
        data: professionals,
        message: 'Professionals retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getProfessionalDetails = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { professionalId } = req.params;
      const profile = await this.service.getProfessionalDetails(professionalId);
      res.status(200).json({
        success: true,
        data: profile,
        message: 'Professional details retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  updateVerification = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { professionalId } = req.params;
      const { status, rejection_reason, admin_notes } = req.body as UpdateProfessionalVerificationDto;
      const adminId = req.user!.id;
      const result = await this.service.updateProfessionalVerification(
        professionalId,
        status,
        rejection_reason,
        admin_notes,
        adminId
      );
      res.status(200).json({
        success: true,
        data: result,
        message: `Professional ${status}`,
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  updateFeatured = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { professionalId } = req.params;
      const { is_featured, duration_days } = req.body as ManageFeaturedDto;
      const result = await this.service.updateFeaturedStatus(professionalId, is_featured, duration_days);
      res.status(200).json({
        success: true,
        data: result,
        message: `Featured status updated to ${is_featured}`,
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Categories ---
  createCategory = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { name, icon } = req.body as CreateCategoryDto;
      const category = await this.service.createCategory(name, icon);
      res.status(201).json({
        success: true,
        data: category,
        message: 'Category created',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  updateCategory = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { categoryId } = req.params;
      const data = req.body;
      const category = await this.service.updateCategory(categoryId, data);
      res.status(200).json({
        success: true,
        data: category,
        message: 'Category updated',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  deleteCategory = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { categoryId } = req.params;
      const category = await this.service.deleteCategory(categoryId);
      res.status(200).json({
        success: true,
        data: category,
        message: 'Category deleted',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Professions ---
  createProfession = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { name, category_id } = req.body as CreateProfessionDto;
      const profession = await this.service.createProfession(name, category_id);
      res.status(201).json({
        success: true,
        data: profession,
        message: 'Profession created',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  updateProfession = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { professionId } = req.params;
      const data = req.body;
      const profession = await this.service.updateProfession(professionId, data);
      res.status(200).json({
        success: true,
        data: profession,
        message: 'Profession updated',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  deleteProfession = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { professionId } = req.params;
      const profession = await this.service.deleteProfession(professionId);
      res.status(200).json({
        success: true,
        data: profession,
        message: 'Profession deleted',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Jobs ---
  getJobs = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { status, category_id, profession_id, date_from, date_to } = req.query;
      const jobs = await this.service.getAllJobs({
        status: status as string,
        category_id: category_id as string,
        profession_id: profession_id as string,
        date_from: date_from ? new Date(date_from as string) : undefined,
        date_to: date_to ? new Date(date_to as string) : undefined,
      });
      res.status(200).json({
        success: true,
        data: jobs,
        message: 'Jobs retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Reports ---
  getReports = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { status } = req.query;
      const reports = await this.service.getAllReports(status as string);
      res.status(200).json({
        success: true,
        data: reports,
        message: 'Reports retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  resolveReport = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { reportId } = req.params;
      const { admin_note, action } = req.body as ResolveReportDto;
      const report = await this.service.resolveReport(reportId, admin_note, action);
      res.status(200).json({
        success: true,
        data: report,
        message: 'Report resolved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Analytics ---
  getAnalytics = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { timeframe } = req.query;
      const analytics = await this.service.getAnalytics(timeframe as any);
      res.status(200).json({
        success: true,
        data: analytics,
        message: 'Analytics retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Payments ---
  getPayments = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { status, type, date_from, date_to } = req.query;
      const payments = await this.service.getAllPayments({
        status: status as string,
        type: type as string,
        date_from: date_from ? new Date(date_from as string) : undefined,
        date_to: date_to ? new Date(date_to as string) : undefined,
      });
      res.status(200).json({
        success: true,
        data: payments,
        message: 'Payments retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Subscriptions ---
  getSubscriptions = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { status, plan } = req.query;
      const subscriptions = await this.service.getAllSubscriptions({
        status: status as string,
        plan: plan as string,
      });
      res.status(200).json({
        success: true,
        data: subscriptions,
        message: 'Subscriptions retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Broadcast Notification ---
  broadcastNotification = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const data = req.body as BroadcastNotificationDto;
      const notifications = await this.service.broadcastNotification(data);
      res.status(201).json({
        success: true,
        data: notifications,
        message: 'Notifications sent',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };
}