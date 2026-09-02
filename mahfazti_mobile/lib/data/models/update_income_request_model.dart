import '../../domain/enums/income_source.dart';

class UpdateIncomeRequestModel {
  final double amount;
  final IncomeSource source;
  final DateTime date;
  final String? description;

  const UpdateIncomeRequestModel({
    required this.amount,
    required this.source,
    required this.date,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'source': source.value,
      'date': date.toIso8601String().split('T').first,
      'description': description,
    };
  }
}