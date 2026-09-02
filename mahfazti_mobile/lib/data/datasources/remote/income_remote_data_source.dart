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

  // =========================================================
  // GET ALL INCOMES
  // GET /api/incomes
  // =========================================================

  Future<List<IncomeModel>> getIncomes({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (startDate != null) {
      queryParameters['startDate'] = _formatDate(startDate);
    }

    if (endDate != null) {
      queryParameters['endDate'] = _formatDate(endDate);
    }

    final response = await _apiClient.get(
      ApiConstants.incomes,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    final responseData = response.data as Map<String, dynamic>;

    final data = responseData['data'];

    if (data is! List) {
      return <IncomeModel>[];
    }

    return data
        .map(
          (item) => IncomeModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  // =========================================================
  // GET INCOME BY ID
  // GET /api/incomes/{id}
  // =========================================================

  Future<IncomeModel> getIncomeById(int id) async {
    final response = await _apiClient.get(
      '${ApiConstants.incomes}/$id',
    );

    final responseData = response.data as Map<String, dynamic>;

    final data = responseData['data'];

    if (data is! Map) {
      throw Exception(
        'بيانات الدخل غير موجودة في استجابة الخادم.',
      );
    }

    return IncomeModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  // =========================================================
  // CREATE INCOME
  // POST /api/incomes
  // =========================================================

  Future<IncomeModel> createIncome(
    CreateIncomeRequestModel request,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.incomes,
      data: request.toJson(),
    );

    final responseData = response.data as Map<String, dynamic>;

    final data = responseData['data'];

    if (data is! Map) {
      throw Exception(
        'بيانات الدخل المضافة غير موجودة في الاستجابة.',
      );
    }

    return IncomeModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  // =========================================================
  // UPDATE INCOME
  // PUT /api/incomes/{id}
  // =========================================================

  Future<IncomeModel> updateIncome(
    int id,
    UpdateIncomeRequestModel request,
  ) async {
    final response = await _apiClient.put(
      '${ApiConstants.incomes}/$id',
      data: request.toJson(),
    );

    final responseData = response.data as Map<String, dynamic>;

    final data = responseData['data'];

    if (data is! Map) {
      throw Exception(
        'بيانات الدخل المعدلة غير موجودة في الاستجابة.',
      );
    }

    return IncomeModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  // =========================================================
  // DELETE INCOME
  // DELETE /api/incomes/{id}
  // =========================================================

  Future<void> deleteIncome(int id) async {
    await _apiClient.delete(
      '${ApiConstants.incomes}/$id',
    );
  }

  // =========================================================
  // DATE FORMAT
  // =========================================================

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
