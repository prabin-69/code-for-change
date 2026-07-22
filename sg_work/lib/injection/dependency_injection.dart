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

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // ─── Network ───────────────────────────────────────────────────────────────
  locator.registerLazySingleton<DioClient>(() => DioClient());
  locator.registerLazySingleton<Dio>(() => locator<DioClient>().dio);

  // ─── Auth ──────────────────────────────────────────────────────────────────
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(dio: locator<Dio>()),
  );
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: locator<AuthRemoteDataSource>()),
  );
  locator.registerLazySingleton(() => SendOtp(locator<AuthRepository>()));
  locator.registerLazySingleton(() => VerifyOtp(locator<AuthRepository>()));
  locator.registerLazySingleton(() => SelectRole(locator<AuthRepository>()));
  locator.registerLazySingleton(() => RefreshToken(locator<AuthRepository>()));
  locator.registerLazySingleton(() => Logout(locator<AuthRepository>()));
  locator.registerLazySingleton(() => LogoutAll(locator<AuthRepository>()));
  locator.registerLazySingleton(() => GetCurrentUser(locator<AuthRepository>()));
  locator.registerFactory(() => AuthBloc(
        sendOtp: locator<SendOtp>(),
        verifyOtp: locator<VerifyOtp>(),
        selectRole: locator<SelectRole>(),
        refreshToken: locator<RefreshToken>(),
        logout: locator<Logout>(),
        logoutAll: locator<LogoutAll>(),
        getCurrentUser: locator<GetCurrentUser>(),
      ));

  // ─── Customer ──────────────────────────────────────────────────────────────
  locator.registerLazySingleton<CustomerRemoteDataSource>(
    () => CustomerRemoteDataSource(dio: locator<Dio>()),
  );
  locator.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(remoteDataSource: locator<CustomerRemoteDataSource>()),
  );
  locator.registerLazySingleton(() => GetCategories(locator<CustomerRepository>()));
  locator.registerLazySingleton(() => GetProfessionsByCategory(locator<CustomerRepository>()));
  locator.registerLazySingleton(() => CreateRequest(locator<CustomerRepository>()));
  locator.registerLazySingleton(() => GetMyRequests(locator<CustomerRepository>()));
  locator.registerLazySingleton(() => GetRequestById(locator<CustomerRepository>()));
  locator.registerLazySingleton(() => CancelRequest(locator<CustomerRepository>()));
  locator.registerLazySingleton(() => GetFavorites(locator<CustomerRepository>()));
  locator.registerLazySingleton(() => AddFavorite(locator<CustomerRepository>()));
  locator.registerLazySingleton(() => RemoveFavorite(locator<CustomerRepository>()));
  locator.registerFactory(() => CustomerBloc(
        getCategories: locator<GetCategories>(),
        getProfessionsByCategory: locator<GetProfessionsByCategory>(),
        createRequest: locator<CreateRequest>(),
        getMyRequests: locator<GetMyRequests>(),
        getRequestById: locator<GetRequestById>(),
        cancelRequest: locator<CancelRequest>(),
        getFavorites: locator<GetFavorites>(),
        addFavorite: locator<AddFavorite>(),
        removeFavorite: locator<RemoveFavorite>(),
      ));

  // ─── Professional ──────────────────────────────────────────────────────────
  locator.registerLazySingleton<ProfessionalRemoteDataSource>(
    () => ProfessionalRemoteDataSource(dio: locator<Dio>()),
  );
  locator.registerLazySingleton<ProfessionalRepository>(
    () => ProfessionalRepositoryImpl(remoteDataSource: locator<ProfessionalRemoteDataSource>()),
  );
  locator.registerLazySingleton(() => GetProfile(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => UpdateProfile(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => UpdateAvailability(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => SubmitVerification(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => GetVerificationStatus(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => AddCertificate(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => GetCertificates(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => DeleteCertificate(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => AddPortfolio(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => GetPortfolio(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => DeletePortfolio(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => GetPendingRequests(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => AcceptRequest(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => GetMyJobs(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => GetJobDetails(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => UpdateJobStatus(locator<ProfessionalRepository>()));
  locator.registerLazySingleton(() => GetPerformance(locator<ProfessionalRepository>()));
  locator.registerFactory(() => ProfessionalBloc(
        getProfile: locator<GetProfile>(),
        updateProfile: locator<UpdateProfile>(),
        updateAvailability: locator<UpdateAvailability>(),
        submitVerification: locator<SubmitVerification>(),
        getVerificationStatus: locator<GetVerificationStatus>(),
        addCertificate: locator<AddCertificate>(),
        getCertificates: locator<GetCertificates>(),
        deleteCertificate: locator<DeleteCertificate>(),
        addPortfolio: locator<AddPortfolio>(),
        getPortfolio: locator<GetPortfolio>(),
        deletePortfolio: locator<DeletePortfolio>(),
        getPendingRequests: locator<GetPendingRequests>(),
        acceptRequest: locator<AcceptRequest>(),
        getMyJobs: locator<GetMyJobs>(),
        getJobDetails: locator<GetJobDetails>(),
        updateJobStatus: locator<UpdateJobStatus>(),
        getPerformance: locator<GetPerformance>(),
      ));
}
