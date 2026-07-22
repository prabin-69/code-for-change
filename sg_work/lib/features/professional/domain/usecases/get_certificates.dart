import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/certificate.dart';
import '../repositories/professional_repository.dart';

class GetCertificates {
  final ProfessionalRepository repository;
  const GetCertificates(this.repository);

  Future<Either<Failure, List<Certificate>>> call() {
    return repository.getCertificates();
  }
}
