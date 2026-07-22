import '../../domain/entities/professional_profile.dart';

class ProfessionalProfileModel {
  final String userId;
  final String? categoryId;
  final String? professionId;
  final List<String> skills;
  final int? experienceYears;
  final String? about;
  final String availability;
  final bool isFeatured;
  final DateTime? featuredExpires;
  final String verificationStatus;
  final bool verificationFeePaid;
  final double? averageRating;
  final int totalJobs;
  final double? responseTimeAvg;
  final double? cancellationRate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic category;
  final dynamic profession;

  ProfessionalProfileModel({
    required this.userId,
    this.categoryId,
    this.professionId,
    required this.skills,
    this.experienceYears,
    this.about,
    required this.availability,
    required this.isFeatured,
    this.featuredExpires,
    required this.verificationStatus,
    required this.verificationFeePaid,
    this.averageRating,
    required this.totalJobs,
    this.responseTimeAvg,
    this.cancellationRate,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.profession,
  });

  factory ProfessionalProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalProfileModel(
      userId: json['user_id'] as String? ?? '',
      categoryId: json['category_id'] as String?,
      professionId: json['profession_id'] as String?,
      skills: (json['skills'] as List?)?.map((e) => e as String).toList() ?? [],
      experienceYears: json['experience_years'] as int?,
      about: json['about'] as String?,
      availability: json['availability'] as String? ?? 'available',
      isFeatured: json['is_featured'] as bool? ?? false,
      featuredExpires: json['featured_expires'] != null
          ? DateTime.parse(json['featured_expires'] as String)
          : null,
      verificationStatus: json['verification_status'] as String? ?? 'unverified',
      verificationFeePaid: json['verification_fee_paid'] as bool? ?? false,
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      totalJobs: json['total_jobs'] as int? ?? 0,
      responseTimeAvg: (json['response_time_avg'] as num?)?.toDouble(),
      cancellationRate: (json['cancellation_rate'] as num?)?.toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      category: json['category'],
      profession: json['profession'],
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'category_id': categoryId,
        'profession_id': professionId,
        'skills': skills,
        'experience_years': experienceYears,
        'about': about,
        'availability': availability,
        'is_featured': isFeatured,
        'featured_expires': featuredExpires?.toIso8601String(),
        'verification_status': verificationStatus,
        'verification_fee_paid': verificationFeePaid,
        'average_rating': averageRating,
        'total_jobs': totalJobs,
        'response_time_avg': responseTimeAvg,
        'cancellation_rate': cancellationRate,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  ProfessionalProfile toEntity() => ProfessionalProfile(
        userId: userId,
        categoryId: categoryId,
        professionId: professionId,
        skills: skills,
        experienceYears: experienceYears,
        about: about,
        availability: availability,
        isFeatured: isFeatured,
        featuredExpires: featuredExpires,
        verificationStatus: verificationStatus,
        verificationFeePaid: verificationFeePaid,
        averageRating: averageRating ?? 0,
        totalJobs: totalJobs,
        responseTimeAvg: responseTimeAvg,
        cancellationRate: cancellationRate ?? 0,
        createdAt: createdAt,
        updatedAt: updatedAt,
        category: category,
        profession: profession,
      );
}
