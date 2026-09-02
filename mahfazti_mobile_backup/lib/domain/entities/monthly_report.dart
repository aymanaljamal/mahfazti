import 'category_breakdown_item.dart';

class MonthlyReport {
  final int year;
  final int month;
  final double totalIncome;
  final double totalExpenses;
  final double remainingBalance;
  final double averageDailySpending;
  final List<CategoryBreakdownItem> categoryBreakdown;
  final double previousMonthTotalExpenses;
  final double percentChangeFromPreviousMonth;
  final double? overallBudgetUsagePercent;

  const MonthlyReport({
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
}
