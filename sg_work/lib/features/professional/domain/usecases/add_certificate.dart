import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/certificate.dart';
import '../repositories/professional_repository.dart';

class AddCertificate {
  final ProfessionalRepository repository;
  const AddCertificate(this.repository);

  Future<Either<Failure, Certificate>> call(Map<String, dynamic> data) {
    return repository.addCertificate(data);
  }
}
