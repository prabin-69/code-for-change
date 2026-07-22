import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/service_request.dart';
import '../repositories/customer_repository.dart';

class CreateRequest {
  final CustomerRepository repository;
  const CreateRequest(this.repository);

  Future<Either<Failure, ServiceRequest>> call(Map<String, dynamic> data) {
    return repository.createRequest(data);
  }
}
