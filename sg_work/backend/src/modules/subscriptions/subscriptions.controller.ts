import { Response, NextFunction } from 'express';
import { AuthRequest } from '../../shared/middlewares/auth';
import { SubscriptionsService } from './subscriptions.service';

export class SubscriptionsController {
  private service: SubscriptionsService;

  constructor() {
    this.service = new SubscriptionsService();
  }

  subscribe = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { plan } = req.body;
      const subscription = await this.service.createSubscription(req.user!.id, plan);
      res.status(201).json({
        success: true,
        data: subscription,
        message: 'Subscription created',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getMySubscription = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const subscription = await this.service.getMySubscription(req.user!.id);
      res.status(200).json({
        success: true,
        data: subscription,
        message: 'Subscription retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getHistory = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const history = await this.service.getSubscriptionHistory(req.user!.id);
      res.status(200).json({
        success: true,
        data: history,
        message: 'Subscription history retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  cancel = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const subscription = await this.service.cancelSubscription(req.user!.id);
      res.status(200).json({
        success: true,
        data: subscription,
        message: 'Subscription cancelled',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };
}
