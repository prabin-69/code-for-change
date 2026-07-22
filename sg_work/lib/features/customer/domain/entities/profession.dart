class Profession {
  final String id;
  final String categoryId;
  final String name;
  final bool isActive;

  const Profession({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.isActive,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profession &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
