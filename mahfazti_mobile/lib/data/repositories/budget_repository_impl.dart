import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/remote/budget_remote_data_source.dart';
import '../models/create_budget_request_model.dart';
import '../models/update_budget_request_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource _remoteDataSource;

  BudgetRepositoryImpl({
    required BudgetRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Budget>> getBudgets({
    int? year,
    int? month,
  }) async {
    final models = await _remoteDataSource.getBudgets(
      year: year,
      month: month,
    );

    return models
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<Budget> getBudgetById(
    int id,
  ) async {
    final model =
        await _remoteDataSource.getBudgetById(id);

    return model.toEntity();
  }

  @override
  Future<Budget> createBudget({
    required double amount,
    required int categoryId,
    required int year,
    required int month,
  }) async {
    final request = CreateBudgetRequestModel(
      amount: amount,
      categoryId: categoryId,
      year: year,
      month: month,
    );

    final model =
        await _remoteDataSource.createBudget(request);

    return model.toEntity();
  }

  @override
  Future<Budget> updateBudget({
    required int id,
    required double amount,
    required int categoryId,
    required int year,
    required int month,
  }) async {
    final request = UpdateBudgetRequestModel(
      amount: amount,
      categoryId: categoryId,
      year: year,
      month: month,
    );

    final model =
        await _remoteDataSource.updateBudget(
      id,
      request,
    );

    return model.toEntity();
  }

  @override
  Future<void> deleteBudget(
    int id,
  ) async {
    await _remoteDataSource.deleteBudget(id);
  }
}