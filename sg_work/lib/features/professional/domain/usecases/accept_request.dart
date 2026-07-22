import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../customer/domain/entities/job.dart';
import '../repositories/professional_repository.dart';

class AcceptRequest {
  final ProfessionalRepository repository;
  const AcceptRequest(this.repository);

  Future<Either<Failure, Job>> call(String requestId) {
    return repository.acceptRequest(requestId);
  }
}
