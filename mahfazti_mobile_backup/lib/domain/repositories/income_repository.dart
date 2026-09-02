import '../entities/income.dart';
import '../enums/income_source.dart';

abstract class IncomeRepository {
  Future<List<Income>> getIncomes({
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Income> getIncomeById(int id);

  Future<Income> createIncome({
    required double amount,
    required IncomeSource source,
    required DateTime date,
    String? description,
  });

  Future<Income> updateIncome({
    required int id,
    required double amount,
    required IncomeSource source,
    required DateTime date,
    String? description,
  });

  Future<void> deleteIncome(int id);
}
