import '../enums/income_source.dart';

class Income {
  final int id;
  final double amount;
  final IncomeSource source;
  final DateTime date;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Income({
    required this.id,
    required this.amount,
    required this.source,
    required this.date,
    this.description,
    this.createdAt,
    this.updatedAt,
  });
}
