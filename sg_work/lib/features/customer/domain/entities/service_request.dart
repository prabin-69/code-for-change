import 'job.dart';

class ServiceRequest {
  final String id;
  final String customerId;
  final String categoryId;
  final String professionId;
  final String? professionalId;
  final String description;
  final String address;
  final double? latitude;
  final double? longitude;
  final String status;
  final List<String> photos;
  final double? budget;
  final DateTime? preferredDate;
  final String? preferredTime;
  final List<String> images;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Job? job;

  const ServiceRequest({
    required this.id,
    required this.customerId,
    required this.categoryId,
    required this.professionId,
    this.professionalId,
    required this.description,
    required this.address,
    this.latitude,
    this.longitude,
    required this.status,
    required this.photos,
    this.budget,
    this.preferredDate,
    this.preferredTime,
    this.images = const [],
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
