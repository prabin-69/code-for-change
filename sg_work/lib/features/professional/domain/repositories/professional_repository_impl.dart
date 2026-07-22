import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/error_handler.dart';
import '../entities/professional_profile.dart';
import '../entities/certificate.dart';
import '../entities/portfolio.dart';
import '../repositories/professional_repository.dart';
import '../../../customer/domain/entities/job.dart';
import '../../data/datasources/professional_remote_datasource.dart';

class ProfessionalRepositoryImpl implements ProfessionalRepository {
  final ProfessionalRemoteDataSource remoteDataSource;

  ProfessionalRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProfessionalProfile>> getProfile() async {
    try {
      final model = await remoteDataSource.getProfile();
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, ProfessionalProfile>> updateProfile(Map<String, dynamic> data) async {
    try {
      final model = await remoteDataSource.updateProfile(data);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, ProfessionalProfile>> updateAvailability(String availability) async {
    try {
      final model = await remoteDataSource.updateAvailability(availability);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> submitVerification() async {
    try {
      await remoteDataSource.submitVerification();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getVerificationStatus() async {
    try {
      final status = await remoteDataSource.getVerificationStatus();
      return Right(status);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Certificate>> addCertificate(Map<String, dynamic> data) async {
    try {
      final model = await remoteDataSource.addCertificate(data);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<Certificate>>> getCertificates() async {
    try {
      final models = await remoteDataSource.getCertificates();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCertificate(String id) async {
    try {
      await remoteDataSource.deleteCertificate(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Portfolio>> addPortfolio(Map<String, dynamic> data) async {
    try {
      final model = await remoteDataSource.addPortfolio(data);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<Portfolio>>> getPortfolio() async {
    try {
      final models = await remoteDataSource.getPortfolio();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deletePortfolio(String id) async {
    try {
      await remoteDataSource.deletePortfolio(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getPendingRequests({
    required double lat,
    required double lng,
    double radius = 10,
  }) async {
    try {
      final requests = await remoteDataSource.getPendingRequests(lat: lat, lng: lng, radius: radius);
      return Right(requests);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Job>> acceptRequest(String requestId) async {
    try {
      final model = await remoteDataSource.acceptRequest(requestId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getMyJobs({String? status}) async {
    try {
      final models = await remoteDataSource.getMyJobs(status: status);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Job>> getJobDetails(String jobId) async {
    try {
      final model = await remoteDataSource.getJobDetails(jobId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Job>> updateJobStatus(String jobId, Map<String, dynamic> data) async {
    try {
      final model = await remoteDataSource.updateJobStatus(jobId, data);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPerformance() async {
    try {
      final perf = await remoteDataSource.getPerformance();
      return Right(perf);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
