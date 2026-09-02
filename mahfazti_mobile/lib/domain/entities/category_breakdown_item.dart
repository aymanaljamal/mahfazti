class CategoryBreakdownItem {
  final int categoryId;
  final String categoryName;
  final String? categoryIcon;
  final double totalAmount;
  final double percentage;

  const CategoryBreakdownItem({
    required this.categoryId,
    required this.categoryName,
    this.categoryIcon,
    required this.totalAmount,
    required this.percentage,
  });
}