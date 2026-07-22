import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class SecureStorageHelper {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // ─── Access Token ──────────────────────────────────────────────────────────
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: AppConstants.accessTokenKey, value: token);
    _cachedAccessToken = token;
  }

  static String? _cachedAccessToken;

  static String? getAccessToken() => _cachedAccessToken;

  static Future<String?> readAccessToken() async {
    _cachedAccessToken = await _storage.read(key: AppConstants.accessTokenKey);
    return _cachedAccessToken;
  }

  // ─── Refresh Token ─────────────────────────────────────────────────────────
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: AppConstants.refreshTokenKey, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppConstants.refreshTokenKey);
  }

  static Future<bool> hasRefreshToken() async {
    final token = await _storage.read(key: AppConstants.refreshTokenKey);
    return token != null && token.isNotEmpty;
  }

  // ─── User ──────────────────────────────────────────────────────────────────
  static Future<void> saveUser(Map<String, dynamic> userJson) async {
    await _storage.write(
        key: AppConstants.userKey, value: jsonEncode(userJson));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final userString = await _storage.read(key: AppConstants.userKey);
    if (userString == null) return null;
    return jsonDecode(userString) as Map<String, dynamic>;
  }

  // ─── Clear ─────────────────────────────────────────────────────────────────
  static Future<void> clearAll() async {
    _cachedAccessToken = null;
    await _storage.deleteAll();
  }
}
