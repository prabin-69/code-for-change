import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/professional_profile.dart';
import '../repositories/professional_repository.dart';

class GetProfile {
  final ProfessionalRepository repository;

  GetProfile(this.repository);

  Future<Either<Failure, ProfessionalProfile>> call() {
    return repository.getProfile();
  }
}