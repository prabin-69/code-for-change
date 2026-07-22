import jwt, { SignOptions } from 'jsonwebtoken';
import crypto from 'crypto';
import { env } from '../../config/env';

export class TokenService {
  static generateAccessToken(payload: { userId: string; role: string }): string {
    const options: SignOptions = {
      expiresIn: env.JWT_ACCESS_EXPIRES_IN as SignOptions['expiresIn'],
    };
    return jwt.sign(
      { sub: payload.userId, role: payload.role },
      env.JWT_ACCESS_SECRET,
      options,
    );
  }

  static generateRefreshToken(): { token: string; hash: string } {
    const token = crypto.randomBytes(64).toString('hex');
    const hash = crypto.createHash('sha256').update(token).digest('hex');
    return { token, hash };
  }

  static verifyAccessToken(token: string): jwt.JwtPayload | null {
    try {
      return jwt.verify(token, env.JWT_ACCESS_SECRET) as jwt.JwtPayload;
    } catch {
      return null;
    }
  }

  static verifyRefreshTokenHash(token: string, hash: string): boolean {
    const computedHash = crypto.createHash('sha256').update(token).digest('hex');
    return computedHash === hash;
  }
}
