import prisma from '../../config/database';
import { User, RefreshToken } from '@prisma/client';

export class AuthRepository {
  async findUserByPhone(phone: string): Promise<User | null> {
    return prisma.user.findUnique({
      where: { phone_number: phone },
    });
  }

  async findUserById(id: string): Promise<User | null> {
    return prisma.user.findUnique({
      where: { id },
    });
  }

  async createUser(data: {
    phone_number: string;
    first_name?: string;
    last_name?: string;
    role?: 'CUSTOMER' | 'PROFESSIONAL' | 'ADMIN' | 'SUPER_ADMIN' | 'SUPPORT_ADMIN';
  }): Promise<User> {
    return prisma.user.create({
      data: {
        phone_number: data.phone_number,
        first_name: data.first_name,
        last_name: data.last_name,
        // `role` still needs a concrete DB value (it's a NOT NULL enum), but
        // `role_selected: false` is what actually marks this as a brand-new
        // account that must go through the Choose Customer/Professional
        // screen. Never mark a freshly created user as having selected a
        // role, regardless of what default is passed in.
        role: data.role || 'CUSTOMER',
        role_selected: false,
        is_active: true,
      },
    });
  }

  async updateUserRole(
    userId: string,
    role: 'CUSTOMER' | 'PROFESSIONAL',
  ): Promise<User> {
    return prisma.user.update({
      where: { id: userId },
      data: {
        role,
        role_selected: true,
      },
    });
  }

  async saveRefreshToken(data: {
    userId: string;
    tokenHash: string;
    deviceInfo: any;
    expiresAt: Date;
  }): Promise<RefreshToken> {
    return prisma.refreshToken.create({
      data: {
        user_id: data.userId,
        token_hash: data.tokenHash,
        device_info: data.deviceInfo,
        expires_at: data.expiresAt,
      },
    });
  }

  async findRefreshTokenByHash(
    tokenHash: string,
  ): Promise<(RefreshToken & { user: User }) | null> {
    return prisma.refreshToken.findUnique({
      where: { token_hash: tokenHash },
      include: { user: true },
    }) as Promise<(RefreshToken & { user: User }) | null>;
  }

  async revokeRefreshToken(id: string): Promise<void> {
    await prisma.refreshToken.update({
      where: { id },
      data: { revoked_at: new Date() },
    });
  }

  async revokeAllUserRefreshTokens(userId: string): Promise<void> {
    await prisma.refreshToken.updateMany({
      where: { user_id: userId, revoked_at: null },
      data: { revoked_at: new Date() },
    });
  }

  async updateUserLastLogin(userId: string): Promise<void> {
    await prisma.user.update({
      where: { id: userId },
      data: { last_login_at: new Date() },
    });
  }
}
