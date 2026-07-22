import { z } from 'zod';

export const sendOtpSchema = z.object({
  body: z.object({
    phone: z.string().regex(/^\+[1-9]\d{1,14}$/, 'Phone must be in E.164 format'),
  }),
});

export const verifyOtpSchema = z.object({
  body: z.object({
    phone: z.string().regex(/^\+[1-9]\d{1,14}$/),
    otp: z.string().length(6, 'OTP must be 6 digits'),
  }),
});

export const refreshTokenSchema = z.object({
  body: z.object({
    refresh_token: z.string().min(64, 'Invalid refresh token'),
  }),
});

export const selectRoleSchema = z.object({
  body: z.object({
    role: z.enum(['CUSTOMER', 'PROFESSIONAL'], {
      errorMap: () => ({ message: 'Role must be either CUSTOMER or PROFESSIONAL' }),
    }),
  }),
});