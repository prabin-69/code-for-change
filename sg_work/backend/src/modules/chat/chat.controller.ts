import { Request, Response, NextFunction } from 'express';
import { AuthRequest } from '../../shared/middlewares/auth';
import { ChatService } from './chat.service';

export class ChatController {
  private service: ChatService;

  constructor() {
    this.service = new ChatService();
  }

  getRecentChats = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const chats = await this.service.getRecentChats(userId);
      res.status(200).json({
        success: true,
        data: chats,
        message: 'Recent chats retrieved',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getMessages = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const { userId: otherUserId } = req.params;
      const { jobId, limit, offset } = req.query;
      const messages = await this.service.getMessages(
        userId,
        otherUserId,
        jobId as string,
        limit ? parseInt(limit as string) : 50,
        offset ? parseInt(offset as string) : 0
      );
      res.status(200).json({
        success: true,
        data: messages,
        message: 'Messages retrieved',
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
      const { userId: senderId } = req.params;
      const { jobId } = req.body;
      await this.service.markAsRead(userId, senderId, jobId);
      res.status(200).json({
        success: true,
        data: null,
        message: 'Messages marked as read',
        errors: null,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  };

  getUnreadCount = async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.user!.id;
      const count = await this.service.getUnreadCount(userId);
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
}