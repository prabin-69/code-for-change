import Redis from 'ioredis';
import logger from './logger';
import { env } from './env';

const redis = new Redis(env.REDIS_URL, {
  lazyConnect: true,
  retryStrategy: (times) => Math.min(times * 50, 2000),
});

redis.on('connect', () => {
  logger.info('Redis connected');
});

redis.on('error', (err) => {
  logger.error('Redis error:', err);
});

// Connect on startup (handled in server.ts)
export default redis;