import express, { Express, Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import rateLimit from 'express-rate-limit';
import swaggerUi from 'swagger-ui-express';
import { env } from './config/env';
import logger from './config/logger';
import { errorHandler } from './shared/middlewares/errorHandler';
import { NotFoundError } from './shared/utils/AppError';
import { specs } from './swagger';

// Import routes
import authRoutes           from './modules/auth/auth.routes';
import categoriesRoutes     from './modules/categories/categories.routes';
import professionsRoutes    from './modules/professionals/professions.routes';
import customersRoutes      from './modules/customers/customers.routes';
import adminRoutes          from './modules/admin/admin.routes';
import paymentsRoutes       from './modules/payments/payments.routes';
import professionalsRoutes  from './modules/professionals/professionals.routes';
import searchRoutes         from './modules/search/search.routes';
import usersRoutes          from './modules/users/users.routes';
import notificationsRoutes  from './modules/notifications/notification.routes';
import subscriptionsRoutes  from './modules/subscriptions/subscriptions.routes';

// Import event listeners (side-effect only)
import './modules/auth/auth.events';
import './modules/subscriptions/subscriptions.events';
import './modules/professionals/professionals.events';

const app: Express = express();

// Security middleware
app.use(helmet());
app.use(cors({
  origin: true,
  credentials: true,
}));
app.use(compression());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  standardHeaders: true,
  legacyHeaders: false,
  handler: (_req, res) => {
    res.status(429).json({
      success: false,
      message: 'Too many requests, please try again later.',
    });
  },
});
app.use('/api', limiter);

// Body parser
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Request logging
app.use((req, _res, next) => {
  logger.info({ method: req.method, url: req.url, ip: req.ip });
  next();
});

// Health check
app.get('/health', (_req: Request, res: Response) => {
  res.status(200).json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    env: env.NODE_ENV,
  });
});

// Swagger API docs
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(specs));

// API routes
app.use('/api/v1/auth',          authRoutes);
app.use('/api/v1/categories',    categoriesRoutes);
app.use('/api/v1/professions',   professionsRoutes);
app.use('/api/v1/professionals', professionalsRoutes);
app.use('/api/v1/customers',     customersRoutes);
app.use('/api/v1/payments',      paymentsRoutes);
app.use('/api/v1/admin',         adminRoutes);
app.use('/api/v1/search',        searchRoutes);
app.use('/api/v1/users',         usersRoutes);
app.use('/api/v1/notifications', notificationsRoutes);
app.use('/api/v1/subscriptions', subscriptionsRoutes);

// 404 handler
app.use('*', (req: Request, _res: Response, next) => {
  next(new NotFoundError(`Route ${req.originalUrl} not found`));
});

// Global error handler
app.use(errorHandler);

export default app;
