import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/service_request.dart';
import '../repositories/customer_repository.dart';

class GetRequestById {
  final CustomerRepository repository;
  const GetRequestById(this.repository);

  Future<Either<Failure, ServiceRequest>> call(String id) {
    return repository.getRequestById(id);
  }
}
