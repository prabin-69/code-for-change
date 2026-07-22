import { Request, Response, NextFunction } from 'express';
import { AppError } from '../utils/AppError';
import logger from '../../config/logger';
import { env } from '../../config/env';

export const errorHandler = (
  err: Error | AppError,
  req: Request,
  res: Response,
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  next: NextFunction
) => {
  const isAppError = err instanceof AppError;

  // Log error
  logger.error({
    err,
    req: {
      method: req.method,
      url: req.url,
      body: req.body,
      user: (req as any).user?.id,
    },
  });

  if (isAppError && err.isOperational) {
    return res.status(err.statusCode).json({
      success: false,
      data: null,
      message: err.message,
      errors: err.details || null,
      timestamp: new Date().toISOString(),
    });
  }

  // Non-operational (programming errors) - don't leak details in production
  const statusCode = 500;
  const message = env.NODE_ENV === 'production' ? 'Internal Server Error' : err.message;

  res.status(statusCode).json({
    success: false,
    data: null,
    message: message,
    errors: env.NODE_ENV === 'development' ? err.stack : null,
    timestamp: new Date().toISOString(),
  });
};