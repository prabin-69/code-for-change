import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../core/network/dio_client.dart';

// Auth
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/send_otp.dart';
import '../features/auth/domain/usecases/verify_otp.dart';
import '../features/auth/domain/usecases/select_role.dart';
import '../features/auth/domain/usecases/refresh_token.dart';
import '../features/auth/domain/usecases/logout.dart';
import '../features/auth/domain/usecases/logout_all.dart';
import '../features/auth/domain/usecases/get_current_user.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

// Customer
import '../features/customer/data/datasources/customer_remote_datasource.dart';
import '../features/customer/data/repositories/customer_repository_impl.dart';
import '../features/customer/domain/repositories/customer_repository.dart';
import '../features/customer/domain/usecases/get_categories.dart';
import '../features/customer/domain/usecases/get_professions_by_category.dart';
import '../features/customer/domain/usecases/create_request.dart';
import '../features/customer/domain/usecases/get_my_requests.dart';
import '../features/customer/domain/usecases/get_request_by_id.dart';
import '../features/customer/domain/usecases/cancel_request.dart';
import '../features/customer/domain/usecases/get_favorites.dart';
import '../features/customer/domain/usecases/add_favorite.dart';
import '../features/customer/domain/usecases/remove_favorite.dart';
import '../features/customer/presentation/bloc/customer_bloc.dart';

// Professional
import '../features/professional/data/datasources/professional_remote_datasource.dart';
import '../features/professional/domain/repositories/professional_repository.dart';
import '../features/professional/domain/repositories/professional_repository_impl.dart';
import '../features/professional/domain/usecases/get_profile.dart';
import '../features/professional/domain/usecases/update_profile.dart';
import '../features/professional/domain/usecases/update_availability.dart';
import '../features/professional/domain/usecases/submit_verification.dart';
import '../features/professional/domain/usecases/get_verification_status.dart';
import '../features/professional/domain/usecases/add_certificate.dart';
import '../features/professional/domain/usecases/get_certificates.dart';
import '../features/professional/domain/usecases/delete_certificate.dart';
import '../features/professional/domain/usecases/add_portfolio.dart';
import '../features/professional/domain/usecases/get_portfolio.dart';
import '../features/professional/domain/usecases/delete_portfolio.dart';
import '../features/professional/domain/usecases/get_pending_requests.dart';
import '../features/professional/domain/usecases/accept_request.dart';
import '../features/professional/domain/usecases/get_my_jobs.dart';
import '../features/professional/domain/usecases/get_job_details.dart';
import '../features/professional/domain/usecases/update_job_status.dart';
import '../features/professional/domain/usecases/get_performance.dart';
import '../features/professional/presentation/bloc/professional_bloc.dart';

// Payments
import '../features/payments/data/datasources/payment_remote_datasource.dart';
import '../features/payments/data/repositories/payment_repository_impl.dart';
import '../features/payments/domain/repositories/payment_repository.dart';
import '../features/payments/domain/usecases/initiate_payment.dart';
import '../features/payments/domain/usecases/verify_payment.dart';
import '../features/payments/domain/usecases/get_my_payments.dart';
import '../features/payments/presentation/bloc/payment_bloc.dart';

// Search
import '../features/search/data/datasources/search_remote_datasource.dart';
import '../features/search/data/repositories/search_repository_impl.dart';
import '../features/search/domain/repositories/search_repository.dart';
import '../features/search/domain/usecases/search_professionals.dart';
import '../features/search/presentation/bloc/search_bloc.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // ================= SEARCH =================

locator.registerLazySingleton<SearchRemoteDataSource>(
  () => SearchRemoteDataSource(
    dio: locator<Dio>(),
  ),
);

locator.registerLazySingleton<SearchRepository>(
  () => SearchRepositoryImpl(
    remoteDataSource: locator<SearchRemoteDataSource>(),
  ),
);

locator.registerLazySingleton<SearchProfessionals>(
  () => SearchProfessionals(
    locator<SearchRepository>(),
  ),
);

locator.registerFactory<SearchBloc>(
  () => SearchBloc(
    searchProfessionals: locator<SearchProfessionals>(),
  ),
);

  // Network
  locator.registerLazySingleton<DioClient>(() => DioClient());
  locator.registerLazySingleton<Dio>(() => locator<DioClient>().dio);

  // ================= AUTH =================

  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(dio: locator<Dio>()),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: locator<AuthRemoteDataSource>(),
    ),
  );

  locator.registerLazySingleton(() => SendOtp(locator<AuthRepository>()));
  locator.registerLazySingleton(() => VerifyOtp(locator<AuthRepository>()));
  locator.registerLazySingleton(() => SelectRole(locator<AuthRepository>()));
  locator.registerLazySingleton(() => RefreshToken(locator<AuthRepository>()));
  locator.registerLazySingleton(() => Logout(locator<AuthRepository>()));
  locator.registerLazySingleton(() => LogoutAll(locator<AuthRepository>()));
  locator.registerLazySingleton(() => GetCurrentUser(locator<AuthRepository>()));

  locator.registerFactory(
    () => AuthBloc(
      sendOtp: locator(),
      verifyOtp: locator(),
      selectRole: locator(),
      refreshToken: locator(),
      logout: locator(),
      logoutAll: locator(),
      getCurrentUser: locator(),
    ),
  );

  // ================= CUSTOMER =================

  locator.registerLazySingleton<CustomerRemoteDataSource>(
    () => CustomerRemoteDataSource(dio: locator<Dio>()),
  );

  locator.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(
      remoteDataSource: locator<CustomerRemoteDataSource>(),
    ),
  );

  locator.registerLazySingleton(() => GetCategories(locator()));
  locator.registerLazySingleton(() => GetProfessionsByCategory(locator()));
  locator.registerLazySingleton(() => CreateRequest(locator()));
  locator.registerLazySingleton(() => GetMyRequests(locator()));
  locator.registerLazySingleton(() => GetRequestById(locator()));
  locator.registerLazySingleton(() => CancelRequest(locator()));
  locator.registerLazySingleton(() => GetFavorites(locator()));
  locator.registerLazySingleton(() => AddFavorite(locator()));
  locator.registerLazySingleton(() => RemoveFavorite(locator()));

  locator.registerFactory(
    () => CustomerBloc(
      getCategories: locator(),
      getProfessionsByCategory: locator(),
      createRequest: locator(),
      getMyRequests: locator(),
      getRequestById: locator(),
      cancelRequest: locator(),
      getFavorites: locator(),
      addFavorite: locator(),
      removeFavorite: locator(),
    ),
  );

  // ================= PROFESSIONAL =================

  locator.registerLazySingleton<ProfessionalRemoteDataSource>(
    () => ProfessionalRemoteDataSource(dio: locator<Dio>()),
  );

  locator.registerLazySingleton<ProfessionalRepository>(
    () => ProfessionalRepositoryImpl(
      remoteDataSource: locator<ProfessionalRemoteDataSource>(),
    ),
  );

  locator.registerLazySingleton(() => GetProfile(locator()));
  locator.registerLazySingleton(() => UpdateProfile(locator()));
  locator.registerLazySingleton(() => UpdateAvailability(locator()));
  locator.registerLazySingleton(() => SubmitVerification(locator()));
  locator.registerLazySingleton(() => GetVerificationStatus(locator()));
  locator.registerLazySingleton(() => AddCertificate(locator()));
  locator.registerLazySingleton(() => GetCertificates(locator()));
  locator.registerLazySingleton(() => DeleteCertificate(locator()));
  locator.registerLazySingleton(() => AddPortfolio(locator()));
  locator.registerLazySingleton(() => GetPortfolio(locator()));
  locator.registerLazySingleton(() => DeletePortfolio(locator()));
  locator.registerLazySingleton(() => GetPendingRequests(locator()));
  locator.registerLazySingleton(() => AcceptRequest(locator()));
  locator.registerLazySingleton(() => GetMyJobs(locator()));
  locator.registerLazySingleton(() => GetJobDetails(locator()));
  locator.registerLazySingleton(() => UpdateJobStatus(locator()));
  locator.registerLazySingleton(() => GetPerformance(locator()));

  locator.registerFactory(
    () => ProfessionalBloc(
      getProfile: locator(),
      updateProfile: locator(),
      updateAvailability: locator(),
      submitVerification: locator(),
      getVerificationStatus: locator(),
      addCertificate: locator(),
      getCertificates: locator(),
      deleteCertificate: locator(),
      addPortfolio: locator(),
      getPortfolio: locator(),
      deletePortfolio: locator(),
      getPendingRequests: locator(),
      acceptRequest: locator(),
      getMyJobs: locator(),
      getJobDetails: locator(),
      updateJobStatus: locator(),
      getPerformance: locator(),
    ),
  );

  // ================= PAYMENTS =================

locator.registerLazySingleton<PaymentRemoteDataSource>(
  () => PaymentRemoteDataSourceImpl(
    dioClient: locator<DioClient>(),
  ),
);

locator.registerLazySingleton<PaymentRepository>(
  () => PaymentRepositoryImpl(
    remoteDataSource: locator<PaymentRemoteDataSource>(),
  ),
);

locator.registerLazySingleton<InitiatePayment>(
  () => InitiatePayment(locator<PaymentRepository>()),
);

locator.registerLazySingleton<VerifyPayment>(
  () => VerifyPayment(locator<PaymentRepository>()),
);

locator.registerLazySingleton<GetMyPayments>(
  () => GetMyPayments(locator<PaymentRepository>()),
);

locator.registerFactory<PaymentBloc>(
  () => PaymentBloc(
    initiatePayment: locator<InitiatePayment>(),
    verifyPayment: locator<VerifyPayment>(),
    getMyPayments: locator<GetMyPayments>(),
  ),
);
}