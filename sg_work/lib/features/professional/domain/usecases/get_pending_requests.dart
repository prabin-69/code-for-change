import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/professional_repository.dart';

class GetPendingRequests {
  final ProfessionalRepository repository;
  const GetPendingRequests(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call({
    required double lat,
    required double lng,
    double radius = 10,
  }) {
    return repository.getPendingRequests(lat: lat, lng: lng, radius: radius);
  }
}
