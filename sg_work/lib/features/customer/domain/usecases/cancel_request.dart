import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/service_request.dart';
import '../repositories/customer_repository.dart';

class CancelRequest {
  final CustomerRepository repository;
  const CancelRequest(this.repository);

  Future<Either<Failure, ServiceRequest>> call(String id, {String? reason}) {
    return repository.cancelRequest(id, reason: reason);
  }
}
