import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/professional_repository.dart';

class DeletePortfolio {
  final ProfessionalRepository repository;
  const DeletePortfolio(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deletePortfolio(id);
  }
}
