import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/portfolio.dart';
import '../repositories/professional_repository.dart';

class GetPortfolio {
  final ProfessionalRepository repository;
  const GetPortfolio(this.repository);

  Future<Either<Failure, List<Portfolio>>> call() {
    return repository.getPortfolio();
  }
}
