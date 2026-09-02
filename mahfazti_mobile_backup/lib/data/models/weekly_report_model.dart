import '../../domain/entities/weekly_report.dart';

class WeeklyReportModel {
  final DateTime weekStart;
  final DateTime weekEnd;
  final double totalExpenses;
  final double averageDailySpending;
  final DaySpendingModel highestSpendingDay;
  final String? mostExpensiveCategory;
  final double previousWeekTotal;
  final double percentChangeFromPreviousWeek;

  const WeeklyReportModel({
    required this.weekStart,
    required this.weekEnd,
    required this.totalExpenses,
    required this.averageDailySpending,
    required this.highestSpendingDay,
    this.mostExpensiveCategory,
    required this.previousWeekTotal,
    required this.percentChangeFromPreviousWeek,
  });

  factory WeeklyReportModel.fromJson(Map<String, dynamic> json) {
    return WeeklyReportModel(
      weekStart: DateTime.parse(
        json['weekStart'] as String,
      ),
      weekEnd: DateTime.parse(
        json['weekEnd'] as String,
      ),
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      averageDailySpending: (json['averageDailySpending'] as num).toDouble(),
      highestSpendingDay: DaySpendingModel.fromJson(
        json['highestSpendingDay'] as Map<String, dynamic>,
      ),
      mostExpensiveCategory: json['mostExpensiveCategory'] as String?,
      previousWeekTotal: (json['previousWeekTotal'] as num).toDouble(),
      percentChangeFromPreviousWeek:
          (json['percentChangeFromPreviousWeek'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekStart': weekStart.toIso8601String().split('T').first,
      'weekEnd': weekEnd.toIso8601String().split('T').first,
      'totalExpenses': totalExpenses,
      'averageDailySpending': averageDailySpending,
      'highestSpendingDay': highestSpendingDay.toJson(),
      'mostExpensiveCategory': mostExpensiveCategory,
      'previousWeekTotal': previousWeekTotal,
      'percentChangeFromPreviousWeek': percentChangeFromPreviousWeek,
    };
  }

  WeeklyReport toEntity() {
    return WeeklyReport(
      weekStart: weekStart,
      weekEnd: weekEnd,
      totalExpenses: totalExpenses,
      averageDailySpending: averageDailySpending,
      highestSpendingDay: highestSpendingDay.toEntity(),
      mostExpensiveCategory: mostExpensiveCategory,
      previousWeekTotal: previousWeekTotal,
      percentChangeFromPreviousWeek: percentChangeFromPreviousWeek,
    );
  }
}

class DaySpendingModel {
  final DateTime date;
  final double amount;

  const DaySpendingModel({
    required this.date,
    required this.amount,
  });

  factory DaySpendingModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DaySpendingModel(
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T').first,
      'amount': amount,
    };
  }

  DaySpending toEntity() {
    return DaySpending(
      date: date,
      amount: amount,
    );
  }
}
