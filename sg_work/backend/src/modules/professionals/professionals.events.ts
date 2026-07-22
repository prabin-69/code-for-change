import { eventBus } from '../../shared/events/event-bus';
import prisma from '../../config/database';
import logger from '../../config/logger';

eventBus.on('PaymentCompletedEvent', async (data: any) => {
  if (data.type !== 'VERIFICATION_FEE') return;
  if (!data.relatedId) {
    logger.warn('PaymentCompletedEvent: relatedId missing for verification fee');
    return;
  }

  try {
    // Update professional profile: set verification fee paid and create verification request
    const professional = await prisma.professionalProfile.update({
      where: { user_id: data.relatedId },
      data: {
        verification_fee_paid: true,
      },
    });

    // Create verification request if not exists
    const existing = await prisma.verificationRequest.findUnique({
      where: { professional_id: data.relatedId },
    });
    if (!existing) {
      await prisma.verificationRequest.create({
        data: {
          professional_id: data.relatedId,
          status: 'pending',
          submitted_at: new Date(),
        },
      });
    }
    logger.info(`Verification fee paid for professional ${data.relatedId}`);
  } catch (error) {
    logger.error('Failed to process verification fee payment:', error);
  }
});