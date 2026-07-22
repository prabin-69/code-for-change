import '../../domain/entities/category.dart';

class CategoryModel {
  final String id;
  final String name;
  final String? icon;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    required this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'is_active': isActive,
      };

  Category toEntity() => Category(id: id, name: name, icon: icon, isActive: isActive);
}
