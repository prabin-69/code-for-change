import http from 'http';
import { Server as SocketIOServer } from 'socket.io';
// Side-effect import: augments Socket with userId / userRole
import app from './app';
import { env } from './config/env';
import logger from './config/logger';
import prisma from './config/database';
import redis from './config/redis';
import { TokenService } from './shared/services/token.service';
import { setupSocketHandlers } from './modules/chat/chat.socket';

const PORT = env.PORT;

async function startServer() {
  try {
    // Connect Redis
    await redis.connect();
    logger.info('✅ Redis connected');

    // Verify DB connection
    await prisma.$connect();
    logger.info('✅ Database connected');

    // Create HTTP server
    const httpServer = http.createServer(app);

    // Socket.IO setup
    const io = new SocketIOServer(httpServer, {
      cors: {
        origin: [env.CLIENT_URL, env.ADMIN_URL],
        credentials: true,
      },
      transports: ['websocket', 'polling'],
    });

    // Authenticate socket connections
    io.use(async (socket, next) => {
      try {
        const token = socket.handshake.auth?.token as string | undefined;
        if (!token) return next(new Error('Authentication required'));

        const decoded = TokenService.verifyAccessToken(token);
        if (!decoded) return next(new Error('Invalid token'));

        // Attach user identity using the augmented Socket interface
        // (no unsafe `as any` cast required)
        socket.userId   = decoded.sub as string;
        socket.userRole = decoded.role as string;
        next();
      } catch {
        next(new Error('Authentication error'));
      }
    });

    // Register Socket.IO event handlers
    setupSocketHandlers(io);

    // Start listening
    httpServer.listen(PORT, () => {
      logger.info(`🚀 Server running on port ${PORT} (${env.NODE_ENV})`);
      logger.info(`📖 API docs: http://localhost:${PORT}/api-docs`);
      logger.info(`🔌 Socket.IO ready`);
    });

    // Graceful shutdown
    const shutdown = async (signal: string) => {
      logger.info(`${signal} received – shutting down gracefully`);
      httpServer.close(async () => {
        await prisma.$disconnect();
        await redis.quit();
        logger.info('Server closed');
        process.exit(0);
      });
    };

    process.on('SIGTERM', () => shutdown('SIGTERM'));
    process.on('SIGINT',  () => shutdown('SIGINT'));
    process.on('unhandledRejection', (reason) => {
      logger.error({ reason }, 'Unhandled Promise Rejection');
    });
    process.on('uncaughtException', (err) => {
      logger.error({ err }, 'Uncaught Exception – shutting down');
      process.exit(1);
    });
  } catch (err) {
    logger.error({ err }, 'Failed to start server');
    process.exit(1);
  }
}

startServer();
