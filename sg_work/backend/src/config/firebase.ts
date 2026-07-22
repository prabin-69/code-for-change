import * as admin from 'firebase-admin';
import { env } from './env';
import logger from './logger';

// Firebase Admin SDK – Requires Manual Verification
// Set FIREBASE_SERVICE_ACCOUNT to the JSON-stringified service account key.
let fcmInstance: admin.messaging.Messaging | null = null;

try {
  const raw = env.FIREBASE_SERVICE_ACCOUNT;
  if (raw && raw.trim() !== '{}' && raw.trim() !== '') {
    const serviceAccount = JSON.parse(raw) as admin.ServiceAccount;
    if (!admin.apps.length) {
      admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
    }
    fcmInstance = admin.messaging();
    logger.info('✅ Firebase Admin SDK initialized');
  } else {
    logger.warn('⚠️  FIREBASE_SERVICE_ACCOUNT not set – push notifications disabled');
  }
} catch (err) {
  logger.error('Failed to initialize Firebase Admin SDK:', err);
}

// Stub that no-ops when Firebase is not configured
const noopFcm = {
  sendEachForMulticast: async (_msg: any) => {
    logger.warn('FCM not configured – notification skipped');
    return { successCount: 0, failureCount: 0, responses: [] };
  },
} as unknown as admin.messaging.Messaging;

export const fcm: admin.messaging.Messaging = fcmInstance ?? noopFcm;
