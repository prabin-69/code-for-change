import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profession.dart';
import '../repositories/customer_repository.dart';

class GetProfessionsByCategory {
  final CustomerRepository repository;
  const GetProfessionsByCategory(this.repository);

  Future<Either<Failure, List<Profession>>> call(String categoryId) {
    return repository.getProfessionsByCategory(categoryId);
  }
}
