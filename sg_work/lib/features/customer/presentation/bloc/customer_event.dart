part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();
}

class LoadCategoriesEvent extends CustomerEvent {
  @override
  List<Object?> get props => [];
}

class LoadProfessionsEvent extends CustomerEvent {
  final String categoryId;
  const LoadProfessionsEvent(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}

class CreateRequestEvent extends CustomerEvent {
  final Map<String, dynamic> data;
  const CreateRequestEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class LoadMyRequestsEvent extends CustomerEvent {
  final String? status;
  const LoadMyRequestsEvent({this.status});
  @override
  List<Object?> get props => [status];
}

class LoadRequestDetailsEvent extends CustomerEvent {
  final String requestId;
  const LoadRequestDetailsEvent(this.requestId);
  @override
  List<Object?> get props => [requestId];
}

class CancelRequestEvent extends CustomerEvent {
  final String requestId;
  final String? reason;
  const CancelRequestEvent(this.requestId, {this.reason});
  @override
  List<Object?> get props => [requestId, reason];
}

class LoadFavoritesEvent extends CustomerEvent {
  @override
  List<Object?> get props => [];
}

class AddFavoriteEvent extends CustomerEvent {
  final String professionalId;
  const AddFavoriteEvent(this.professionalId);
  @override
  List<Object?> get props => [professionalId];
}

class RemoveFavoriteEvent extends CustomerEvent {
  final String professionalId;
  const RemoveFavoriteEvent(this.professionalId);
  @override
  List<Object?> get props => [professionalId];
}
