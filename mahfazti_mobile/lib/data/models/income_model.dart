import '../../domain/entities/income.dart';
import '../../domain/enums/income_source.dart';

class IncomeModel {
  final int id;
  final double amount;
  final IncomeSource source;
  final DateTime date;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const IncomeModel({
    required this.id,
    required this.amount,
    required this.source,
    required this.date,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: (json['id'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      source: IncomeSourceExtension.fromValue(
        json['source'] as String,
      ),
      date: DateTime.parse(
        json['date'] as String,
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
      'source': source.value,
      'date': date.toIso8601String().split('T').first,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Income toEntity() {
    return Income(
      id: id,
      amount: amount,
      source: source,
      date: date,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
