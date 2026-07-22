part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class OtpSent extends AuthState {
  final String phone;
  const OtpSent({required this.phone});
  @override
  List<Object?> get props => [phone];
}

class AuthSuccess extends AuthState {
  final User user;
  final String accessToken;

  const AuthSuccess({required this.user, required this.accessToken});

  @override
  List<Object?> get props => [user, accessToken];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class Authenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class RoleSelectionRequired extends AuthState {
  final User user;

  const RoleSelectionRequired({required this.user});

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}
