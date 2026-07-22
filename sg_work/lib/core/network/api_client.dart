import 'package:dio/dio.dart';
import 'dio_client.dart';

/// Thin, injectable wrapper around [DioClient] that provides a simple
/// `get` / `post` / `put` / `delete` API used across the app.
///
/// This fills the role of the missing `api_client.dart` import that
/// certain widgets (e.g. `eta_display.dart`) previously referenced.
/// All HTTP logic is delegated to [DioClient], which handles auth
/// interceptors and global headers.
class ApiClient {
  final DioClient _client;

  ApiClient({DioClient? client}) : _client = client ?? DioClient();

  Dio get _dio => _client.dio;

  /// Perform a GET request.
  ///
  /// Returns the full response body decoded as `Map<String, dynamic>`.
  /// Throws a [DioException] on HTTP errors.
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      url,
      queryParameters: queryParams,
    );
    return response.data ?? {};
  }

  /// Perform a POST request with a JSON [body].
  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      url,
      data: body,
      queryParameters: queryParams,
    );
    return response.data ?? {};
  }

  /// Perform a PUT request with a JSON [body].
  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      url,
      data: body,
      queryParameters: queryParams,
    );
    return response.data ?? {};
  }

  /// Perform a PATCH request with a JSON [body].
  Future<Map<String, dynamic>> patch(
    String url, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      url,
      data: body,
      queryParameters: queryParams,
    );
    return response.data ?? {};
  }

  /// Perform a DELETE request.
  Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      url,
      queryParameters: queryParams,
    );
    return response.data ?? {};
  }
}
