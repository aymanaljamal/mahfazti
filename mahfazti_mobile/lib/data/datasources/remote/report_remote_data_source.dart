import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/daily_report_model.dart';
import '../../models/monthly_report_model.dart';
import '../../models/weekly_report_model.dart';
import '../../models/yearly_report_model.dart';

class ReportRemoteDataSource {
  final ApiClient _apiClient;

  ReportRemoteDataSource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  Future<DailyReportModel> getDailyReport({
    required DateTime date,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.dailyReport,
      queryParameters: {
        'date': _formatDate(date),
      },
    );

    return DailyReportModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<WeeklyReportModel> getWeeklyReport({
    required DateTime date,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.weeklyReport,
      queryParameters: {
        'date': _formatDate(date),
      },
    );

    return WeeklyReportModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<MonthlyReportModel> getMonthlyReport({
    required int year,
    required int month,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.monthlyReport,
      queryParameters: {
        'year': year,
        'month': month,
      },
    );

    return MonthlyReportModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<YearlyReportModel> getYearlyReport({
    required int year,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.yearlyReport,
      queryParameters: {
        'year': year,
      },
    );

    return YearlyReportModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}