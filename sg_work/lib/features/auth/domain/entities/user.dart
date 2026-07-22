import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String phone;
  final String? firstName;
  final String? lastName;
  final String? photoUrl;
  final String role;
  final bool isActive;
  final bool roleSelected;

  const User({
    required this.id,
    required this.phone,
    this.firstName,
    this.lastName,
    this.photoUrl,
    required this.role,
    required this.isActive,
    this.roleSelected = true,
  });

  String get fullName => '$firstName $lastName'.trim();

  @override
  List<Object?> get props =>
      [id, phone, firstName, lastName, photoUrl, role, isActive, roleSelected];
}