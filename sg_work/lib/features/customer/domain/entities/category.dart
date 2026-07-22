class Category {
  final String id;
  final String name;
  final String? icon;
  final bool isActive;

  const Category({
    required this.id,
    required this.name,
    this.icon,
    required this.isActive,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
