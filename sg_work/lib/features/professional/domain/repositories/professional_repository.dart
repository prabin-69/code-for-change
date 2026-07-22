import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/professional_profile.dart';
import '../entities/certificate.dart';
import '../entities/portfolio.dart';
import '../../../../features/customer/domain/entities/job.dart';

abstract class ProfessionalRepository {
  // Profile
  Future<Either<Failure, ProfessionalProfile>> getProfile();
  Future<Either<Failure, ProfessionalProfile>> updateProfile(Map<String, dynamic> data);
  Future<Either<Failure, ProfessionalProfile>> updateAvailability(String availability);

  // Verification
  Future<Either<Failure, void>> submitVerification();
  Future<Either<Failure, Map<String, dynamic>>> getVerificationStatus();

  // Certificates
  Future<Either<Failure, Certificate>> addCertificate(Map<String, dynamic> data);
  Future<Either<Failure, List<Certificate>>> getCertificates();
  Future<Either<Failure, void>> deleteCertificate(String id);

  // Portfolio
  Future<Either<Failure, Portfolio>> addPortfolio(Map<String, dynamic> data);
  Future<Either<Failure, List<Portfolio>>> getPortfolio();
  Future<Either<Failure, void>> deletePortfolio(String id);

  // Jobs & Requests
  Future<Either<Failure, List<Map<String, dynamic>>>> getPendingRequests({required double lat, required double lng, double radius = 10});
  Future<Either<Failure, Job>> acceptRequest(String requestId);
  Future<Either<Failure, List<Job>>> getMyJobs({String? status});
  Future<Either<Failure, Job>> getJobDetails(String jobId);
  Future<Either<Failure, Job>> updateJobStatus(String jobId, Map<String, dynamic> data);

  // Performance
  Future<Either<Failure, Map<String, dynamic>>> getPerformance();
}