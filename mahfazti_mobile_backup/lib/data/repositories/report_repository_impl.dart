import '../../domain/entities/daily_report.dart';
import '../../domain/entities/monthly_report.dart';
import '../../domain/entities/weekly_report.dart';
import '../../domain/entities/yearly_report.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/remote/report_remote_data_source.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource _remoteDataSource;

  ReportRepositoryImpl({
    required ReportRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<DailyReport> getDailyReport({
    required DateTime date,
  }) async {
    final model = await _remoteDataSource.getDailyReport(
      date: date,
    );

    return model.toEntity();
  }

  @override
  Future<WeeklyReport> getWeeklyReport({
    required DateTime date,
  }) async {
    final model = await _remoteDataSource.getWeeklyReport(
      date: date,
    );

    return model.toEntity();
  }

  @override
  Future<MonthlyReport> getMonthlyReport({
    required int year,
    required int month,
  }) async {
    final model = await _remoteDataSource.getMonthlyReport(
      year: year,
      month: month,
    );

    return model.toEntity();
  }

  @override
  Future<YearlyReport> getYearlyReport({
    required int year,
  }) async {
    final model = await _remoteDataSource.getYearlyReport(
      year: year,
    );

    return model.toEntity();
  }
}
