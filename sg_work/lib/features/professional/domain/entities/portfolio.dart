class Portfolio {
  final String id;
  final String professionalId;
  final String? title;
  final String? description;
  final String imageUrl;
  final DateTime createdAt;

  const Portfolio({
    required this.id,
    required this.professionalId,
    this.title,
    this.description,
    required this.imageUrl,
    required this.createdAt,
  });
}