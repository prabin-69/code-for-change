import '../../domain/entities/service_request.dart';
import 'job_model.dart';

class ServiceRequestModel {
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
  final JobModel? job;

  ServiceRequestModel({
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

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestModel(
      id: json['id'] as String? ?? '',
      customerId: json['customer_id'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? '',
      professionId: json['profession_id'] as String? ?? '',
      description: json['description'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'pending',
      photos: (json['photos'] as List?)?.map((e) => e as String).toList() ?? [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      job: json['job'] != null
          ? JobModel.fromJson(json['job'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'category_id': categoryId,
        'profession_id': professionId,
        'description': description,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'photos': photos,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'job': job?.toJson(),
      };

  ServiceRequest toEntity() => ServiceRequest(
        id: id,
        customerId: customerId,
        categoryId: categoryId,
        professionId: professionId,
        description: description,
        address: address,
        latitude: latitude,
        longitude: longitude,
        status: status,
        photos: photos,
        createdAt: createdAt,
        updatedAt: updatedAt,
        job: job?.toEntity(),
      );
}
