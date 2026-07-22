part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SendOtpEvent extends AuthEvent {
  final String phone;

  const SendOtpEvent(this.phone);

  @override
  List<Object?> get props => [phone];
}

class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;

  const VerifyOtpEvent(this.phone, this.otp);

  @override
  List<Object?> get props => [phone, otp];
}

class SelectRoleEvent extends AuthEvent {
  final String role;

  const SelectRoleEvent(this.role);

  @override
  List<Object?> get props => [role];
}

class RefreshTokenEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class LogoutEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class LogoutAllEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}