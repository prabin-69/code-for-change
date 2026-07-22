import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/professional_repository.dart';

class SubmitVerification {
  final ProfessionalRepository repository;
  const SubmitVerification(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.submitVerification();
  }
}
