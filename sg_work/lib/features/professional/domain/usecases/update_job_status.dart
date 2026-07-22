import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../customer/domain/entities/job.dart';
import '../repositories/professional_repository.dart';

class UpdateJobStatus {
  final ProfessionalRepository repository;
  const UpdateJobStatus(this.repository);

  Future<Either<Failure, Job>> call(String jobId, Map<String, dynamic> data) {
    return repository.updateJobStatus(jobId, data);
  }
}
