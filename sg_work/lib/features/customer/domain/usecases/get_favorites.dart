import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/customer_repository.dart';

class GetFavorites {
  final CustomerRepository repository;
  const GetFavorites(this.repository);

  Future<Either<Failure, List<dynamic>>> call() {
    return repository.getFavorites();
  }
}
