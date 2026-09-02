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

  // =========================================================
  // GET ALL BUDGETS
  // GET /api/budgets
  // =========================================================

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

    final responseData = response.data as Map<String, dynamic>;

    final data = responseData['data'];

    if (data is! List) {
      return <BudgetModel>[];
    }

    return data
        .map(
          (item) => BudgetModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  // =========================================================
  // GET BUDGET BY ID
  // GET /api/budgets/{id}
  // =========================================================

  Future<BudgetModel> getBudgetById(int id) async {
    final response = await _apiClient.get(
      '${ApiConstants.budgets}/$id',
    );

    final responseData = response.data as Map<String, dynamic>;

    final data = responseData['data'];

    if (data is! Map) {
      throw Exception(
        'بيانات الميزانية غير موجودة في استجابة الخادم.',
      );
    }

    return BudgetModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  // =========================================================
  // CREATE BUDGET
  // POST /api/budgets
  // =========================================================

  Future<BudgetModel> createBudget(
    CreateBudgetRequestModel request,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.budgets,
      data: request.toJson(),
    );

    final responseData = response.data as Map<String, dynamic>;

    final data = responseData['data'];

    if (data is! Map) {
      throw Exception(
        'بيانات الميزانية المضافة غير موجودة في الاستجابة.',
      );
    }

    return BudgetModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  // =========================================================
  // UPDATE BUDGET
  // PUT /api/budgets/{id}
  // =========================================================

  Future<BudgetModel> updateBudget(
    int id,
    UpdateBudgetRequestModel request,
  ) async {
    final response = await _apiClient.put(
      '${ApiConstants.budgets}/$id',
      data: request.toJson(),
    );

    final responseData = response.data as Map<String, dynamic>;

    final data = responseData['data'];

    if (data is! Map) {
      throw Exception(
        'بيانات الميزانية المعدلة غير موجودة في الاستجابة.',
      );
    }

    return BudgetModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  // =========================================================
  // DELETE BUDGET
  // DELETE /api/budgets/{id}
  // =========================================================

  Future<void> deleteBudget(int id) async {
    await _apiClient.delete(
      '${ApiConstants.budgets}/$id',
    );
  }
}