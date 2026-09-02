import '../../domain/entities/budget.dart';

class BudgetModel {
  final int id;
  final int categoryId;
  final String categoryName;
  final String? categoryIcon;
  final double amount;
  final int year;
  final int month;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BudgetModel({
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

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: (json['id'] as num).toInt(),
      categoryId: (json['categoryId'] as num).toInt(),
      categoryName: json['categoryName'] as String,
      categoryIcon: json['categoryIcon'] as String?,
      amount: (json['amount'] as num).toDouble(),
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon,
      'amount': amount,
      'year': year,
      'month': month,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Budget toEntity() {
    return Budget(
      id: id,
      categoryId: categoryId,
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      amount: amount,
      year: year,
      month: month,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
