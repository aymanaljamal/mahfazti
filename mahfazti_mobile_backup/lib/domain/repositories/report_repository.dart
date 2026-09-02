import '../entities/daily_report.dart';
import '../entities/monthly_report.dart';
import '../entities/weekly_report.dart';
import '../entities/yearly_report.dart';

abstract class ReportRepository {
  Future<DailyReport> getDailyReport({
    required DateTime date,
  });

  Future<WeeklyReport> getWeeklyReport({
    required DateTime date,
  });

  Future<MonthlyReport> getMonthlyReport({
    required int year,
    required int month,
  });

  Future<YearlyReport> getYearlyReport({
    required int year,
  });
}
