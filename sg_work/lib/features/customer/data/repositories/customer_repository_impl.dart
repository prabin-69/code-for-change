import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/profession.dart';
import '../../domain/entities/service_request.dart';
import '../../domain/entities/job.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_datasource.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;

  CustomerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final models = await remoteDataSource.getCategories();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<Profession>>> getProfessionsByCategory(String categoryId) async {
    try {
      final models = await remoteDataSource.getProfessionsByCategory(categoryId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, ServiceRequest>> createRequest(Map<String, dynamic> data) async {
    try {
      final model = await remoteDataSource.createRequest(data);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<ServiceRequest>>> getMyRequests({String? status}) async {
    try {
      final models = await remoteDataSource.getMyRequests(status: status);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, ServiceRequest>> getRequestById(String id) async {
    try {
      final model = await remoteDataSource.getRequestById(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, ServiceRequest>> cancelRequest(String id, {String? reason}) async {
    try {
      final model = await remoteDataSource.cancelRequest(id, reason: reason);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getMyJobs() async {
    try {
      final models = await remoteDataSource.getMyJobs();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Job>> getJobById(String id) async {
    try {
      final model = await remoteDataSource.getJobById(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getFavorites() async {
    try {
      final favorites = await remoteDataSource.getFavorites();
      return Right(favorites);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(String professionalId) async {
    try {
      await remoteDataSource.addFavorite(professionalId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String professionalId) async {
    try {
      await remoteDataSource.removeFavorite(professionalId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> submitReview(String jobId, Map<String, dynamic> data) async {
    try {
      await remoteDataSource.submitReview(jobId, data);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
