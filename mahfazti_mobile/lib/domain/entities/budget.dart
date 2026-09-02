class Budget {
  final int id;
  final int categoryId;
  final String categoryName;
  final String? categoryIcon;
  final double amount;
  final int year;
  final int month;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Budget({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    this.categoryIcon,
    required this.amount,
    required this.year,
    required this.month,
    this.createdAt,
    this.updatedAt,
  });
}