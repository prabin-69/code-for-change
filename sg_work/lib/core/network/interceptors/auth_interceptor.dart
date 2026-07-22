import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/api_constants.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;

  AuthInterceptor({required this.secureStorage});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken =
        await secureStorage.read(key: AppConstants.accessTokenKey);
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken =
            await secureStorage.read(key: AppConstants.refreshTokenKey);
        if (refreshToken != null) {
          final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
          final response = await dio.post(
            ApiConstants.refreshToken,
            data: {'refresh_token': refreshToken},
          );
          if (response.statusCode == 200) {
            final newAccessToken =
                response.data['data']['access_token'] as String;
            final newRefreshToken =
                response.data['data']['refresh_token'] as String;
            await secureStorage.write(
                key: AppConstants.accessTokenKey, value: newAccessToken);
            await secureStorage.write(
                key: AppConstants.refreshTokenKey, value: newRefreshToken);

            // Retry original request
            final request = err.requestOptions;
            request.headers['Authorization'] = 'Bearer $newAccessToken';
            final retryDio = Dio();
            final retryResponse = await retryDio.request(
              request.path,
              options: Options(
                method: request.method,
                headers: request.headers,
              ),
              data: request.data,
              queryParameters: request.queryParameters,
            );
            return handler.resolve(retryResponse);
          }
        }
      } catch (_) {
        await _clearTokens();
      }
    }
    handler.next(err);
  }

  Future<void> _clearTokens() async {
    await secureStorage.delete(key: AppConstants.accessTokenKey);
    await secureStorage.delete(key: AppConstants.refreshTokenKey);
    await secureStorage.delete(key: AppConstants.userKey);
  }
}
