import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../domain/usecases/select_role.dart';
import '../../domain/usecases/refresh_token.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/logout_all.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/entities/user.dart';
import '../../../../core/utils/secure_storage_helper.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtp sendOtp;
  final VerifyOtp verifyOtp;
  final SelectRole selectRole;
  final RefreshToken refreshToken;
  final Logout logout;
  final LogoutAll logoutAll;
  final GetCurrentUser getCurrentUser;
  bool _isSelectingRole = false;

  AuthBloc({
    required this.sendOtp,
    required this.verifyOtp,
    required this.selectRole,
    required this.refreshToken,
    required this.logout,
    required this.logoutAll,
    required this.getCurrentUser,
  }) : super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<SelectRoleEvent>(_onSelectRole);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<LogoutEvent>(_onLogout);
    on<LogoutAllEvent>(_onLogoutAll);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onSendOtp(
      SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await sendOtp(event.phone);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(OtpSent(phone: event.phone)),
    );
  }

  // Shared by verify-otp, refresh, and select-role: a user only ever reaches
  // Authenticated once a role has actually been chosen. Brand-new users (and
  // anyone whose role was reset by an admin) get routed to role selection
  // instead of falling through to Home/dashboard.
  //
  // NOTE: AuthSuccess is the single source of truth for the authenticated
  // state – it carries the User and accessToken.  We do NOT emit a separate
  // Authenticated() state because that would overwrite AuthSuccess and lose
  // the user data, breaking downstream screens that check `is AuthSuccess`.
  void _emitPostAuthState(User user, Emitter<AuthState> emit) {
    if (!user.roleSelected) {
      emit(RoleSelectionRequired(user: user));
      return;
    }
    emit(AuthSuccess(
      user: user,
      accessToken: SecureStorageHelper.getAccessToken() ?? '',
    ));
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await verifyOtp(event.phone, event.otp);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitPostAuthState(user, emit),
    );
  }

  Future<void> _onSelectRole(
      SelectRoleEvent event, Emitter<AuthState> emit) async {
    // Bloc processes events concurrently by default. Ignore any repeated tap
    // while the first role-selection request is still in flight.
    if (_isSelectingRole) return;

    _isSelectingRole = true;
    try {
      emit(AuthLoading());
      final result = await selectRole(event.role);
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => _emitPostAuthState(user, emit),
      );
    } finally {
      _isSelectingRole = false;
    }
  }

  Future<void> _onRefreshToken(
      RefreshTokenEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await refreshToken();
    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) => _emitPostAuthState(user, emit),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await logout();
    emit(Unauthenticated());
  }

  Future<void> _onLogoutAll(
      LogoutAllEvent event, Emitter<AuthState> emit) async {
    await logoutAll();
    emit(Unauthenticated());
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    final hasToken = await SecureStorageHelper.hasRefreshToken();
    if (hasToken) {
      add(RefreshTokenEvent());
    } else {
      emit(Unauthenticated());
    }
  }
}
