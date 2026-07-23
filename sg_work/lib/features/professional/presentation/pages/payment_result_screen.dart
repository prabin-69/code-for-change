import 'package:flutter/material.dart';
import '../../../payments/domain/entities/payment.dart';

class PaymentResultScreen extends StatelessWidget {
  final bool success;
  final Payment? payment;

  const PaymentResultScreen({
    super.key,
    required this.success,
    this.payment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(success ? 'Payment Success' : 'Payment Failed'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              size: 100,
              color: success ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              success ? 'Payment Completed!' : 'Payment Failed',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            if (payment != null) ...[
              Text('Transaction ID: ${payment!.transactionId ?? 'N/A'}'),
              Text('Amount: Rs. ${payment!.amount}'),
              Text('Date: ${payment!.createdAt.toLocal()}'),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}