import { eventBus } from '../../shared/events/event-bus';
import logger from '../../config/logger';

eventBus.on('UserRegisteredEvent', (data: { userId: string; phone: string }) => {
  logger.info(`New user registered: ${data.phone} (ID: ${data.userId})`);
  // Here we can initialize default subscription, send welcome notification, etc.
});