import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class VerifyOtp {
  final AuthRepository repository;

  const VerifyOtp(this.repository);

  Future<Either<Failure, User>> call(String phone, String otp) {
    return repository.verifyOtp(phone, otp);
  }
}