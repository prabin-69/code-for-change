import dotenv from 'dotenv';
import { z } from 'zod';

dotenv.config();

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'staging', 'production']).default('development'),
  PORT: z.string().default('4000').transform(Number),
  DATABASE_URL: z.string().url(),
  REDIS_URL: z.string().url(),
  JWT_ACCESS_SECRET: z.string().min(32),
  JWT_REFRESH_SECRET: z.string().min(32),
  JWT_ACCESS_EXPIRES_IN: z.string().default('15m'),
  JWT_REFRESH_EXPIRES_IN: z.string().default('7d'),

  // SMS (Twilio) – Requires Manual Verification
  TWILIO_ACCOUNT_SID: z.string().optional(),
  TWILIO_AUTH_TOKEN: z.string().optional(),
  TWILIO_PHONE_NUMBER: z.string().optional(),

  // File Storage (S3 / Cloudflare R2) – Requires Manual Verification
  S3_ACCESS_KEY: z.string().optional(),
  S3_SECRET_KEY: z.string().optional(),
  S3_REGION: z.string().optional(),
  S3_BUCKET: z.string().optional(),

  // Frontend URLs
  CLIENT_URL: z.string().url().default('http://localhost:3000'),
  ADMIN_URL: z.string().url().default('http://localhost:3001'),

  // eSewa payment gateway – Requires Manual Verification
  ESEWA_BASE_URL: z.string().url().optional(),
  ESEWA_MERCHANT_CODE: z.string().optional(),
  ESEWA_SECRET_KEY: z.string().optional(),

  // Khalti payment gateway – Requires Manual Verification
  KHALTI_BASE_URL: z.string().url().optional(),
  KHALTI_SECRET_KEY: z.string().optional(),

  // Bank transfer details
  BANK_NAME: z.string().optional(),
  BANK_ACCOUNT: z.string().optional(),
  BANK_ACCOUNT_HOLDER: z.string().optional(),
  BANK_QR_BASE_URL: z.string().optional(),

  // Firebase Admin SDK – Requires Manual Verification
  FIREBASE_SERVICE_ACCOUNT: z.string().optional(),

  // Google Maps – Requires Manual Verification
  GOOGLE_MAPS_API_KEY: z.string().optional(),
});

const parsed = envSchema.safeParse(process.env);
if (!parsed.success) {
  console.error('❌ Invalid environment variables:', parsed.error.format());
  process.exit(1);
}

export const env = parsed.data;
