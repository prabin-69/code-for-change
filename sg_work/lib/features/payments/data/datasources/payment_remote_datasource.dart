
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';

abstract class PaymentRemoteDataSource {
  Future<Map<String, dynamic>> initiatePayment({
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

  Future<Map<String, dynamic>> verifyPayment(
    String paymentId,
    String transactionId,
  );

  Future<List<dynamic>> getMyPayments();
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final DioClient dioClient;

  PaymentRemoteDataSourceImpl({
    required this.dioClient,
  });

  @override
  Future<Map<String, dynamic>> initiatePayment({
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
    final response = await dioClient.dio.post(
      ApiConstants.initiatePayment,
      data: {
        "amount": amount,
        "gateway": gateway,
        "type": type,
        "relatedId": relatedId,
        "metadata": metadata,
        "productName": productName,
        "productId": productId,
        "successUrl": successUrl,
        "failureUrl": failureUrl,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  @override
  Future<Map<String, dynamic>> verifyPayment(
    String paymentId,
    String transactionId,
  ) async {
    final response = await dioClient.dio.post(
      "${ApiConstants.initiatePayment}/verify",
      data: {
        "paymentId": paymentId,
        "transactionId": transactionId,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  @override
  Future<List<dynamic>> getMyPayments() async {
    final response = await dioClient.dio.get(
      ApiConstants.myPayments,
    );

    return List<dynamic>.from(response.data);
  }
}