class Category {
  final int id;
  final String name;
  final String? icon;
  final String? color;
  final bool isDefault;

  const Category({
    required this.id,
    required this.name,
    this.icon,
    this.color,
    required this.isDefault,
  });
}
