import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/professional_repository.dart';

class DeleteCertificate {
  final ProfessionalRepository repository;
  const DeleteCertificate(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteCertificate(id);
  }
}
