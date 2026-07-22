import '../../domain/entities/review.dart';

class ReviewModel {
  final String id;
  final String jobId;
  final String reviewerId;
  final String professionalId;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.jobId,
    required this.reviewerId,
    required this.professionalId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String? ?? '',
      jobId: json['job_id'] as String? ?? '',
      reviewerId: json['reviewer_id'] as String? ?? '',
      professionalId: json['professional_id'] as String? ?? '',
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'job_id': jobId,
        'reviewer_id': reviewerId,
        'professional_id': professionalId,
        'rating': rating,
        'comment': comment,
        'created_at': createdAt.toIso8601String(),
      };

  Review toEntity() => Review(
        id: id,
        jobId: jobId,
        reviewerId: reviewerId,
        professionalId: professionalId,
        rating: rating,
        comment: comment,
        createdAt: createdAt,
      );
}
