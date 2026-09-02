import 'category_breakdown_item.dart';

class DailyReport {
  final DateTime date;
  final double totalExpenses;
  final double totalIncome;
  final int transactionCount;
  final ExpenseHighlight? highestExpense;
  final List<CategoryBreakdownItem> categoryBreakdown;

  const DailyReport({
    required this.date,
    required this.totalExpenses,
    required this.totalIncome,
    required this.transactionCount,
    this.highestExpense,
    required this.categoryBreakdown,
  });
}

class ExpenseHighlight {
  final int expenseId;
  final double amount;
  final String categoryName;
  final String? description;

  const ExpenseHighlight({
    required this.expenseId,
    required this.amount,
    required this.categoryName,
    this.description,
  });
}
