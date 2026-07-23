import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/payment_repository.dart';

class InitiatePayment {
  final PaymentRepository repository;

  InitiatePayment(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required double amount,
    required String gateway,
    required String type,
    String? relatedId,
    Map<String, dynamic>? metadata,
    String? productName,
    String? productId,
    String? successUrl,
    String? failureUrl,
  }) {
    return repository.initiatePayment(
      amount: amount,
      gateway: gateway,
      type: type,
      relatedId: relatedId,
      metadata: metadata,
      productName: productName,
      productId: productId,
      successUrl: successUrl,
      failureUrl: failureUrl,
    );
  }
}