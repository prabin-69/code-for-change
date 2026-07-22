import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/professional_repository.dart';

class GetVerificationStatus {
  final ProfessionalRepository repository;
  const GetVerificationStatus(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call() {
    return repository.getVerificationStatus();
  }
}
