import '../entities/expense.dart';
import '../enums/payment_method.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
  });

  Future<Expense> getExpenseById(int id);

  Future<Expense> createExpense({
    required double amount,
    required int categoryId,
    required DateTime date,
    required DateTime time,
    required PaymentMethod paymentMethod,
    String? description,
  });

  Future<Expense> updateExpense({
    required int id,
    double? amount,
    int? categoryId,
    DateTime? date,
    DateTime? time,
    PaymentMethod? paymentMethod,
    String? description,
  });

  Future<void> deleteExpense(int id);

  Future<Map<String, dynamic>> getExpenseSummary({
    required DateTime startDate,
    required DateTime endDate,
  });
}
