import { Request, Response, NextFunction } from 'express';
import { CustomersService } from './customers.service';
import { AuthRequest } from '../../shared/middlewares/auth';
import { CreateRequestDto, CancelRequestDto, CreateReviewDto } from './customers.dto';

export class CustomersController {
  private service: CustomersService;

  constructor() {
    this.service = new CustomersService();
  }

  // --- Requests ---
  createRequest = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const data = req.body as CreateRequestDto;
      const request = await this.service.createRequest(userId, data);
      res.status(201).json({
        success: true,
        data: request,
        message: 'Request created successfully',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getMyRequests = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { status } = req.query;
      const requests = await this.service.getCustomerRequests(userId, status as string);
      res.status(200).json({
        success: true,
        data: requests,
        message: 'Requests retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getRequestById = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { id } = req.params;
      const request = await this.service.getRequestById(userId, id);
      res.status(200).json({
        success: true,
        data: request,
        message: 'Request details',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  cancelRequest = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { id } = req.params;
      const { reason } = req.body as CancelRequestDto;
      const request = await this.service.cancelRequest(userId, id, reason);
      res.status(200).json({
        success: true,
        data: request,
        message: 'Request cancelled',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Jobs ---
  getMyJobs = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const jobs = await this.service.getCustomerJobs(userId);
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

  getJobById = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { id } = req.params;
      const job = await this.service.getJobById(userId, id);
      res.status(200).json({
        success: true,
        data: job,
        message: 'Job details',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Favorites ---
  getFavorites = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const favorites = await this.service.getFavorites(userId);
      res.status(200).json({
        success: true,
        data: favorites,
        message: 'Favorites retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  addFavorite = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { professionalId } = req.params;
      await this.service.addFavorite(userId, professionalId);
      res.status(201).json({
        success: true,
        data: null,
        message: 'Added to favorites',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  removeFavorite = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { professionalId } = req.params;
      await this.service.removeFavorite(userId, professionalId);
      res.status(200).json({
        success: true,
        data: null,
        message: 'Removed from favorites',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  // --- Reviews ---
  createReview = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const data = req.body as CreateReviewDto;
      const review = await this.service.createReview(userId, data);
      res.status(201).json({
        success: true,
        data: review,
        message: 'Review submitted',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getMyReviews = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const reviews = await this.service.getCustomerReviews(userId);
      res.status(200).json({
        success: true,
        data: reviews,
        message: 'Reviews retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };
}