import { eventBus } from '../../shared/events/event-bus';
import prisma from '../../config/database';
import logger from '../../config/logger';

eventBus.on('PaymentCompletedEvent', async (data: any) => {
  if (data.type !== 'SUBSCRIPTION') return;
  if (!data.relatedId) {
    logger.warn('PaymentCompletedEvent: relatedId missing for subscription');
    return;
  }

  try {
    // Activate the subscription — use starts_at (schema field name)
    const subscription = await prisma.subscription.update({
      where: { id: data.relatedId },
      data: {
        status: 'active',
        starts_at: new Date(),
      },
    });
    logger.info(`Subscription activated: ${subscription.id} for user ${data.userId}`);
  } catch (error) {
    logger.error('Failed to activate subscription on payment success:', error);
  }
});
