import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/professional_profile.dart';
import '../repositories/professional_repository.dart';

class UpdateProfile {
  final ProfessionalRepository repository;
  const UpdateProfile(this.repository);

  Future<Either<Failure, ProfessionalProfile>> call(Map<String, dynamic> data) {
    return repository.updateProfile(data);
  }
}
