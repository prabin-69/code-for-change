export const USER_ROLES = {
  CUSTOMER: 'CUSTOMER',
  PROFESSIONAL: 'PROFESSIONAL',
  ADMIN: 'ADMIN',
  SUPER_ADMIN: 'SUPER_ADMIN',
  SUPPORT_ADMIN: 'SUPPORT_ADMIN',
} as const;

export type UserRole = typeof USER_ROLES[keyof typeof USER_ROLES];

export const JWT_ALGORITHM = 'HS256';
export const OTP_LENGTH = 6;
export const OTP_TTL_SECONDS = 300; // 5 minutes
export const OTP_RATE_LIMIT_WINDOW = 60; // seconds — max OTP_RATE_LIMIT_MAX requests per 60s per phone number
export const OTP_RATE_LIMIT_MAX = 10;

export const API_VERSION = 'v1';
export const API_BASE = `/api/${API_VERSION}`;