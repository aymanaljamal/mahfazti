import '../../domain/entities/category_breakdown_item.dart';

class CategoryBreakdownItemModel {
  final int categoryId;
  final String categoryName;
  final String? categoryIcon;
  final double totalAmount;
  final double percentage;

  const CategoryBreakdownItemModel({
    required this.categoryId,
    required this.categoryName,
    this.categoryIcon,
    required this.totalAmount,
    required this.percentage,
  });

  factory CategoryBreakdownItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CategoryBreakdownItemModel(
      categoryId: (json['categoryId'] as num).toInt(),
      categoryName: json['categoryName'] as String,
      categoryIcon: json['categoryIcon'] as String?,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon,
      'totalAmount': totalAmount,
      'percentage': percentage,
    };
  }

  CategoryBreakdownItem toEntity() {
    return CategoryBreakdownItem(
      categoryId: categoryId,
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      totalAmount: totalAmount,
      percentage: percentage,
    );
  }
}
