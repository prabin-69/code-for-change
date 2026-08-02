import 'package:dio/dio.dart';
import '../../../core/utils/secure_storage_helper.dart';
import '../../../core/constants/api_constants.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) {
    // Use synchronous cache first to avoid race condition with async read.
    final accessToken = SecureStorageHelper.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await SecureStorageHelper.getRefreshToken();
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
            await SecureStorageHelper.saveAccessToken(newAccessToken);
            await SecureStorageHelper.saveRefreshToken(newRefreshToken);

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
        await SecureStorageHelper.clearAll();
      }
    }
    handler.next(err);
  }
}
