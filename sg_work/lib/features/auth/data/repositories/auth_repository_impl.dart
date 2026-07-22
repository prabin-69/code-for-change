import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/secure_storage_helper.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> sendOtp(String phone) async {
    try {
      await remoteDataSource.sendOtp(phone);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp(String phone, String otp) async {
    try {
      final tokenModel = await remoteDataSource.verifyOtp(phone, otp);
      await SecureStorageHelper.saveAccessToken(tokenModel.accessToken);
      await SecureStorageHelper.saveRefreshToken(tokenModel.refreshToken);
      await SecureStorageHelper.saveUser(tokenModel.user.toJson());
      return Right(tokenModel.user.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, User>> selectRole(String role) async {
    try {
      final userJson = await remoteDataSource.selectRole(role);
      await SecureStorageHelper.saveUser(userJson);
      final user = UserModel.fromJson(userJson).toEntity();
      return Right(user);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, User>> refreshToken() async {
    try {
      final storedRefreshToken = await SecureStorageHelper.getRefreshToken();
      if (storedRefreshToken == null) {
        return const Left(CacheFailure('No refresh token found'));
      }
      final tokens = await remoteDataSource.refreshToken(storedRefreshToken);
      await SecureStorageHelper.saveAccessToken(tokens['access_token']!);
      await SecureStorageHelper.saveRefreshToken(tokens['refresh_token']!);
      final userJson = await remoteDataSource.getMe();
      await SecureStorageHelper.saveUser(userJson);
      final user = UserModel.fromJson(userJson).toEntity();
      return Right(user);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final refreshToken = await SecureStorageHelper.getRefreshToken();
      if (refreshToken != null) {
        await remoteDataSource.logout(refreshToken);
      }
      await SecureStorageHelper.clearAll();
      return const Right(null);
    } catch (e) {
      await SecureStorageHelper.clearAll();
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> logoutAll() async {
    try {
      await remoteDataSource.logoutAll();
      await SecureStorageHelper.clearAll();
      return const Right(null);
    } catch (e) {
      await SecureStorageHelper.clearAll();
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final userJson = await SecureStorageHelper.getUser();
      if (userJson == null) {
        return const Left(CacheFailure('No user data'));
      }
      final user = UserModel.fromJson(userJson).toEntity();
      return Right(user);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
