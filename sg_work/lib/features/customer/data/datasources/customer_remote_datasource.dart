import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../models/profession_model.dart';
import '../models/service_request_model.dart';
import '../models/job_model.dart';

class CustomerRemoteDataSource {
  final Dio dio;

  CustomerRemoteDataSource({required this.dio});

  static const String _base = '/api/v1';

  Future<List<CategoryModel>> getCategories() async {
    final response = await dio.get('$_base/categories');
    final list = response.data['data'] as List;
    return list.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<ProfessionModel>> getProfessionsByCategory(String categoryId) async {
    final response = await dio.get('$_base/categories/$categoryId/professions');
    final list = response.data['data'] as List;
    return list.map((e) => ProfessionModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ServiceRequestModel> createRequest(Map<String, dynamic> data) async {
    final response = await dio.post('$_base/requests', data: data);
    return ServiceRequestModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<ServiceRequestModel>> getMyRequests({String? status}) async {
    final Map<String, dynamic> queryParams = {};
    if (status != null) queryParams['status'] = status;
    final response = await dio.get('$_base/requests', queryParameters: queryParams);
    final list = response.data['data'] as List;
    return list.map((e) => ServiceRequestModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ServiceRequestModel> getRequestById(String id) async {
    final response = await dio.get('$_base/requests/$id');
    return ServiceRequestModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<ServiceRequestModel> cancelRequest(String id, {String? reason}) async {
    final response = await dio.patch(
      '$_base/requests/$id/cancel',
      data: reason != null ? {'reason': reason} : null,
    );
    return ServiceRequestModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<JobModel>> getMyJobs() async {
    final response = await dio.get('$_base/jobs');
    final list = response.data['data'] as List;
    return list.map((e) => JobModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<JobModel> getJobById(String id) async {
    final response = await dio.get('$_base/jobs/$id');
    return JobModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<dynamic>> getFavorites() async {
    final response = await dio.get('$_base/favorites');
    return response.data['data'] as List;
  }

  Future<void> addFavorite(String professionalId) async {
    await dio.post('$_base/favorites', data: {'professional_id': professionalId});
  }

  Future<void> removeFavorite(String professionalId) async {
    await dio.delete('$_base/favorites/$professionalId');
  }

  Future<void> submitReview(String jobId, Map<String, dynamic> data) async {
    await dio.post('$_base/jobs/$jobId/review', data: data);
  }
}
