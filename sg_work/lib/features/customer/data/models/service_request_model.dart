import '../../domain/entities/service_request.dart';
import 'job_model.dart';

class ServiceRequestModel {
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
  final JobModel? job;

  ServiceRequestModel({
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

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestModel(
      id: json['id'] as String? ?? '',
      customerId: json['customer_id'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? '',
      professionId: json['profession_id'] as String? ?? '',
      professionalId: json['accepted_by'] as String?,
      description: json['description'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'pending',
      photos: (json['photos'] as List?)?.map((e) => e as String).toList() ?? [],
      budget: (json['budget'] as num?)?.toDouble(),
      preferredDate: json['preferred_date'] != null
          ? DateTime.parse(json['preferred_date'] as String)
          : null,
      preferredTime: json['preferred_time'] as String?,
      images: (json['images'] as List?)?.map((e) => e as String).toList() ?? [],
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
        'budget': budget,
        'preferred_date': preferredDate?.toIso8601String(),
        'preferred_time': preferredTime,
        'images': images,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'job': job?.toJson(),
      };

  ServiceRequest toEntity() => ServiceRequest(
        id: id,
        customerId: customerId,
        categoryId: categoryId,
        professionId: professionId,
        professionalId: professionalId,
        description: description,
        address: address,
        latitude: latitude,
        longitude: longitude,
        status: status,
        photos: photos,
        budget: budget,
        preferredDate: preferredDate,
        preferredTime: preferredTime,
        images: images,
        createdAt: createdAt,
        updatedAt: updatedAt,
        job: job?.toEntity(),
      );
}
