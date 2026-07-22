import { Response, NextFunction } from 'express';
import { AuthRequest } from '../../shared/middlewares/auth';
import prisma from '../../config/database';

export class NotificationController {
  getMyNotifications = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { limit = '20', page = '1' } = req.query;
      const lim = Math.min(parseInt(limit as string), 100);
      const offset = (parseInt(page as string) - 1) * lim;

      const [notifications, total] = await Promise.all([
        prisma.notification.findMany({
          where: { user_id: userId },
          orderBy: { created_at: 'desc' },
          take: lim,
          skip: offset,
        }),
        prisma.notification.count({ where: { user_id: userId } }),
      ]);

      res.status(200).json({
        success: true,
        data: { notifications, total, page: parseInt(page as string), limit: lim },
        message: 'Notifications retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  markAsRead = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { id } = req.params;

      await prisma.notification.updateMany({
        where: { id, user_id: userId },
        data: { is_read: true },
      });

      res.status(200).json({
        success: true,
        data: null,
        message: 'Notification marked as read',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  markAllAsRead = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      await prisma.notification.updateMany({
        where: { user_id: userId, is_read: false },
        data: { is_read: true },
      });
      res.status(200).json({
        success: true,
        data: null,
        message: 'All notifications marked as read',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getUnreadCount = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const count = await prisma.notification.count({
        where: { user_id: req.user!.id, is_read: false },
      });
      res.status(200).json({
        success: true,
        data: { count },
        message: 'Unread count retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  deleteNotification = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { id } = req.params;
      await prisma.notification.deleteMany({ where: { id, user_id: userId } });
      res.status(200).json({
        success: true,
        data: null,
        message: 'Notification deleted',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };
}
