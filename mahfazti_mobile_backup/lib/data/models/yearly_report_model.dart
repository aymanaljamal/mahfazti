import '../../domain/entities/yearly_report.dart';

class YearlyReportModel {
  final int year;
  final double totalIncome;
  final double totalExpenses;
  final List<MonthSpendingModel> monthlyBreakdown;

  const YearlyReportModel({
    required this.year,
    required this.totalIncome,
    required this.totalExpenses,
    required this.monthlyBreakdown,
  });

  factory YearlyReportModel.fromJson(Map<String, dynamic> json) {
    return YearlyReportModel(
      year: (json['year'] as num).toInt(),
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      monthlyBreakdown: (json['monthlyBreakdown'] as List<dynamic>? ?? [])
          .map(
            (item) => MonthSpendingModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'monthlyBreakdown':
          monthlyBreakdown.map((item) => item.toJson()).toList(),
    };
  }

  YearlyReport toEntity() {
    return YearlyReport(
      year: year,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      monthlyBreakdown:
          monthlyBreakdown.map((item) => item.toEntity()).toList(),
    );
  }
}

class MonthSpendingModel {
  final int month;
  final String monthName;
  final double totalExpenses;
  final double totalIncome;

  const MonthSpendingModel({
    required this.month,
    required this.monthName,
    required this.totalExpenses,
    required this.totalIncome,
  });

  factory MonthSpendingModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MonthSpendingModel(
      month: (json['month'] as num).toInt(),
      monthName: json['monthName'] as String,
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      totalIncome: (json['totalIncome'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'monthName': monthName,
      'totalExpenses': totalExpenses,
      'totalIncome': totalIncome,
    };
  }

  MonthSpending toEntity() {
    return MonthSpending(
      month: month,
      monthName: monthName,
      totalExpenses: totalExpenses,
      totalIncome: totalIncome,
    );
  }
}
