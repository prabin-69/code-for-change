import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class VerifyPayment {
  final PaymentRepository repository;

  VerifyPayment(this.repository);

  Future<Either<Failure, Payment>> call(
    String paymentId,
    String transactionId,
  ) {
    return repository.verifyPayment(
      paymentId,
      transactionId,
    );
  }
}