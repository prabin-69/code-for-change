import axios from 'axios';
import crypto from 'crypto';
import { env } from '../../../config/env';
import logger from '../../../config/logger';
import { AppError } from '../../../shared/utils/AppError';

interface EsewaInitiatePayload {
  amount: number;
  productId: string;
  productName: string;
  productDesc?: string;
  successUrl: string;
  failureUrl: string;
}

export class EsewaService {
  private readonly baseUrl: string;
  private readonly merchantCode: string;
  private readonly secretKey: string;

  constructor() {
    this.baseUrl     = env.ESEWA_BASE_URL      ?? 'https://uat.esewa.com.np/api/epay/main/v2';
    this.merchantCode = env.ESEWA_MERCHANT_CODE ?? '';
    this.secretKey   = env.ESEWA_SECRET_KEY    ?? '';
  }

  /** Guard: throws a 503 if the gateway is not fully configured. */
  private assertConfigured(): void {
    if (!this.merchantCode || !this.secretKey) {
      throw new AppError(
        'eSewa payment gateway is not configured. ' +
        'Set ESEWA_MERCHANT_CODE and ESEWA_SECRET_KEY in your .env file.',
        503,
      );
    }
  }

  /** Initiate a payment with eSewa. */
  async initiatePayment(payload: EsewaInitiatePayload): Promise<any> {
    this.assertConfigured();

    const data = {
      amount:       payload.amount,
      product_id:   payload.productId,
      product_name: payload.productName,
      product_desc: payload.productDesc ?? '',
      success_url:  payload.successUrl,
      failure_url:  payload.failureUrl,
      merchant_id:  this.merchantCode,
    };

    const signature = this.generateSignature(data);
    const requestData = { ...data, signature };

    try {
      const response = await axios.post(`${this.baseUrl}/initiate`, requestData, {
        headers: { 'Content-Type': 'application/json' },
      });
      return response.data;
    } catch (error) {
      logger.error({ error }, 'eSewa initiation error');
      throw new Error('eSewa payment initiation failed');
    }
  }

  /** Verify a payment after the success redirect. */
  async verifyPayment(transactionId: string, amount: number): Promise<boolean> {
    this.assertConfigured();

    try {
      const response = await axios.get(`${this.baseUrl}/verify`, {
        params: { transaction_id: transactionId, amount },
      });
      return response.data.status === 'success';
    } catch (error) {
      logger.error({ error }, 'eSewa verification error');
      return false;
    }
  }

  /** HMAC-SHA256 signature used to sign payment requests sent to eSewa. */
  private generateSignature(data: Record<string, unknown>): string {
    const hmac = crypto.createHmac('sha256', this.secretKey);
    hmac.update(JSON.stringify(data));
    return hmac.digest('hex');
  }
}
