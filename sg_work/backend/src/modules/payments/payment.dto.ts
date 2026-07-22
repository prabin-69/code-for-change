export class InitiatePaymentDto {
  amount!: number;
  gateway!: 'esewa' | 'khalti' | 'bank';
  type!: 'SUBSCRIPTION' | 'VERIFICATION_FEE' | 'FEATURED';
  related_id?: string;
  metadata?: any;
  product_name?: string;
  product_id?: string;
  success_url?: string;
  failure_url?: string;
}

export class VerifyPaymentDto {
  transaction_id!: string;
}