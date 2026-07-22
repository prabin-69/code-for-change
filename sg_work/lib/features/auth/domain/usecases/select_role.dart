import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SelectRole {
  final AuthRepository repository;

  const SelectRole(this.repository);

  Future<Either<Failure, User>> call(String role) {
    return repository.selectRole(role);
  }
}
