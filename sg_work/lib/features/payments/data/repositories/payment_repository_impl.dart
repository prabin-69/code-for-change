import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/entities/payment.dart';
import '../datasources/payment_remote_datasource.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
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
  }) async {
    try {
      final result = await remoteDataSource.initiatePayment(
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
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Payment>> verifyPayment(String paymentId, String transactionId) async {
    try {
      final result = await remoteDataSource.verifyPayment(paymentId, transactionId);
      // The response contains payment object
      final payment = PaymentModel.fromJson(result['payment']).toEntity();
      return Right(payment);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<Payment>>> getMyPayments() async {
    try {
      final result = await remoteDataSource.getMyPayments();
      final payments = result.map((json) => PaymentModel.fromJson(json).toEntity()).toList();
      return Right(payments);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}