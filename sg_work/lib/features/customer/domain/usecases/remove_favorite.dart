import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/customer_repository.dart';

class RemoveFavorite {
  final CustomerRepository repository;
  const RemoveFavorite(this.repository);

  Future<Either<Failure, void>> call(String professionalId) {
    return repository.removeFavorite(professionalId);
  }
}
