import axios from 'axios';
import { env } from '../../../config/env';
import logger from '../../../config/logger';
import { AppError } from '../../../shared/utils/AppError';

export class KhaltiService {
  private readonly baseUrl: string;
  private readonly secretKey: string;

  constructor() {
    this.baseUrl = env.KHALTI_BASE_URL ?? 'https://a.khalti.com/api/v2';
    this.secretKey = env.KHALTI_SECRET_KEY ?? '';
  }

  /** Guard: throws a 503 if the gateway is not configured. */
  private assertConfigured(): void {
    if (!this.secretKey) {
      throw new AppError(
        'Khalti payment gateway is not configured. ' +
        'Set KHALTI_SECRET_KEY in your .env file.',
        503,
      );
    }
  }

  async initiatePayment(payload: {
    amount: number;
    productName: string;
    productId: string;
    returnUrl: string;
  }) {
    this.assertConfigured();

    const data = {
      amount: payload.amount * 100, // Khalti expects amount in paisa
      product_name: payload.productName,
      product_identity: payload.productId,
      return_url: payload.returnUrl,
    };

    try {
      const response = await axios.post(`${this.baseUrl}/epayment/initiate/`, data, {
        headers: {
          Authorization: `Key ${this.secretKey}`,
          'Content-Type': 'application/json',
        },
      });
      return response.data;
    } catch (error) {
      logger.error({ error }, 'Khalti initiation error');
      throw new Error('Khalti payment initiation failed');
    }
  }

  async verifyPayment(transactionId: string): Promise<boolean> {
    this.assertConfigured();

    try {
      const response = await axios.post(
        `${this.baseUrl}/epayment/lookup/`,
        { transaction_id: transactionId },
        {
          headers: {
            Authorization: `Key ${this.secretKey}`,
            'Content-Type': 'application/json',
          },
        },
      );
      return response.data.status === 'Completed';
    } catch (error) {
      logger.error({ error }, 'Khalti verification error');
      return false;
    }
  }
}
