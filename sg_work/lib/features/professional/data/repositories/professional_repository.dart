import '../datasources/professional_remote_data_source.dart';
import '../models/professional_profile_model.dart';

class ProfessionalRepository {
  final ProfessionalRemoteDataSource remote;

  ProfessionalRepository(this.remote);

  Future<ProfessionalProfileModel> getProfile() {
    return remote.getProfile();
  }

  Future<ProfessionalProfileModel> updateProfile(
      Map<String, dynamic> data) {
    return remote.updateProfile(data);
  }

  Future<ProfessionalProfileModel> updateAvailability(
      String availability) {
    return remote.updateAvailability(availability);
  }

  Future<void> submitVerification() {
    return remote.submitVerification();
  }
}