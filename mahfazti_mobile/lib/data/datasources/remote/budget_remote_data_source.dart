import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/budget_model.dart';
import '../../models/create_budget_request_model.dart';
import '../../models/update_budget_request_model.dart';

class BudgetRemoteDataSource {
  final ApiClient _apiClient;

  BudgetRemoteDataSource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  Future<List<BudgetModel>> getBudgets({
    int? year,
    int? month,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (year != null) {
      queryParameters['year'] = year;
    }

    if (month != null) {
      queryParameters['month'] = month;
    }

    final response = await _apiClient.get(
      ApiConstants.budgets,
      queryParameters:
          queryParameters.isEmpty ? null : queryParameters,
    );

    final data = response.data as List<dynamic>;

    return data
        .map(
          (item) => BudgetModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<BudgetModel> getBudgetById(
    int id,
  ) async {
    final response = await _apiClient.get(
      '${ApiConstants.budgets}/$id',
    );

    return BudgetModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<BudgetModel> createBudget(
    CreateBudgetRequestModel request,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.budgets,
      data: request.toJson(),
    );

    final responseData =
        response.data as Map<String, dynamic>;

    final data =
        responseData['data'] as Map<String, dynamic>;

    return BudgetModel.fromJson(data);
  }

  Future<BudgetModel> updateBudget(
    int id,
    UpdateBudgetRequestModel request,
  ) async {
    final response = await _apiClient.put(
      '${ApiConstants.budgets}/$id',
      data: request.toJson(),
    );

    return BudgetModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> deleteBudget(
    int id,
  ) async {
    await _apiClient.delete(
      '${ApiConstants.budgets}/$id',
    );
  }
}