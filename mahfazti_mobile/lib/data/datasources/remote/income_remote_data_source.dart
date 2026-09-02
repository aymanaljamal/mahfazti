import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/create_income_request_model.dart';
import '../../models/income_model.dart';
import '../../models/update_income_request_model.dart';

class IncomeRemoteDataSource {
  final ApiClient _apiClient;

  IncomeRemoteDataSource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  Future<List<IncomeModel>> getIncomes({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (startDate != null) {
      queryParameters['startDate'] =
          _formatDate(startDate);
    }

    if (endDate != null) {
      queryParameters['endDate'] =
          _formatDate(endDate);
    }

    final response = await _apiClient.get(
      ApiConstants.incomes,
      queryParameters:
          queryParameters.isEmpty ? null : queryParameters,
    );

    final data = response.data as List<dynamic>;

    return data
        .map(
          (item) => IncomeModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<IncomeModel> getIncomeById(
    int id,
  ) async {
    final response = await _apiClient.get(
      '${ApiConstants.incomes}/$id',
    );

    return IncomeModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<IncomeModel> createIncome(
    CreateIncomeRequestModel request,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.incomes,
      data: request.toJson(),
    );

    final responseData =
        response.data as Map<String, dynamic>;

    final data =
        responseData['data'] as Map<String, dynamic>;

    return IncomeModel.fromJson(data);
  }

  Future<IncomeModel> updateIncome(
    int id,
    UpdateIncomeRequestModel request,
  ) async {
    final response = await _apiClient.put(
      '${ApiConstants.incomes}/$id',
      data: request.toJson(),
    );

    return IncomeModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> deleteIncome(
    int id,
  ) async {
    await _apiClient.delete(
      '${ApiConstants.incomes}/$id',
    );
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}