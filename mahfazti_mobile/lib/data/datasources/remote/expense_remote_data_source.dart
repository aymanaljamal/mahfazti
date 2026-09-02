import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/create_expense_request_model.dart';
import '../../models/expense_model.dart';
import '../../models/update_expense_request_model.dart';

class ExpenseRemoteDataSource {
  final ApiClient _apiClient;

  ExpenseRemoteDataSource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  Future<List<ExpenseModel>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (startDate != null) {
      queryParameters['startDate'] = _formatDate(startDate);
    }

    if (endDate != null) {
      queryParameters['endDate'] = _formatDate(endDate);
    }

    if (categoryId != null) {
      queryParameters['categoryId'] = categoryId;
    }

    final response = await _apiClient.get(
      ApiConstants.expenses,
      queryParameters:
          queryParameters.isEmpty ? null : queryParameters,
    );

    final data = response.data as List<dynamic>;

    return data
        .map(
          (item) => ExpenseModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<ExpenseModel> getExpenseById(
    int id,
  ) async {
    final response = await _apiClient.get(
      '${ApiConstants.expenses}/$id',
    );

    return ExpenseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<ExpenseModel> createExpense(
    CreateExpenseRequestModel request,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.expenses,
      data: request.toJson(),
    );

    return ExpenseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<ExpenseModel> updateExpense(
    int id,
    UpdateExpenseRequestModel request,
  ) async {
    final response = await _apiClient.put(
      '${ApiConstants.expenses}/$id',
      data: request.toJson(),
    );

    return ExpenseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> deleteExpense(
    int id,
  ) async {
    await _apiClient.delete(
      '${ApiConstants.expenses}/$id',
    );
  }

  Future<Map<String, dynamic>> getExpenseSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.expenseSummary,
      queryParameters: {
        'startDate': _formatDate(startDate),
        'endDate': _formatDate(endDate),
      },
    );

    return Map<String, dynamic>.from(
      response.data as Map,
    );
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}