import { env } from '../../../config/env';

export class BankService {
  // Generate payment instructions
  async getPaymentInstructions(amount: number, reference: string) {
    return {
      bankName: env.BANK_NAME || 'Nepal Bank Limited',
      accountNumber: env.BANK_ACCOUNT || '1234567890',
      accountHolderName: env.BANK_ACCOUNT_HOLDER || 'Service Marketplace Pvt. Ltd.',
      amount,
      reference,
      qrCodeUrl: env.BANK_QR_BASE_URL + reference, // optional
    };
  }

  // Admin will manually verify after receiving proof
  async verifyPayment(reference: string): Promise<boolean> {
    // This will be called by admin when they manually confirm the payment
    return true;
  }
}