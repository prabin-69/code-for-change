import { createHash } from 'crypto';
import { AuthRepository } from './auth.repository';
import { TokenService } from '../../shared/services/token.service';
import redis from '../../config/redis';
import {
  AppError,
  UnauthorizedError,
  RateLimitError,
} from '../../shared/utils/AppError';
import { eventBus } from '../../shared/events/event-bus';
import { User } from '@prisma/client';
import {
  OTP_TTL_SECONDS,
  OTP_RATE_LIMIT_MAX,
  OTP_RATE_LIMIT_WINDOW,
} from '../../shared/constants';

export class AuthService {
  private repository: AuthRepository;

  constructor() {
    this.repository = new AuthRepository();
  }

  private getOtpRedisKey(phone: string): string {
    return `otp:${phone}`;
  }

  private getOtpRateLimitKey(phone: string): string {
    return `otp_rate:${phone}`;
  }


  // ==========================
  // SEND OTP
  // ==========================
  async sendOtp(phone: string): Promise<void> {

    const rateKey = this.getOtpRateLimitKey(phone);

    // INCR + TTL check run in a single Redis pipeline so they can't be
    // split by a crash/restart between the two calls. Previously INCR and
    // EXPIRE were separate awaits; if the process died in between, the key
    // was left in Redis with a count but NO expiry, and (since EXPIRE was
    // only ever attempted on attempts === 1) it would then increment
    // forever and permanently block that phone number.
    const pipeline = redis.multi().incr(rateKey).ttl(rateKey);
    const results = await pipeline.exec();
    const attempts = results?.[0]?.[1] as number;
    const ttl = results?.[1]?.[1] as number;

    // ttl === -1 means the key exists but has no expiry set (either this
    // is genuinely the first attempt, or it's a stale/corrupted key left
    // over from before this fix). Either way, self-heal by attaching the
    // expiry now instead of only doing it when attempts === 1.
    if (ttl === -1) {
      await redis.expire(rateKey, OTP_RATE_LIMIT_WINDOW);
    }

    if (attempts > OTP_RATE_LIMIT_MAX) {
      throw new RateLimitError(
        'Too many OTP requests. Please try again later.'
      );
    }


    // Random 6 digit OTP
    const otp = Math.floor(
      100000 + Math.random() * 900000
    ).toString();


    const redisKey = this.getOtpRedisKey(phone);


    await redis.set(
      redisKey,
      otp,
      'EX',
      OTP_TTL_SECONDS
    );


    // Development OTP
    if (process.env.NODE_ENV !== 'production') {
      console.log('==========================');
      console.log(`📱 Demo OTP for ${phone}: ${otp}`);
      console.log('==========================');
    }


    // TODO: Add SMS provider here
  }



  // ==========================
  // VERIFY OTP
  // ==========================
  async verifyOtp(
    phone: string,
    otp: string,
    deviceInfo: any,
  ): Promise<{
    accessToken:string;
    refreshToken:string;
    user:User;
    isNewUser:boolean;
  }> {


    const redisKey = this.getOtpRedisKey(phone);

    const storedOtp = await redis.get(redisKey);


    if (!storedOtp) {
      throw new AppError(
        'OTP expired or not found',
        400
      );
    }


    if (storedOtp !== otp) {
      throw new AppError(
        'Invalid OTP',
        400
      );
    }


    await redis.del(redisKey);



    let user = await this.repository.findUserByPhone(phone);

    let isNewUser = false;



    if (!user) {

      user = await this.repository.createUser({
        phone_number: phone,
      });

      isNewUser = true;
    }



    if (!user.is_active) {
      throw new AppError(
        'Account is deactivated.',
        403
      );
    }



    await this.repository.updateUserLastLogin(user.id);



    const accessToken =
      TokenService.generateAccessToken({
        userId:user.id,
        role:user.role,
      });



    const {
      token:refreshToken,
      hash:refreshHash
    } = TokenService.generateRefreshToken();



    const expiresAt = new Date();

    expiresAt.setDate(
      expiresAt.getDate()+7
    );



    await this.repository.saveRefreshToken({

      userId:user.id,

      tokenHash:refreshHash,

      deviceInfo:deviceInfo || {},

      expiresAt,

    });



    if(isNewUser){

      eventBus.emit(
        'UserRegisteredEvent',
        {
          userId:user.id,
          phone:user.phone_number,
        }
      );

    }



    return {
      accessToken,
      refreshToken,
      user,
      isNewUser,
    };

  }




  // ==========================
  // SELECT ROLE
  // ==========================
  async selectRole(
    userId:string,
    role:'CUSTOMER'|'PROFESSIONAL'
  ):Promise<User>{


    const user =
      await this.repository.findUserById(userId);



    if(!user){

      throw new AppError(
        'User not found',
        404
      );

    }



    if(user.role_selected){

      throw new AppError(
        'Role already selected',
        400
      );

    }



    return this.repository.updateUserRole(
      userId,
      role
    );

  }





  // ==========================
  // REFRESH TOKEN
  // ==========================
  async refreshToken(
    refreshToken:string
  ):Promise<{
    accessToken:string;
    refreshToken:string;
  }> {


    const tokenHash =
      createHash('sha256')
      .update(refreshToken)
      .digest('hex');



    const storedToken =
      await this.repository.findRefreshTokenByHash(
        tokenHash
      );



    if(!storedToken || storedToken.revoked_at){

      throw new UnauthorizedError(
        'Invalid refresh token'
      );

    }



    await this.repository.revokeRefreshToken(
      storedToken.id
    );



    const accessToken =
      TokenService.generateAccessToken({

        userId:storedToken.user_id,

        role:(storedToken as any).user.role,

      });



    const {
      token:newRefreshToken,
      hash:newHash
    } =
    TokenService.generateRefreshToken();



    const expiresAt=new Date();

    expiresAt.setDate(
      expiresAt.getDate()+7
    );



    await this.repository.saveRefreshToken({

      userId:storedToken.user_id,

      tokenHash:newHash,

      deviceInfo:(storedToken as any).device_info || {},

      expiresAt,

    });



    return {
      accessToken,
      refreshToken:newRefreshToken,
    };

  }





  // ==========================
  // LOGOUT
  // ==========================
  async logout(refreshToken:string):Promise<void>{


    const tokenHash =
      createHash('sha256')
      .update(refreshToken)
      .digest('hex');



    const storedToken =
      await this.repository.findRefreshTokenByHash(
        tokenHash
      );



    if(storedToken){

      await this.repository.revokeRefreshToken(
        storedToken.id
      );

    }

  }





  // ==========================
  // LOGOUT ALL
  // ==========================
  async logoutAll(userId:string):Promise<void>{

    await this.repository.revokeAllUserRefreshTokens(
      userId
    );

  }




  // ==========================
  // PROFILE
  // ==========================
  async getUserProfile(
    userId:string
  ):Promise<User|null>{

    return this.repository.findUserById(
      userId
    );

  }


}