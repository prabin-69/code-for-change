import 'package:equatable/equatable.dart';

import '../../domain/entities/payment.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

class PaymentInitiated extends PaymentState {
  final String paymentId;
  final Map<String, dynamic> gatewayResponse;

  const PaymentInitiated({
    required this.paymentId,
    required this.gatewayResponse,
  });

  @override
  List<Object?> get props => [
        paymentId,
        gatewayResponse,
      ];
}

class PaymentVerified extends PaymentState {
  final Payment payment;

  const PaymentVerified(this.payment);

  @override
  List<Object?> get props => [payment];
}

class PaymentHistoryLoaded extends PaymentState {
  final List<Payment> payments;

  const PaymentHistoryLoaded(this.payments);

  @override
  List<Object?> get props => [payments];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}