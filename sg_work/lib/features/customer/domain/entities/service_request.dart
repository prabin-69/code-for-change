import 'job.dart';

class ServiceRequest {
  final String id;
  final String customerId;
  final String categoryId;
  final String professionId;
  final String description;
  final String address;
  final double? latitude;
  final double? longitude;
  final String status;
  final List<String> photos;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Job? job;

  const ServiceRequest({
    required this.id,
    required this.customerId,
    required this.categoryId,
    required this.professionId,
    required this.description,
    required this.address,
    this.latitude,
    this.longitude,
    required this.status,
    required this.photos,
    required this.createdAt,
    this.updatedAt,
    this.job,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceRequest &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
