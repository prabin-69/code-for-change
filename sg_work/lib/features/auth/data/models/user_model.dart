import '../../../auth/domain/entities/user.dart';

class UserModel {
  final String id;
  final String phone;
  final String? firstName;
  final String? lastName;
  final String? photoUrl;
  final String role;
  final bool isActive;
  final bool roleSelected;

  UserModel({
    required this.id,
    required this.phone,
    this.firstName,
    this.lastName,
    this.photoUrl,
    required this.role,
    required this.isActive,
    required this.roleSelected,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      photoUrl: json['photo_url'] as String?,
      role: json['role'] as String? ?? 'customer',
      isActive: json['is_active'] as bool? ?? true,
      // Defaults to true only if the field is missing entirely (e.g. a
      // cached user blob saved before this field existed) so we never
      // regress an already-authenticated user back into role selection.
      roleSelected: json['role_selected'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'first_name': firstName,
        'last_name': lastName,
        'photo_url': photoUrl,
        'role': role,
        'is_active': isActive,
        'role_selected': roleSelected,
      };

  User toEntity() {
    return User(
      id: id,
      phone: phone,
      firstName: firstName,
      lastName: lastName,
      photoUrl: photoUrl,
      role: role,
      isActive: isActive,
      roleSelected: roleSelected,
    );
  }
}
