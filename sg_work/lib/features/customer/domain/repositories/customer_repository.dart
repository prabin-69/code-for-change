import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../entities/profession.dart';
import '../entities/service_request.dart';
import '../entities/job.dart';

abstract class CustomerRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<Profession>>> getProfessionsByCategory(String categoryId);
  Future<Either<Failure, ServiceRequest>> createRequest(Map<String, dynamic> data);
  Future<Either<Failure, List<ServiceRequest>>> getMyRequests({String? status});
  Future<Either<Failure, ServiceRequest>> getRequestById(String id);
  Future<Either<Failure, ServiceRequest>> cancelRequest(String id, {String? reason});
  Future<Either<Failure, List<Job>>> getMyJobs();
  Future<Either<Failure, Job>> getJobById(String id);
  Future<Either<Failure, List<dynamic>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(String professionalId);
  Future<Either<Failure, void>> removeFavorite(String professionalId);
  Future<Either<Failure, void>> submitReview(String jobId, Map<String, dynamic> data);
}
