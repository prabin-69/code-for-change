import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class GetMyPayments {
  final PaymentRepository repository;

  GetMyPayments(this.repository);

  Future<Either<Failure, List<Payment>>> call() {
    return repository.getMyPayments();
  }
}