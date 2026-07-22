import logger from '../../config/logger';
import { env } from '../../config/env';

// We'll implement a mock and optionally integrate Twilio later.
export class SmsService {
  static async sendOtp(phone: string, otp: string): Promise<void> {
    // In development, just log the OTP.
    if (env.NODE_ENV !== 'production') {
      logger.info(`[SMS Mock] OTP for ${phone}: ${otp}`);
      return;
    }

    // Production: use Twilio or other provider.
    // const twilioClient = require('twilio')(env.TWILIO_ACCOUNT_SID, env.TWILIO_AUTH_TOKEN);
    // await twilioClient.messages.create({
    //   body: `Your verification code is: ${otp}`,
    //   from: env.TWILIO_PHONE_NUMBER,
    //   to: phone,
    // });
  }
}