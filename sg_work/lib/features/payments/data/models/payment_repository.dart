import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';

abstract class PaymentRepository {
  Future<Either<Failure, Map<String, dynamic>>> initiatePayment({
    required double amount,
    required String gateway,
    required String type,
    String? relatedId,
    Map<String, dynamic>? metadata,
    String? productName,
    String? productId,
    String? successUrl,
    String? failureUrl,
  });

  Future<Either<Failure, Payment>> verifyPayment(String paymentId, String transactionId);

  Future<Either<Failure, List<Payment>>> getMyPayments();
}