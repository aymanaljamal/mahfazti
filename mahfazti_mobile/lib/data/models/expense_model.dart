import '../../domain/entities/expense.dart';
import '../../domain/enums/payment_method.dart';

class ExpenseModel {
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

  const ExpenseModel({
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

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: (json['id'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      categoryId: (json['categoryId'] as num).toInt(),
      categoryName: json['categoryName'] as String,
      categoryIcon: json['categoryIcon'] as String?,
      date: DateTime.parse(
        json['date'] as String,
      ),
      time: DateTime.parse(
        '1970-01-01T${json['time']}',
      ),
      paymentMethod: PaymentMethodExtension.fromValue(
        json['paymentMethod'] as String,
      ),
      description: json['description'] as String?,
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
      'amount': amount,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon,
      'date': date.toIso8601String().split('T').first,
      'time': time.toIso8601String().split('T').last.substring(0, 8),
      'paymentMethod': paymentMethod.value,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Expense toEntity() {
    return Expense(
      id: id,
      amount: amount,
      categoryId: categoryId,
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      date: date,
      time: time,
      paymentMethod: paymentMethod,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}