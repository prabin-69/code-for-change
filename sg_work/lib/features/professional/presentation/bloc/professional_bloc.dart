import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/professional_profile.dart';
import '../../domain/entities/certificate.dart';
import '../../domain/entities/portfolio.dart';
import '../../../customer/domain/entities/job.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/update_availability.dart';
import '../../domain/usecases/submit_verification.dart';
import '../../domain/usecases/get_verification_status.dart';
import '../../domain/usecases/add_certificate.dart';
import '../../domain/usecases/get_certificates.dart';
import '../../domain/usecases/delete_certificate.dart';
import '../../domain/usecases/add_portfolio.dart';
import '../../domain/usecases/get_portfolio.dart';
import '../../domain/usecases/delete_portfolio.dart';
import '../../domain/usecases/get_pending_requests.dart';
import '../../domain/usecases/accept_request.dart';
import '../../domain/usecases/get_my_jobs.dart';
import '../../domain/usecases/get_job_details.dart';
import '../../domain/usecases/update_job_status.dart';
import '../../domain/usecases/get_performance.dart';

part 'professional_event.dart';
part 'professional_state.dart';

class ProfessionalBloc extends Bloc<ProfessionalEvent, ProfessionalState> {
  final GetProfile getProfile;
  final UpdateProfile updateProfile;
  final UpdateAvailability updateAvailability;
  final SubmitVerification submitVerification;
  final GetVerificationStatus getVerificationStatus;
  final AddCertificate addCertificate;
  final GetCertificates getCertificates;
  final DeleteCertificate deleteCertificate;
  final AddPortfolio addPortfolio;
  final GetPortfolio getPortfolio;
  final DeletePortfolio deletePortfolio;
  final GetPendingRequests getPendingRequests;
  final AcceptRequest acceptRequest;
  final GetMyJobs getMyJobs;
  final GetJobDetails getJobDetails;
  final UpdateJobStatus updateJobStatus;
  final GetPerformance getPerformance;

  ProfessionalBloc({
    required this.getProfile,
    required this.updateProfile,
    required this.updateAvailability,
    required this.submitVerification,
    required this.getVerificationStatus,
    required this.addCertificate,
    required this.getCertificates,
    required this.deleteCertificate,
    required this.addPortfolio,
    required this.getPortfolio,
    required this.deletePortfolio,
    required this.getPendingRequests,
    required this.acceptRequest,
    required this.getMyJobs,
    required this.getJobDetails,
    required this.updateJobStatus,
    required this.getPerformance,
  }) : super(ProfessionalInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UpdateAvailabilityEvent>(_onUpdateAvailability);
    on<SubmitVerificationEvent>(_onSubmitVerification);
    on<LoadVerificationStatusEvent>(_onLoadVerificationStatus);
    on<AddCertificateEvent>(_onAddCertificate);
    on<LoadCertificatesEvent>(_onLoadCertificates);
    on<DeleteCertificateEvent>(_onDeleteCertificate);
    on<AddPortfolioEvent>(_onAddPortfolio);
    on<LoadPortfolioEvent>(_onLoadPortfolio);
    on<DeletePortfolioEvent>(_onDeletePortfolio);
    on<LoadPendingRequestsEvent>(_onLoadPendingRequests);
    on<AcceptRequestEvent>(_onAcceptRequest);
    on<LoadMyJobsEvent>(_onLoadMyJobs);
    on<LoadJobDetailsEvent>(_onLoadJobDetails);
    on<UpdateJobStatusEvent>(_onUpdateJobStatus);
    on<LoadPerformanceEvent>(_onLoadPerformance);
  }

  Future<void> _onLoadProfile(LoadProfileEvent event, Emitter<ProfessionalState> emit) async {
    emit(ProfessionalLoading());
    final result = await getProfile();
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<ProfessionalState> emit) async {
    emit(ProfessionalLoading());
    final result = await updateProfile(event.data);
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (profile) => emit(ProfessionalActionSuccess('Profile updated', profile: profile)),
    );
  }

  Future<void> _onUpdateAvailability(UpdateAvailabilityEvent event, Emitter<ProfessionalState> emit) async {
    final result = await updateAvailability(event.availability);
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (profile) => emit(ProfessionalActionSuccess('Availability updated', profile: profile)),
    );
  }

  Future<void> _onSubmitVerification(SubmitVerificationEvent event, Emitter<ProfessionalState> emit) async {
    emit(ProfessionalLoading());
    final result = await submitVerification();
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (_) => emit(const ProfessionalActionSuccess('Verification submitted')),
    );
  }

  Future<void> _onLoadVerificationStatus(LoadVerificationStatusEvent event, Emitter<ProfessionalState> emit) async {
    emit(ProfessionalLoading());
    final result = await getVerificationStatus();
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (status) => emit(VerificationStatusLoaded(status)),
    );
  }

  Future<void> _onAddCertificate(AddCertificateEvent event, Emitter<ProfessionalState> emit) async {
    emit(ProfessionalLoading());
    final result = await addCertificate(event.data);
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (_) => emit(const ProfessionalActionSuccess('Certificate added')),
    );
  }

  Future<void> _onLoadCertificates(LoadCertificatesEvent event, Emitter<ProfessionalState> emit) async {
    emit(ProfessionalLoading());
    final result = await getCertificates();
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (certs) => emit(CertificatesLoaded(certs)),
    );
  }

  Future<void> _onDeleteCertificate(DeleteCertificateEvent event, Emitter<ProfessionalState> emit) async {
    final result = await deleteCertificate(event.id);
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (_) => emit(const ProfessionalActionSuccess('Certificate deleted')),
    );
  }

  Future<void> _onAddPortfolio(AddPortfolioEvent event, Emitter<ProfessionalState> emit) async {
    emit(ProfessionalLoading());
    final result = await addPortfolio(event.data);
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (_) => emit(const ProfessionalActionSuccess('Portfolio item added')),
    );
  }

  Future<void> _onLoadPortfolio(LoadPortfolioEvent event, Emitter<ProfessionalState> emit) async {
    emit(ProfessionalLoading());
    final result = await getPortfolio();
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (items) => emit(PortfolioLoaded(items)),
    );
  }

  Future<void> _onDeletePortfolio(DeletePortfolioEvent event, Emitter<ProfessionalState> emit) async {
    final result = await deletePortfolio(event.id);
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (_) => emit(const ProfessionalActionSuccess('Portfolio item deleted')),
    );
  }

  Future<void> _onLoadPendingRequests(LoadPendingRequestsEvent event, Emitter<ProfessionalState> emit) async {
    emit(ProfessionalLoading());
    final result = await getPendingRequests(lat: event.lat, lng: event.lng);
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (requests) => emit(PendingRequestsLoaded(requests)),
    );
  }

  Future<void> _onAcceptRequest(AcceptRequestEvent event, Emitter<ProfessionalState> emit) async {
    emit(ProfessionalLoading());
    final result = await acceptRequest(event.requestId);
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (_) => emit(const ProfessionalActionSuccess('Request accepted')),
    );
  }

  Future<void> _onLoadMyJobs(LoadMyJobsEvent event, Emitter<ProfessionalState> emit) async {
    emit(ProfessionalLoading());
    final result = await getMyJobs(status: event.status);
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (jobs) => emit(MyJobsLoaded(jobs)),
    );
  }

  Future<void> _onLoadJobDetails(LoadJobDetailsEvent event, Emitter<ProfessionalState> emit) async {
    emit(ProfessionalLoading());
    final result = await getJobDetails(event.jobId);
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (job) => emit(JobDetailsLoaded(job)),
    );
  }

  Future<void> _onUpdateJobStatus(UpdateJobStatusEvent event, Emitter<ProfessionalState> emit) async {
    emit(ProfessionalLoading());
    final result = await updateJobStatus(event.jobId, event.data);
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (_) => emit(const ProfessionalActionSuccess('Job status updated')),
    );
  }

  Future<void> _onLoadPerformance(LoadPerformanceEvent event, Emitter<ProfessionalState> emit) async {
    emit(ProfessionalLoading());
    final result = await getPerformance();
    result.fold(
      (failure) => emit(ProfessionalFailure(failure.message)),
      (data) => emit(PerformanceLoaded(data)),
    );
  }
}
