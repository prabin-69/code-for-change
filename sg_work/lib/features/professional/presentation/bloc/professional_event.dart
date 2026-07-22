part of 'professional_bloc.dart';

abstract class ProfessionalEvent extends Equatable {
  const ProfessionalEvent();
}

class LoadProfileEvent extends ProfessionalEvent {
  @override
  List<Object?> get props => [];
}

class UpdateProfileEvent extends ProfessionalEvent {
  final Map<String, dynamic> data;
  const UpdateProfileEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class UpdateAvailabilityEvent extends ProfessionalEvent {
  final String availability;
  const UpdateAvailabilityEvent(this.availability);
  @override
  List<Object?> get props => [availability];
}

class SubmitVerificationEvent extends ProfessionalEvent {
  @override
  List<Object?> get props => [];
}

class LoadVerificationStatusEvent extends ProfessionalEvent {
  @override
  List<Object?> get props => [];
}

class AddCertificateEvent extends ProfessionalEvent {
  final Map<String, dynamic> data;
  const AddCertificateEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class LoadCertificatesEvent extends ProfessionalEvent {
  @override
  List<Object?> get props => [];
}

class DeleteCertificateEvent extends ProfessionalEvent {
  final String id;
  const DeleteCertificateEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class AddPortfolioEvent extends ProfessionalEvent {
  final Map<String, dynamic> data;
  const AddPortfolioEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class LoadPortfolioEvent extends ProfessionalEvent {
  @override
  List<Object?> get props => [];
}

class DeletePortfolioEvent extends ProfessionalEvent {
  final String id;
  const DeletePortfolioEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class LoadPendingRequestsEvent extends ProfessionalEvent {
  final double lat;
  final double lng;
  final double radius;
  const LoadPendingRequestsEvent({required this.lat, required this.lng, this.radius = 10});
  @override
  List<Object?> get props => [lat, lng, radius];
}

class AcceptRequestEvent extends ProfessionalEvent {
  final String requestId;
  const AcceptRequestEvent(this.requestId);
  @override
  List<Object?> get props => [requestId];
}

class LoadMyJobsEvent extends ProfessionalEvent {
  final String? status;
  const LoadMyJobsEvent({this.status});
  @override
  List<Object?> get props => [status];
}

class LoadJobDetailsEvent extends ProfessionalEvent {
  final String jobId;
  const LoadJobDetailsEvent(this.jobId);
  @override
  List<Object?> get props => [jobId];
}

class UpdateJobStatusEvent extends ProfessionalEvent {
  final String jobId;
  final Map<String, dynamic> data;
  const UpdateJobStatusEvent(this.jobId, this.data);
  @override
  List<Object?> get props => [jobId, data];
}

class LoadPerformanceEvent extends ProfessionalEvent {
  @override
  List<Object?> get props => [];
}
