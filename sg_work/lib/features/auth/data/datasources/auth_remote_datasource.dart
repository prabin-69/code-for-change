import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/auth_token_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource({required this.dio});

  Future<void> sendOtp(String phone) async {
    await dio.post(
      ApiConstants.sendOtp,
      data: {'phone': phone},
    );
  }

  Future<AuthTokenModel> verifyOtp(String phone, String otp) async {
    final response = await dio.post(
      ApiConstants.verifyOtp,
      data: {'phone': phone, 'otp': otp},
    );
    return AuthTokenModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<Map<String, String>> refreshToken(String refreshToken) async {
    final response = await dio.post(
      ApiConstants.refreshToken,
      data: {'refresh_token': refreshToken},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return {
      'access_token': data['access_token'] as String,
      'refresh_token': data['refresh_token'] as String,
    };
  }

  Future<void> logout(String refreshToken) async {
    await dio.post(
      ApiConstants.logout,
      data: {'refresh_token': refreshToken},
    );
  }

  Future<void> logoutAll() async {
    await dio.post(ApiConstants.logoutAll);
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await dio.get(ApiConstants.me);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> selectRole(String role) async {
    final response = await dio.post(
      ApiConstants.selectRole,
      data: {'role': role},
    );
    return response.data['data'] as Map<String, dynamic>;
  }
}
