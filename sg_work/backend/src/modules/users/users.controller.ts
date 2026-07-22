import { Response, NextFunction } from 'express';
import { AuthRequest } from '../../shared/middlewares/auth';
import { UsersService } from './users.service';

export class UsersController {
  private service: UsersService;

  constructor() {
    this.service = new UsersService();
  }

  getProfile = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const user = await this.service.getProfile(req.user!.id);
      res.status(200).json({
        success: true,
        data: {
          id: user.id,
          phone: user.phone_number,
          first_name: user.first_name,
          last_name: user.last_name,
          photo_url: user.photo_url,
          role: user.role,
          role_selected: user.role_selected,
          is_active: user.is_active,
        },
        message: 'Profile retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  updateProfile = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { first_name, last_name, photo_url } = req.body;
      const user = await this.service.updateProfile(req.user!.id, {
        first_name,
        last_name,
        photo_url,
      });
      res.status(200).json({
        success: true,
        data: {
          id: user.id,
          phone: user.phone_number,
          first_name: user.first_name,
          last_name: user.last_name,
          photo_url: user.photo_url,
          role: user.role,
          role_selected: user.role_selected,
        },
        message: 'Profile updated',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  saveFCMToken = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { token } = req.body;
      if (!token) {
        return res.status(400).json({
          success: false,
          data: null,
          message: 'FCM token is required',
          errors: null,
          timestamp: new Date().toISOString(),
        });
      }
      await this.service.saveFCMToken(req.user!.id, token);
      res.status(200).json({
        success: true,
        data: null,
        message: 'FCM token saved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  removeFCMToken = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const { token } = req.body;
      await this.service.removeFCMToken(req.user!.id, token);
      res.status(200).json({
        success: true,
        data: null,
        message: 'FCM token removed',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  deleteAccount = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      await this.service.deleteAccount(req.user!.id);
      res.status(200).json({
        success: true,
        data: null,
        message: 'Account deactivated',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };
}
