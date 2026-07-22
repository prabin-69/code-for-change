import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/portfolio.dart';
import '../repositories/professional_repository.dart';

class AddPortfolio {
  final ProfessionalRepository repository;
  const AddPortfolio(this.repository);

  Future<Either<Failure, Portfolio>> call(Map<String, dynamic> data) {
    return repository.addPortfolio(data);
  }
}
