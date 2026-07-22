import 'package:dio/dio.dart';
import '../models/professional_profile_model.dart';
import '../models/certificate_model.dart';
import '../models/portfolio_model.dart';
import '../../../customer/data/models/job_model.dart';

class ProfessionalRemoteDataSource {
  final Dio dio;

  ProfessionalRemoteDataSource({required this.dio});

  static const String _base = '/api/v1';

  Future<ProfessionalProfileModel> getProfile() async {
    final response = await dio.get('$_base/professional/profile');
    return ProfessionalProfileModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<ProfessionalProfileModel> updateProfile(Map<String, dynamic> data) async {
    final response = await dio.patch('$_base/professional/profile', data: data);
    return ProfessionalProfileModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<ProfessionalProfileModel> updateAvailability(String availability) async {
    final response = await dio.patch(
      '$_base/professional/availability',
      data: {'availability': availability},
    );
    return ProfessionalProfileModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> submitVerification() async {
    await dio.post('$_base/professional/verify');
  }

  Future<Map<String, dynamic>> getVerificationStatus() async {
    final response = await dio.get('$_base/professional/verify/status');
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<CertificateModel> addCertificate(Map<String, dynamic> data) async {
    final response = await dio.post('$_base/professional/certificates', data: data);
    return CertificateModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<CertificateModel>> getCertificates() async {
    final response = await dio.get('$_base/professional/certificates');
    final list = response.data['data'] as List;
    return list.map((e) => CertificateModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> deleteCertificate(String id) async {
    await dio.delete('$_base/professional/certificates/$id');
  }

  Future<PortfolioModel> addPortfolio(Map<String, dynamic> data) async {
    final response = await dio.post('$_base/professional/portfolio', data: data);
    return PortfolioModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<PortfolioModel>> getPortfolio() async {
    final response = await dio.get('$_base/professional/portfolio');
    final list = response.data['data'] as List;
    return list.map((e) => PortfolioModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> deletePortfolio(String id) async {
    await dio.delete('$_base/professional/portfolio/$id');
  }

  Future<List<Map<String, dynamic>>> getPendingRequests({
    required double lat,
    required double lng,
    double radius = 10,
  }) async {
    final response = await dio.get(
      '$_base/professional/requests/pending',
      queryParameters: {'lat': lat, 'lng': lng, 'radius': radius},
    );
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<JobModel> acceptRequest(String requestId) async {
    final response = await dio.post('$_base/professional/requests/$requestId/accept');
    return JobModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<JobModel>> getMyJobs({String? status}) async {
    final Map<String, dynamic> params = {};
    if (status != null) params['status'] = status;
    final response = await dio.get('$_base/professional/jobs', queryParameters: params);
    return (response.data['data'] as List)
        .map((e) => JobModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<JobModel> getJobDetails(String jobId) async {
    final response = await dio.get('$_base/professional/jobs/$jobId');
    return JobModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<JobModel> updateJobStatus(String jobId, Map<String, dynamic> data) async {
    final response = await dio.patch('$_base/professional/jobs/$jobId/status', data: data);
    return JobModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> getPerformance() async {
    final response = await dio.get('$_base/professional/performance');
    return response.data['data'] as Map<String, dynamic>;
  }
}
