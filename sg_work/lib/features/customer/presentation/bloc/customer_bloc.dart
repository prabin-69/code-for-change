import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/profession.dart';
import '../../domain/entities/service_request.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_professions_by_category.dart';
import '../../domain/usecases/create_request.dart';
import '../../domain/usecases/get_my_requests.dart';
import '../../domain/usecases/get_request_by_id.dart';
import '../../domain/usecases/cancel_request.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/remove_favorite.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetCategories getCategories;
  final GetProfessionsByCategory getProfessionsByCategory;
  final CreateRequest createRequest;
  final GetMyRequests getMyRequests;
  final GetRequestById getRequestById;
  final CancelRequest cancelRequest;
  final GetFavorites getFavorites;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;

  CustomerBloc({
    required this.getCategories,
    required this.getProfessionsByCategory,
    required this.createRequest,
    required this.getMyRequests,
    required this.getRequestById,
    required this.cancelRequest,
    required this.getFavorites,
    required this.addFavorite,
    required this.removeFavorite,
  }) : super(CustomerInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadProfessionsEvent>(_onLoadProfessions);
    on<CreateRequestEvent>(_onCreateRequest);
    on<LoadMyRequestsEvent>(_onLoadMyRequests);
    on<LoadRequestDetailsEvent>(_onLoadRequestDetails);
    on<CancelRequestEvent>(_onCancelRequest);
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
  }

  Future<void> _onLoadCategories(
      LoadCategoriesEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    final result = await getCategories();
    result.fold(
      (failure) => emit(CustomerFailure(failure.message)),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }

  Future<void> _onLoadProfessions(
      LoadProfessionsEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    final result = await getProfessionsByCategory(event.categoryId);
    result.fold(
      (failure) => emit(CustomerFailure(failure.message)),
      (professions) => emit(ProfessionsLoaded(professions)),
    );
  }

  Future<void> _onCreateRequest(
      CreateRequestEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    final result = await createRequest(event.data);
    result.fold(
      (failure) => emit(CustomerFailure(failure.message)),
      (request) => emit(RequestCreated(request)),
    );
  }

  Future<void> _onLoadMyRequests(
      LoadMyRequestsEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    final result = await getMyRequests(status: event.status);
    result.fold(
      (failure) => emit(CustomerFailure(failure.message)),
      (requests) => emit(MyRequestsLoaded(requests)),
    );
  }

  Future<void> _onLoadRequestDetails(
      LoadRequestDetailsEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    final result = await getRequestById(event.requestId);
    result.fold(
      (failure) => emit(CustomerFailure(failure.message)),
      (request) => emit(RequestDetailsLoaded(request)),
    );
  }

  Future<void> _onCancelRequest(
      CancelRequestEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    final result = await cancelRequest(event.requestId, reason: event.reason);
    result.fold(
      (failure) => emit(CustomerFailure(failure.message)),
      (request) => emit(RequestCancelled(request)),
    );
  }

  Future<void> _onLoadFavorites(
      LoadFavoritesEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    final result = await getFavorites();
    result.fold(
      (failure) => emit(CustomerFailure(failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  Future<void> _onAddFavorite(
      AddFavoriteEvent event, Emitter<CustomerState> emit) async {
    final result = await addFavorite(event.professionalId);
    result.fold(
      (failure) => emit(CustomerFailure(failure.message)),
      (_) => emit(const FavoriteToggled(added: true)),
    );
  }

  Future<void> _onRemoveFavorite(
      RemoveFavoriteEvent event, Emitter<CustomerState> emit) async {
    final result = await removeFavorite(event.professionalId);
    result.fold(
      (failure) => emit(CustomerFailure(failure.message)),
      (_) => emit(const FavoriteToggled(added: false)),
    );
  }
}
