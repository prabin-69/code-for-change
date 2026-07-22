import prisma from '../../config/database';
import { User } from '@prisma/client';
import { NotFoundError } from '../../shared/utils/AppError';

export class UsersService {
  async getProfile(userId: string): Promise<User> {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new NotFoundError('User not found');
    return user;
  }

  async updateProfile(
    userId: string,
    data: { first_name?: string; last_name?: string; photo_url?: string },
  ): Promise<User> {
    return prisma.user.update({
      where: { id: userId },
      data: {
        ...(data.first_name !== undefined && { first_name: data.first_name }),
        ...(data.last_name !== undefined && { last_name: data.last_name }),
        ...(data.photo_url !== undefined && { photo_url: data.photo_url }),
      },
    });
  }

  async saveFCMToken(userId: string, token: string): Promise<void> {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { fcm_tokens: true },
    });
    const tokens: string[] = user?.fcm_tokens ?? [];
    if (!tokens.includes(token)) {
      tokens.push(token);
      await prisma.user.update({ where: { id: userId }, data: { fcm_tokens: tokens } });
    }
  }

  async removeFCMToken(userId: string, token: string): Promise<void> {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { fcm_tokens: true },
    });
    if (user) {
      const tokens = (user.fcm_tokens ?? []).filter((t: string) => t !== token);
      await prisma.user.update({ where: { id: userId }, data: { fcm_tokens: tokens } });
    }
  }

  async deleteAccount(userId: string): Promise<void> {
    // Soft-delete: deactivate
    await prisma.user.update({ where: { id: userId }, data: { is_active: false } });
  }
}
