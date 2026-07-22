import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/professional_profile.dart';
import '../repositories/professional_repository.dart';

class UpdateAvailability {
  final ProfessionalRepository repository;
  const UpdateAvailability(this.repository);

  Future<Either<Failure, ProfessionalProfile>> call(String availability) {
    return repository.updateAvailability(availability);
  }
}
