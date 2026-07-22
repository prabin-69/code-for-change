import { Request, Response, NextFunction } from 'express';
import { UnauthorizedError, ForbiddenError } from '../utils/AppError';
import { TokenService } from '../services/token.service';
import { AuthRepository } from '../../modules/auth/auth.repository';

export interface AuthRequest extends Request {
  user?: {
    id: string;
    role: string;
  };
}

const authRepo = new AuthRepository();

export const authenticate = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new UnauthorizedError('No token provided');
    }

    const token = authHeader.split(' ')[1];
    const decoded = TokenService.verifyAccessToken(token);

    if (!decoded) {
      throw new UnauthorizedError('Invalid or expired token');
    }

    // Check if user exists and is active
    const user = await authRepo.findUserById(decoded.sub as string);
    if (!user) {
      throw new UnauthorizedError('User not found');
    }
    if (!user.is_active) {
      throw new UnauthorizedError('Account deactivated');
    }

    (req as AuthRequest).user = {
      id: user.id,
      role: user.role,
    };

    next();
  } catch (error) {
    next(error);
  }
};

export const authorize = (allowedRoles: string[]) => {
  return (req: Request, res: Response, next: NextFunction) => {
    const user = (req as AuthRequest).user;
    if (!user) {
      throw new UnauthorizedError('Not authenticated');
    }
    if (!allowedRoles.includes(user.role)) {
      throw new ForbiddenError('Insufficient permissions');
    }
    next();
  };
};