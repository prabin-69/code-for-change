import '../../domain/entities/job.dart';
import 'review_model.dart';

class JobModel {
  final String id;
  final String requestId;
  final String professionalId;
  final String customerId;
  final String status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<String> beforePhotos;
  final List<String> afterPhotos;
  final ReviewModel? review;

  JobModel({
    required this.id,
    required this.requestId,
    required this.professionalId,
    required this.customerId,
    required this.status,
    required this.startedAt,
    this.completedAt,
    required this.beforePhotos,
    required this.afterPhotos,
    this.review,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] as String? ?? '',
      requestId: json['request_id'] as String? ?? '',
      professionalId: json['professional_id'] as String? ?? '',
      customerId: json['customer_id'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : DateTime.now(),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      beforePhotos:
          (json['before_photos'] as List?)?.map((e) => e as String).toList() ??
              [],
      afterPhotos:
          (json['after_photos'] as List?)?.map((e) => e as String).toList() ??
              [],
      review: json['review'] != null
          ? ReviewModel.fromJson(json['review'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'request_id': requestId,
        'professional_id': professionalId,
        'customer_id': customerId,
        'status': status,
        'started_at': startedAt.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
        'before_photos': beforePhotos,
        'after_photos': afterPhotos,
        'review': review?.toJson(),
      };

  Job toEntity() => Job(
        id: id,
        requestId: requestId,
        professionalId: professionalId,
        customerId: customerId,
        status: status,
        startedAt: startedAt,
        completedAt: completedAt,
        beforePhotos: beforePhotos,
        afterPhotos: afterPhotos,
        review: review?.toEntity(),
      );
}
