import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../payments/presentation/bloc/payment_bloc.dart';
import '../../../payments/presentation/bloc/payment_event.dart';


class PaymentWebviewScreen extends StatefulWidget {

  final String paymentId;
  final String paymentUrl;
  final String successPattern;
  final String failurePattern;


  const PaymentWebviewScreen({

    super.key,

    required this.paymentId,
    required this.paymentUrl,
    required this.successPattern,
    required this.failurePattern,

  });

  @override
  State<PaymentWebviewScreen> createState() =>
      _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState
    extends State<PaymentWebviewScreen> {
  late final WebViewController controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            if(mounted){
              setState(() {
                _isLoading = false;
              });
            }
          },
          onUrlChange: (change) {
            final url =
                change.url ?? '';
            if(url.contains(widget.successPattern)){
              final transactionId =
                  _extractTransactionId(url);
              _verifyPayment(
                transactionId,
              );
            }
            else if(url.contains(widget.failurePattern)){
              if(mounted){
                Navigator.pop(
                  context,
                  false,
                );
              }
            }
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          widget.paymentUrl,
        ),
      );
  }

  String _extractTransactionId(String url) {
    final uri =
        Uri.parse(url);
    return uri.queryParameters['transaction_id']
        ??
        widget.paymentId;
  }
  void _verifyPayment(String transactionId) {
    context.read<PaymentBloc>().add(
      VerifyPaymentEvent(
        transactionId:
        transactionId,
        paymentId:
        widget.paymentId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text(
          "Payment",
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller:
            controller,
          ),
          if(_isLoading)
            const Center(
              child:
              CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}