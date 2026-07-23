import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../payments/presentation/bloc/payment_bloc.dart';

import 'payment_result_screen.dart';
import 'payment_webview_screen.dart';
import 'bank_payment_instructions_screen.dart';
class PaymentSelectionScreen extends StatelessWidget {
  final double amount;
  final String type; // 'SUBSCRIPTION', 'VERIFICATION_FEE', 'FEATURED'
  final String? relatedId;
  final String? productName;
  final String? productId;

  const PaymentSelectionScreen({
    super.key,
    required this.amount,
    required this.type,
    this.relatedId,
    this.productName,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Payment Method')),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is PaymentInitiated) {
            // Navigate to payment gateway webview or bank instructions
            _handlePaymentInitiation(context, state);
          }
          if (state is PaymentVerified) {
            // Payment success – navigate to success screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentResultScreen(
                  success: true,
                  payment: state.payment,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Amount: Rs. ${amount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text('Type: $type'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (state is PaymentLoading) const CircularProgressIndicator(),
                if (state is! PaymentLoading) ...[
                  ListTile(
                    leading: const Icon(Icons.payment),
                    title: const Text('eSewa'),
                    onTap: () => _initiatePayment(context, 'esewa'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.payment),
                    title: const Text('Khalti'),
                    onTap: () => _initiatePayment(context, 'khalti'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_balance),
                    title: const Text('Bank Transfer'),
                    onTap: () => _initiatePayment(context, 'bank'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _initiatePayment(BuildContext context, String gateway) {
    context.read<PaymentBloc>().add(
      InitiatePaymentEvent(
        amount: amount,
        gateway: gateway,
        type: type,
        relatedId: relatedId,
        productName: productName ?? type,
        productId: productId ?? 'payment_${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
  }

  void _handlePaymentInitiation(BuildContext context, PaymentInitiated state) {
    final response = state.gatewayResponse;
    final paymentId = state.paymentId;

    // For eSewa or Khalti, we need to open a webview with the payment URL.
    // The response should contain a payment_url or similar.
    if (response.containsKey('payment_url')) {
      // Navigate to webview screen with the URL and listen for redirects.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebviewScreen(
            paymentId: paymentId,
            paymentUrl: response['payment_url'],
            successPattern: '/payment/success',
            failurePattern: '/payment/failure',
          ),
        ),
      );
    } else if (response.containsKey('instructions')) {
      // Bank instructions
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BankPaymentInstructionsScreen(
            paymentId: paymentId,
            instructions: response['instructions'],
          ),
        ),
      );
    } else {
      // Fallback: just show a dialog with the response
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Initiated'),
          content: Text('Payment ID: $paymentId\nPlease complete payment.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}