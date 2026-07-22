part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();
}

class CustomerInitial extends CustomerState {
  @override
  List<Object?> get props => [];
}

class CustomerLoading extends CustomerState {
  @override
  List<Object?> get props => [];
}

class CustomerFailure extends CustomerState {
  final String message;
  const CustomerFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class CategoriesLoaded extends CustomerState {
  final List<Category> categories;
  const CategoriesLoaded(this.categories);
  @override
  List<Object?> get props => [categories];
}

class ProfessionsLoaded extends CustomerState {
  final List<Profession> professions;
  const ProfessionsLoaded(this.professions);
  @override
  List<Object?> get props => [professions];
}

class RequestCreated extends CustomerState {
  final ServiceRequest request;
  const RequestCreated(this.request);
  @override
  List<Object?> get props => [request];
}

class MyRequestsLoaded extends CustomerState {
  final List<ServiceRequest> requests;
  const MyRequestsLoaded(this.requests);
  @override
  List<Object?> get props => [requests];
}

class RequestDetailsLoaded extends CustomerState {
  final ServiceRequest request;
  const RequestDetailsLoaded(this.request);
  @override
  List<Object?> get props => [request];
}

class RequestCancelled extends CustomerState {
  final ServiceRequest request;
  const RequestCancelled(this.request);
  @override
  List<Object?> get props => [request];
}

class FavoritesLoaded extends CustomerState {
  final List<dynamic> favorites;
  const FavoritesLoaded(this.favorites);
  @override
  List<Object?> get props => [favorites];
}

class FavoriteToggled extends CustomerState {
  final bool added;
  const FavoriteToggled({required this.added});
  @override
  List<Object?> get props => [added];
}
