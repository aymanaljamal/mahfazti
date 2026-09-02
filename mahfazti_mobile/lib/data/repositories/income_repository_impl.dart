import '../../domain/entities/income.dart';
import '../../domain/enums/income_source.dart';
import '../../domain/repositories/income_repository.dart';
import '../datasources/remote/income_remote_data_source.dart';
import '../models/create_income_request_model.dart';
import '../models/update_income_request_model.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final IncomeRemoteDataSource _remoteDataSource;

  IncomeRepositoryImpl({
    required IncomeRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Income>> getIncomes({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final models = await _remoteDataSource.getIncomes(
      startDate: startDate,
      endDate: endDate,
    );

    return models
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<Income> getIncomeById(
    int id,
  ) async {
    final model =
        await _remoteDataSource.getIncomeById(id);

    return model.toEntity();
  }

  @override
  Future<Income> createIncome({
    required double amount,
    required IncomeSource source,
    required DateTime date,
    String? description,
  }) async {
    final request = CreateIncomeRequestModel(
      amount: amount,
      source: source,
      date: date,
      description: description,
    );

    final model =
        await _remoteDataSource.createIncome(request);

    return model.toEntity();
  }

  @override
  Future<Income> updateIncome({
    required int id,
    required double amount,
    required IncomeSource source,
    required DateTime date,
    String? description,
  }) async {
    final request = UpdateIncomeRequestModel(
      amount: amount,
      source: source,
      date: date,
      description: description,
    );

    final model =
        await _remoteDataSource.updateIncome(
      id,
      request,
    );

    return model.toEntity();
  }

  @override
  Future<void> deleteIncome(
    int id,
  ) async {
    await _remoteDataSource.deleteIncome(id);
  }
}