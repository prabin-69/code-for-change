import '../../domain/entities/profession.dart';

class ProfessionModel {
  final String id;
  final String categoryId;
  final String name;
  final bool isActive;

  ProfessionModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.isActive,
  });

  factory ProfessionModel.fromJson(Map<String, dynamic> json) {
    return ProfessionModel(
      id: json['id'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category_id': categoryId,
        'name': name,
        'is_active': isActive,
      };

  Profession toEntity() => Profession(
        id: id,
        categoryId: categoryId,
        name: name,
        isActive: isActive,
      );
}
