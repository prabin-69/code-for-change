import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/initiate_payment.dart';
import '../../domain/usecases/verify_payment.dart';
import '../../domain/usecases/get_my_payments.dart';

import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final InitiatePayment initiatePayment;
  final VerifyPayment verifyPayment;
  final GetMyPayments getMyPayments;

  PaymentBloc({
    required this.initiatePayment,
    required this.verifyPayment,
    required this.getMyPayments,
  }) : super(const PaymentInitial()) {
    on<InitiatePaymentEvent>(_onInitiatePayment);
    on<VerifyPaymentEvent>(_onVerifyPayment);
    on<GetMyPaymentsEvent>(_onGetMyPayments);
  }

  Future<void> _onInitiatePayment(
    InitiatePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());

    final result = await initiatePayment(
      amount: event.amount,
      gateway: event.gateway,
      type: event.type,
      relatedId: event.relatedId,
      metadata: event.metadata,
      productName: event.productName,
      productId: event.productId,
      successUrl: event.successUrl,
      failureUrl: event.failureUrl,
    );

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (response) {
        emit(
          PaymentInitiated(
            paymentId: response['paymentId']?.toString() ?? '',
            gatewayResponse: response,
          ),
        );
      },
    );
  }

  Future<void> _onVerifyPayment(
    VerifyPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());

    final result = await verifyPayment(
      event.paymentId,
      event.transactionId,
    );

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payment) => emit(PaymentVerified(payment)),
    );
  }

  Future<void> _onGetMyPayments(
    GetMyPaymentsEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());

    final result = await getMyPayments();

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payments) => emit(PaymentHistoryLoaded(payments)),
    );
  }
}