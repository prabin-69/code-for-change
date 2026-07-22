import prisma from '../../config/database';
import { fcm } from '../../config/firebase';
import logger from '../../config/logger';

export class NotificationService {
  // Requires Manual Verification: Firebase FCM credentials must be set in FIREBASE_SERVICE_ACCOUNT
  async sendPushNotification(userId: string, title: string, body: string, data?: Record<string, string>) {
    try {
      const user = await prisma.user.findUnique({
        where: { id: userId },
        select: { fcm_tokens: true },
      });

      if (!user || !user.fcm_tokens || user.fcm_tokens.length === 0) {
        return;
      }

      const message = {
        notification: { title, body },
        data: data ?? {},
        tokens: user.fcm_tokens,
      };

      const response = await fcm.sendEachForMulticast(message);
      logger.info(`Push notification sent to ${userId}: ${response.successCount} successes`);
    } catch (error) {
      logger.error('Failed to send push notification:', error);
    }
  }

  async saveFCMToken(userId: string, token: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { fcm_tokens: true },
    });

    const tokens: string[] = user?.fcm_tokens ?? [];
    if (!tokens.includes(token)) {
      tokens.push(token);
      await prisma.user.update({
        where: { id: userId },
        data: { fcm_tokens: tokens },
      });
    }
  }

  async removeFCMToken(userId: string, token: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { fcm_tokens: true },
    });

    if (user) {
      const tokens = (user.fcm_tokens ?? []).filter((t: string) => t !== token);
      await prisma.user.update({
        where: { id: userId },
        data: { fcm_tokens: tokens },
      });
    }
  }
}
