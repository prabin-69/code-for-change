import prisma from '../../config/database';
import { Subscription } from '@prisma/client';
import { AppError, NotFoundError, ConflictError } from '../../shared/utils/AppError';

const PLAN_DURATIONS: Record<string, number> = {
  basic: 30,
  pro: 90,
  premium: 365,
};

export class SubscriptionsService {
  async createSubscription(userId: string, plan: string): Promise<Subscription> {
    if (!PLAN_DURATIONS[plan]) {
      throw new AppError(`Invalid plan. Valid plans: ${Object.keys(PLAN_DURATIONS).join(', ')}`, 400);
    }

    const existing = await prisma.subscription.findFirst({
      where: { customer_id: userId, status: 'active' },
    });
    if (existing) {
      throw new ConflictError('You already have an active subscription. Cancel it first.');
    }

    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + PLAN_DURATIONS[plan]);

    return prisma.subscription.create({
      data: {
        customer_id: userId,
        plan,
        status: 'active',
        starts_at: new Date(),
        expires_at: expiresAt,
      },
    });
  }

  async getMySubscription(userId: string): Promise<Subscription | null> {
    return prisma.subscription.findFirst({
      where: { customer_id: userId },
      orderBy: { created_at: 'desc' },
    });
  }

  async getSubscriptionHistory(userId: string): Promise<Subscription[]> {
    return prisma.subscription.findMany({
      where: { customer_id: userId },
      orderBy: { created_at: 'desc' },
    });
  }

  async cancelSubscription(userId: string): Promise<Subscription> {
    const sub = await prisma.subscription.findFirst({
      where: { customer_id: userId, status: 'active' },
    });
    if (!sub) throw new NotFoundError('No active subscription found');

    return prisma.subscription.update({
      where: { id: sub.id },
      data: { status: 'cancelled' },
    });
  }

  // Called by admin or cron to expire subscriptions
  async expireOverdue(): Promise<number> {
    const result = await prisma.subscription.updateMany({
      where: {
        status: 'active',
        expires_at: { lt: new Date() },
      },
      data: { status: 'expired' },
    });
    return result.count;
  }
}
