import '../../domain/entities/expense.dart';
import '../../domain/enums/payment_method.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/remote/expense_remote_data_source.dart';
import '../models/create_expense_request_model.dart';
import '../models/update_expense_request_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource _remoteDataSource;

  ExpenseRepositoryImpl({
    required ExpenseRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Expense>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
  }) async {
    final models = await _remoteDataSource.getExpenses(
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
    );

    return models
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<Expense> getExpenseById(
    int id,
  ) async {
    final model =
        await _remoteDataSource.getExpenseById(id);

    return model.toEntity();
  }

  @override
  Future<Expense> createExpense({
    required double amount,
    required int categoryId,
    required DateTime date,
    required DateTime time,
    required PaymentMethod paymentMethod,
    String? description,
  }) async {
    final request = CreateExpenseRequestModel(
      amount: amount,
      categoryId: categoryId,
      date: date,
      time: time,
      paymentMethod: paymentMethod,
      description: description,
    );

    final model =
        await _remoteDataSource.createExpense(request);

    return model.toEntity();
  }

  @override
  Future<Expense> updateExpense({
    required int id,
    double? amount,
    int? categoryId,
    DateTime? date,
    DateTime? time,
    PaymentMethod? paymentMethod,
    String? description,
  }) async {
    final request = UpdateExpenseRequestModel(
      amount: amount,
      categoryId: categoryId,
      date: date,
      time: time,
      paymentMethod: paymentMethod,
      description: description,
    );

    final model =
        await _remoteDataSource.updateExpense(
      id,
      request,
    );

    return model.toEntity();
  }

  @override
  Future<void> deleteExpense(
    int id,
  ) async {
    await _remoteDataSource.deleteExpense(id);
  }

  @override
  Future<Map<String, dynamic>> getExpenseSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await _remoteDataSource.getExpenseSummary(
      startDate: startDate,
      endDate: endDate,
    );
  }
}