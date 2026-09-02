class YearlyReport {
  final int year;
  final double totalIncome;
  final double totalExpenses;
  final List<MonthSpending> monthlyBreakdown;

  const YearlyReport({
    required this.year,
    required this.totalIncome,
    required this.totalExpenses,
    required this.monthlyBreakdown,
  });
}

class MonthSpending {
  final int month;
  final String monthName;
  final double totalExpenses;
  final double totalIncome;

  const MonthSpending({
    required this.month,
    required this.monthName,
    required this.totalExpenses,
    required this.totalIncome,
  });
}