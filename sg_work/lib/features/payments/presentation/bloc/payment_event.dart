import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class InitiatePaymentEvent extends PaymentEvent {
  final double amount;
  final String gateway;
  final String type;
  final String? relatedId;
  final Map<String, dynamic>? metadata;
  final String? productName;
  final String? productId;
  final String? successUrl;
  final String? failureUrl;

  const InitiatePaymentEvent({
    required this.amount,
    required this.gateway,
    required this.type,
    this.relatedId,
    this.metadata,
    this.productName,
    this.productId,
    this.successUrl,
    this.failureUrl,
  });

  @override
  List<Object?> get props => [
        amount,
        gateway,
        type,
        relatedId,
        metadata,
        productName,
        productId,
        successUrl,
        failureUrl,
      ];
}

class VerifyPaymentEvent extends PaymentEvent {
  final String paymentId;
  final String transactionId;

  const VerifyPaymentEvent({
    required this.paymentId,
    required this.transactionId,
  });

  @override
  List<Object?> get props => [paymentId, transactionId];
}

class GetMyPaymentsEvent extends PaymentEvent {
  const GetMyPaymentsEvent();
}