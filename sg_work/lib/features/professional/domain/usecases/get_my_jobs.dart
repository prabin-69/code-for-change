import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../customer/domain/entities/job.dart';
import '../repositories/professional_repository.dart';

class GetMyJobs {
  final ProfessionalRepository repository;
  const GetMyJobs(this.repository);

  Future<Either<Failure, List<Job>>> call({String? status}) {
    return repository.getMyJobs(status: status);
  }
}
