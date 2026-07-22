import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../bloc/payment_bloc.dart';

class BankPaymentInstructionsScreen extends StatelessWidget {
  final String paymentId;
  final Map<String, dynamic> instructions;

  const BankPaymentInstructionsScreen({
    super.key,
    required this.paymentId,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank Transfer Instructions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Please transfer the exact amount to the following account:',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bank: ${instructions['bankName'] ?? 'N/A'}'),
                    Text('Account Number: ${instructions['accountNumber'] ?? 'N/A'}'),
                    Text('Account Holder: ${instructions['accountHolderName'] ?? 'N/A'}'),
                    Text('Amount: Rs. ${instructions['amount'] ?? 0}'),
                    Text('Reference: ${instructions['reference'] ?? 'N/A'}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (instructions.containsKey('qrCodeUrl'))
              Center(
                child: QrImage(
                  data: instructions['qrCodeUrl'],
                  size: 200,
                ),
              ),
            const Spacer(),
            const Text('After payment, admin will verify and activate your service.'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to previous screen
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}