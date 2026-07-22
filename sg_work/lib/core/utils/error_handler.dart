import 'package:dio/dio.dart';
import '../errors/failures.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        return const NetworkFailure('No internet connection');
      }
      final response = error.response;
      if (response != null) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          return ServerFailure(data['message'] as String);
        }
        return ServerFailure('Server error (${response.statusCode})');
      }
      return const ServerFailure('Something went wrong');
    }
    return const ServerFailure('Unexpected error');
  }
}