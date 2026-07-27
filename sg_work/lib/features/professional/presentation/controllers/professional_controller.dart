import '../../data/repositories/professional_repository.dart';
import '../../domain/entities/professional_profile.dart';

class ProfessionalController {
  final ProfessionalRepository repository;

  ProfessionalController(this.repository);

  ProfessionalProfile? profile;

  bool loading = false;

  String? error;

  Future<void> loadProfile() async {
    loading = true;
    error = null;

    try {
      profile = await repository.getProfile().then((e) => e.toEntity());
    } catch (e) {
      error = e.toString();
    }

    loading = false;
  }

  Future<void> changeAvailability(bool online) async {
    if (profile == null) return;

    try {
      profile = await repository
          .updateAvailability(
            online ? "available" : "offline",
          )
          .then((e) => e.toEntity());
    } catch (_) {}
  }

  Future<void> submitVerification() async {
    try {
      await repository.submitVerification();
    } catch (e) {
      error = e.toString();
    }
  }

  Future<void> refresh() async {
    await loadProfile();
  }
}