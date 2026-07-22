part of 'professional_bloc.dart';

abstract class ProfessionalState extends Equatable {
  const ProfessionalState();
}

class ProfessionalInitial extends ProfessionalState {
  @override
  List<Object?> get props => [];
}

class ProfessionalLoading extends ProfessionalState {
  @override
  List<Object?> get props => [];
}

class ProfessionalFailure extends ProfessionalState {
  final String message;
  const ProfessionalFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class ProfessionalActionSuccess extends ProfessionalState {
  final String message;
  final ProfessionalProfile? profile;
  const ProfessionalActionSuccess(this.message, {this.profile});
  @override
  List<Object?> get props => [message, profile];
}

class ProfileLoaded extends ProfessionalState {
  final ProfessionalProfile profile;
  const ProfileLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}

class VerificationStatusLoaded extends ProfessionalState {
  final Map<String, dynamic> status;
  const VerificationStatusLoaded(this.status);
  @override
  List<Object?> get props => [status];
}

class CertificatesLoaded extends ProfessionalState {
  final List<Certificate> certificates;
  const CertificatesLoaded(this.certificates);
  @override
  List<Object?> get props => [certificates];
}

class PortfolioLoaded extends ProfessionalState {
  final List<Portfolio> items;
  const PortfolioLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

class PendingRequestsLoaded extends ProfessionalState {
  final List<Map<String, dynamic>> requests;
  const PendingRequestsLoaded(this.requests);
  @override
  List<Object?> get props => [requests];
}

class MyJobsLoaded extends ProfessionalState {
  final List<Job> jobs;
  const MyJobsLoaded(this.jobs);
  @override
  List<Object?> get props => [jobs];
}

class JobDetailsLoaded extends ProfessionalState {
  final Job job;
  const JobDetailsLoaded(this.job);
  @override
  List<Object?> get props => [job];
}

class PerformanceLoaded extends ProfessionalState {
  final Map<String, dynamic> data;
  const PerformanceLoaded(this.data);
  @override
  List<Object?> get props => [data];
}
