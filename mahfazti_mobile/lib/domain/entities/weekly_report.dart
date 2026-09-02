class WeeklyReport {
  final DateTime weekStart;
  final DateTime weekEnd;
  final double totalExpenses;
  final double averageDailySpending;
  final DaySpending highestSpendingDay;
  final String? mostExpensiveCategory;
  final double previousWeekTotal;
  final double percentChangeFromPreviousWeek;

  const WeeklyReport({
    required this.weekStart,
    required this.weekEnd,
    required this.totalExpenses,
    required this.averageDailySpending,
    required this.highestSpendingDay,
    this.mostExpensiveCategory,
    required this.previousWeekTotal,
    required this.percentChangeFromPreviousWeek,
  });
}

class DaySpending {
  final DateTime date;
  final double amount;

  const DaySpending({
    required this.date,
    required this.amount,
  });
}