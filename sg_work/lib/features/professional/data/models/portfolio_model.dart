import '../../domain/entities/portfolio.dart';

class PortfolioModel {
  final String id;
  final String professionalId;
  final String? title;
  final String? description;
  final String imageUrl;
  final DateTime createdAt;

  PortfolioModel({
    required this.id,
    required this.professionalId,
    this.title,
    this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      id: json['id'] as String? ?? '',
      professionalId: json['professional_id'] as String? ?? '',
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'professional_id': professionalId,
        'title': title,
        'description': description,
        'image_url': imageUrl,
        'created_at': createdAt.toIso8601String(),
      };

  Portfolio toEntity() => Portfolio(
        id: id,
        professionalId: professionalId,
        title: title,
        description: description,
        imageUrl: imageUrl,
        createdAt: createdAt,
      );
}
