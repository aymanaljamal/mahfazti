import '../entities/budget.dart';

abstract class BudgetRepository {
  Future<List<Budget>> getBudgets({
    int? year,
    int? month,
  });

  Future<Budget> getBudgetById(int id);

  Future<Budget> createBudget({
    required double amount,
    required int categoryId,
    required int year,
    required int month,
  });

  Future<Budget> updateBudget({
    required int id,
    required double amount,
    required int categoryId,
    required int year,
    required int month,
  });

  Future<void> deleteBudget(int id);
}