import 'package:equatable/equatable.dart';

class ProfessionalProfile extends Equatable {
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
  final double averageRating;
  final int totalJobs;
  final double? responseTimeAvg;
  final double cancellationRate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic category;
  final dynamic profession;

  const ProfessionalProfile({
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
    required this.averageRating,
    required this.totalJobs,
    this.responseTimeAvg,
    required this.cancellationRate,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.profession,
  });

  @override
  List<Object?> get props => [userId, availability, verificationStatus, averageRating, totalJobs];
}
