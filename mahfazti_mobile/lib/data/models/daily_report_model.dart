import '../../domain/entities/daily_report.dart';
import 'category_breakdown_item_model.dart';

class DailyReportModel {
  final DateTime date;
  final double totalExpenses;
  final double totalIncome;
  final int transactionCount;
  final ExpenseHighlightModel? highestExpense;
  final List<CategoryBreakdownItemModel> categoryBreakdown;

  const DailyReportModel({
    required this.date,
    required this.totalExpenses,
    required this.totalIncome,
    required this.transactionCount,
    this.highestExpense,
    required this.categoryBreakdown,
  });

  factory DailyReportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DailyReportModel(
      date: DateTime.parse(json['date'] as String),
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      totalIncome: (json['totalIncome'] as num).toDouble(),
      transactionCount:
          (json['transactionCount'] as num).toInt(),
      highestExpense: json['highestExpense'] != null
          ? ExpenseHighlightModel.fromJson(
              json['highestExpense'] as Map<String, dynamic>,
            )
          : null,
      categoryBreakdown:
          (json['categoryBreakdown'] as List<dynamic>? ?? [])
              .map(
                (item) => CategoryBreakdownItemModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T').first,
      'totalExpenses': totalExpenses,
      'totalIncome': totalIncome,
      'transactionCount': transactionCount,
      'highestExpense': highestExpense?.toJson(),
      'categoryBreakdown':
          categoryBreakdown.map((item) => item.toJson()).toList(),
    };
  }

  DailyReport toEntity() {
    return DailyReport(
      date: date,
      totalExpenses: totalExpenses,
      totalIncome: totalIncome,
      transactionCount: transactionCount,
      highestExpense: highestExpense?.toEntity(),
      categoryBreakdown:
          categoryBreakdown.map((item) => item.toEntity()).toList(),
    );
  }
}

class ExpenseHighlightModel {
  final int expenseId;
  final double amount;
  final String categoryName;
  final String? description;

  const ExpenseHighlightModel({
    required this.expenseId,
    required this.amount,
    required this.categoryName,
    this.description,
  });

  factory ExpenseHighlightModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ExpenseHighlightModel(
      expenseId: (json['expenseId'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      categoryName: json['categoryName'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expenseId': expenseId,
      'amount': amount,
      'categoryName': categoryName,
      'description': description,
    };
  }

  ExpenseHighlight toEntity() {
    return ExpenseHighlight(
      expenseId: expenseId,
      amount: amount,
      categoryName: categoryName,
      description: description,
    );
  }
}