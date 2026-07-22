import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/customer_repository.dart';

class AddFavorite {
  final CustomerRepository repository;
  const AddFavorite(this.repository);

  Future<Either<Failure, void>> call(String professionalId) {
    return repository.addFavorite(professionalId);
  }
}
