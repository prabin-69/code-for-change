import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/service_request.dart';
import '../repositories/customer_repository.dart';

class GetMyRequests {
  final CustomerRepository repository;
  const GetMyRequests(this.repository);

  Future<Either<Failure, List<ServiceRequest>>> call({String? status}) {
    return repository.getMyRequests(status: status);
  }
}
