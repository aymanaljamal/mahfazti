import '../../domain/enums/payment_method.dart';

class UpdateExpenseRequestModel {
  final double? amount;
  final int? categoryId;
  final DateTime? date;
  final DateTime? time;
  final PaymentMethod? paymentMethod;
  final String? description;

  const UpdateExpenseRequestModel({
    this.amount,
    this.categoryId,
    this.date,
    this.time,
    this.paymentMethod,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'categoryId': categoryId,
      'date': date?.toIso8601String().split('T').first,
      'time': time?.toIso8601String().split('T').last.substring(0, 8),
      'paymentMethod': paymentMethod?.value,
      'description': description,
    };
  }
}
