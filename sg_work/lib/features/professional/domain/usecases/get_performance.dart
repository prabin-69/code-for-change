import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/professional_repository.dart';

class GetPerformance {
  final ProfessionalRepository repository;
  const GetPerformance(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call() {
    return repository.getPerformance();
  }
}
