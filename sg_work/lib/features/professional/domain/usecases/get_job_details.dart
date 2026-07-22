import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../customer/domain/entities/job.dart';
import '../repositories/professional_repository.dart';

class GetJobDetails {
  final ProfessionalRepository repository;
  const GetJobDetails(this.repository);

  Future<Either<Failure, Job>> call(String jobId) {
    return repository.getJobDetails(jobId);
  }
}
