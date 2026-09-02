import '../enums/payment_method.dart';

class Expense {
  final int id;
  final double amount;
  final int categoryId;
  final String categoryName;
  final String? categoryIcon;
  final DateTime date;
  final DateTime time;
  final PaymentMethod paymentMethod;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Expense({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    this.categoryIcon,
    required this.date,
    required this.time,
    required this.paymentMethod,
    this.description,
    this.createdAt,
    this.updatedAt,
  });
}