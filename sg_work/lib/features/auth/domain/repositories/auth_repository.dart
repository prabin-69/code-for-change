import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> sendOtp(String phone);
  Future<Either<Failure, User>> verifyOtp(String phone, String otp);
  Future<Either<Failure, User>> selectRole(String role);
  Future<Either<Failure, User>> refreshToken();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> logoutAll();
  Future<Either<Failure, User>> getCurrentUser();
}