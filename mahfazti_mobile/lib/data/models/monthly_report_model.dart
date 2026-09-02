import '../../domain/entities/monthly_report.dart';
import 'category_breakdown_item_model.dart';

class MonthlyReportModel {
  final int year;
  final int month;
  final double totalIncome;
  final double totalExpenses;
  final double remainingBalance;
  final double averageDailySpending;
  final List<CategoryBreakdownItemModel> categoryBreakdown;
  final double previousMonthTotalExpenses;
  final double percentChangeFromPreviousMonth;
  final double? overallBudgetUsagePercent;

  const MonthlyReportModel({
    required this.year,
    required this.month,
    required this.totalIncome,
    required this.totalExpenses,
    required this.remainingBalance,
    required this.averageDailySpending,
    required this.categoryBreakdown,
    required this.previousMonthTotalExpenses,
    required this.percentChangeFromPreviousMonth,
    this.overallBudgetUsagePercent,
  });

  factory MonthlyReportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MonthlyReportModel(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      remainingBalance:
          (json['remainingBalance'] as num).toDouble(),
      averageDailySpending:
          (json['averageDailySpending'] as num).toDouble(),
      categoryBreakdown:
          (json['categoryBreakdown'] as List<dynamic>? ?? [])
              .map(
                (item) => CategoryBreakdownItemModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
      previousMonthTotalExpenses:
          (json['previousMonthTotalExpenses'] as num).toDouble(),
      percentChangeFromPreviousMonth:
          (json['percentChangeFromPreviousMonth'] as num).toDouble(),
      overallBudgetUsagePercent:
          (json['overallBudgetUsagePercent'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'remainingBalance': remainingBalance,
      'averageDailySpending': averageDailySpending,
      'categoryBreakdown':
          categoryBreakdown.map((item) => item.toJson()).toList(),
      'previousMonthTotalExpenses': previousMonthTotalExpenses,
      'percentChangeFromPreviousMonth':
          percentChangeFromPreviousMonth,
      'overallBudgetUsagePercent': overallBudgetUsagePercent,
    };
  }

  MonthlyReport toEntity() {
    return MonthlyReport(
      year: year,
      month: month,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      remainingBalance: remainingBalance,
      averageDailySpending: averageDailySpending,
      categoryBreakdown:
          categoryBreakdown.map((item) => item.toEntity()).toList(),
      previousMonthTotalExpenses: previousMonthTotalExpenses,
      percentChangeFromPreviousMonth:
          percentChangeFromPreviousMonth,
      overallBudgetUsagePercent: overallBudgetUsagePercent,
    );
  }
}