import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/category_breakdown_item.dart';
import '../../../domain/entities/daily_report.dart';
import '../../../domain/entities/monthly_report.dart';
import '../../../domain/entities/weekly_report.dart';
import '../../../domain/entities/yearly_report.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_empty_view.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/app_loading.dart';

enum ReportType {
  daily,
  weekly,
  monthly,
  yearly,
}

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  ReportType _selectedType = ReportType.monthly;

  DateTime _selectedDate = DateTime.now();
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  late Future<Object> _future;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  void _loadReport() {
    final repository = ref.read(reportRepositoryProvider);

    switch (_selectedType) {
      case ReportType.daily:
        _future = repository.getDailyReport(
          date: _selectedDate,
        );
        break;

      case ReportType.weekly:
        _future = repository.getWeeklyReport(
          date: _selectedDate,
        );
        break;

      case ReportType.monthly:
        _future = repository.getMonthlyReport(
          year: _selectedYear,
          month: _selectedMonth,
        );
        break;

      case ReportType.yearly:
        _future = repository.getYearlyReport(
          year: _selectedYear,
        );
        break;
    }
  }

  Future<void> _refresh() async {
    setState(_loadReport);

    try {
      await _future;
    } catch (_) {}
  }

  String _money(double value) {
    return NumberFormat.currency(
      locale: 'ar',
      symbol: '₪',
      decimalDigits: 2,
    ).format(value);
  }

  String _reportTitle() {
    switch (_selectedType) {
      case ReportType.daily:
        return 'التقرير اليومي';

      case ReportType.weekly:
        return 'التقرير الأسبوعي';

      case ReportType.monthly:
        return 'التقرير الشهري';

      case ReportType.yearly:
        return 'التقرير السنوي';
    }
  }

  String _monthName(int month) {
    return DateFormat(
      'MMMM',
      'ar',
    ).format(
      DateTime(
        2026,
        month,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_reportTitle()),
        actions: [
          IconButton(
            tooltip: 'تغيير الفترة',
            onPressed: _showPeriodPicker,
            icon: const Icon(
              Icons.calendar_month_rounded,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<Object>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(
                message: 'جاري تحميل التقرير...',
              );
            }

            if (snapshot.hasError) {
              return AppErrorView(
                error: snapshot.error!,
                onRetry: _refresh,
              );
            }

            final data = snapshot.data;

            if (data == null) {
              return const AppEmptyView(
                icon: Icons.bar_chart_outlined,
                title: 'لا توجد بيانات',
                subtitle: 'لا توجد بيانات متاحة لهذا التقرير.',
              );
            }

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _buildReportSelector(),
                const SizedBox(height: 18),
                _buildReportContent(data),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildReportSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ReportChip(
                label: 'يومي',
                selected: _selectedType == ReportType.daily,
                onTap: () {
                  setState(() {
                    _selectedType = ReportType.daily;
                  });
                  _loadReport();
                },
              ),
              _ReportChip(
                label: 'أسبوعي',
                selected: _selectedType == ReportType.weekly,
                onTap: () {
                  setState(() {
                    _selectedType = ReportType.weekly;
                  });
                  _loadReport();
                },
              ),
              _ReportChip(
                label: 'شهري',
                selected: _selectedType == ReportType.monthly,
                onTap: () {
                  setState(() {
                    _selectedType = ReportType.monthly;
                  });
                  _loadReport();
                },
              ),
              _ReportChip(
                label: 'سنوي',
                selected: _selectedType == ReportType.yearly,
                onTap: () {
                  setState(() {
                    _selectedType = ReportType.yearly;
                  });
                  _loadReport();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportContent(Object data) {
    switch (_selectedType) {
      case ReportType.daily:
        return _DailyReportView(
          report: data as DailyReport,
          money: _money,
        );

      case ReportType.weekly:
        return _WeeklyReportView(
          report: data as WeeklyReport,
          money: _money,
        );

      case ReportType.monthly:
        return _MonthlyReportView(
          report: data as MonthlyReport,
          money: _money,
          monthName: _monthName,
        );

      case ReportType.yearly:
        return _YearlyReportView(
          report: data as YearlyReport,
          money: _money,
        );
    }
  }

  Future<void> _showPeriodPicker() async {
    DateTime tempDate = _selectedDate;
    int tempYear = _selectedYear;
    int tempMonth = _selectedMonth;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'اختيار الفترة',
                    style: AppTextStyles.headlineSmall,
                  ),
                  const SizedBox(height: 18),
                  if (_selectedType == ReportType.daily ||
                      _selectedType == ReportType.weekly)
                    OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: tempDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (picked == null) {
                          return;
                        }

                        setModalState(() {
                          tempDate = picked;
                        });
                      },
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                      ),
                      label: Text(
                        DateFormat(
                          'yyyy-MM-dd',
                        ).format(tempDate),
                      ),
                    ),
                  if (_selectedType == ReportType.monthly ||
                      _selectedType == ReportType.yearly) ...[
                    DropdownButtonFormField<int>(
                      value: tempYear,
                      decoration: const InputDecoration(
                        labelText: 'السنة',
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                        ),
                      ),
                      items: List.generate(
                        21,
                        (index) {
                          final year = DateTime.now().year - 10 + index;

                          return DropdownMenuItem<int>(
                            value: year,
                            child: Text('$year'),
                          );
                        },
                      ),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setModalState(() {
                          tempYear = value;
                        });
                      },
                    ),
                  ],
                  if (_selectedType == ReportType.monthly) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      value: tempMonth,
                      decoration: const InputDecoration(
                        labelText: 'الشهر',
                        prefixIcon: Icon(
                          Icons.date_range_outlined,
                        ),
                      ),
                      items: List.generate(
                        12,
                        (index) {
                          final month = index + 1;

                          return DropdownMenuItem<int>(
                            value: month,
                            child: Text(
                              _monthName(month),
                            ),
                          );
                        },
                      ),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setModalState(() {
                          tempMonth = value;
                        });
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = tempDate;
                          _selectedYear = tempYear;
                          _selectedMonth = tempMonth;
                        });

                        _loadReport();

                        Navigator.pop(context);
                      },
                      child: const Text(
                        'تطبيق',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ReportChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ReportChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.12),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 4),
            FittedBox(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: AppTextStyles.amountSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyReportView extends StatelessWidget {
  final DailyReport report;
  final String Function(double) money;

  const _DailyReportView({
    required this.report,
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: 'الدخل',
                value: money(report.totalIncome),
                icon: Icons.arrow_upward_rounded,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricCard(
                title: 'المصاريف',
                value: money(report.totalExpenses),
                icon: Icons.arrow_downward_rounded,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _MetricCard(
          title: 'عدد العمليات',
          value: report.transactionCount.toString(),
          icon: Icons.receipt_long_rounded,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        _BreakdownCard(
          items: report.categoryBreakdown,
          money: money,
        ),
        if (report.highestExpense != null) ...[
          const SizedBox(height: 16),
          _HighlightCard(
            title: 'أعلى مصروف',
            icon: Icons.trending_down_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.highestExpense!.categoryName,
                  style: AppTextStyles.labelLarge,
                ),
                const SizedBox(height: 5),
                Text(
                  money(
                    report.highestExpense!.amount,
                  ),
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (report.highestExpense!.description != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    report.highestExpense!.description!,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _WeeklyReportView extends StatelessWidget {
  final WeeklyReport report;
  final String Function(double) money;

  const _WeeklyReportView({
    required this.report,
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    final change = report.percentChangeFromPreviousWeek;

    return Column(
      children: [
        _MetricCard(
          title: 'إجمالي المصاريف',
          value: money(report.totalExpenses),
          icon: Icons.receipt_long_rounded,
          color: AppColors.error,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: 'المتوسط اليومي',
                value: money(report.averageDailySpending),
                icon: Icons.speed_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricCard(
                title: 'الأسبوع السابق',
                value: money(report.previousWeekTotal),
                icon: Icons.history_rounded,
                color: AppColors.info,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _HighlightCard(
          title: 'أعلى يوم إنفاق',
          icon: Icons.calendar_month_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('yyyy-MM-dd').format(
                  report.highestSpendingDay.date,
                ),
                style: AppTextStyles.labelLarge,
              ),
              const SizedBox(height: 6),
              Text(
                money(
                  report.highestSpendingDay.amount,
                ),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _HighlightCard(
          title: 'أكثر فئة إنفاقًا',
          icon: Icons.category_outlined,
          child: Text(
            report.mostExpensiveCategory ?? 'غير محدد',
            style: AppTextStyles.labelLarge,
          ),
        ),
        const SizedBox(height: 12),
        _ChangeCard(
          title: 'التغير عن الأسبوع السابق',
          percentage: change,
        ),
      ],
    );
  }
}

class _MonthlyReportView extends StatelessWidget {
  final MonthlyReport report;
  final String Function(double) money;
  final String Function(int) monthName;

  const _MonthlyReportView({
    required this.report,
    required this.money,
    required this.monthName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${monthName(report.month)} ${report.year}',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: 'الدخل',
                value: money(report.totalIncome),
                icon: Icons.arrow_upward_rounded,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricCard(
                title: 'المصاريف',
                value: money(report.totalExpenses),
                icon: Icons.arrow_downward_rounded,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _MetricCard(
          title: 'الرصيد المتبقي',
          value: money(report.remainingBalance),
          icon: Icons.account_balance_wallet_outlined,
          color: AppColors.primary,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: 'المتوسط اليومي',
                value: money(report.averageDailySpending),
                icon: Icons.speed_rounded,
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricCard(
                title: 'الشهر السابق',
                value: money(
                  report.previousMonthTotalExpenses,
                ),
                icon: Icons.history_rounded,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _ChangeCard(
          title: 'التغير عن الشهر السابق',
          percentage: report.percentChangeFromPreviousMonth,
        ),
        const SizedBox(height: 16),
        if (report.overallBudgetUsagePercent != null)
          _BudgetUsageCard(
            percentage: report.overallBudgetUsagePercent!,
          ),
        const SizedBox(height: 16),
        _BreakdownCard(
          items: report.categoryBreakdown,
          money: money,
        ),
      ],
    );
  }
}

class _YearlyReportView extends StatelessWidget {
  final YearlyReport report;
  final String Function(double) money;

  const _YearlyReportView({
    required this.report,
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${report.year}',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: 'إجمالي الدخل',
                value: money(report.totalIncome),
                icon: Icons.arrow_upward_rounded,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricCard(
                title: 'إجمالي المصاريف',
                value: money(report.totalExpenses),
                icon: Icons.arrow_downward_rounded,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التفصيل الشهري',
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 14),
                ...report.monthlyBreakdown.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 14,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              item.month.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.monthName,
                                style: AppTextStyles.labelLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'الدخل: ${money(item.totalIncome)}',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          money(item.totalExpenses),
                          style: const TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final List<CategoryBreakdownItem> items;
  final String Function(double) money;

  const _BreakdownCard({
    required this.items,
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const AppEmptyView(
        icon: Icons.pie_chart_outline_rounded,
        title: 'لا يوجد توزيع للفئات',
      );
    }

    final sorted = [...items]..sort(
        (a, b) => b.totalAmount.compareTo(
          a.totalAmount,
        ),
      );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'توزيع المصاريف',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...sorted.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.categoryName,
                            style: AppTextStyles.labelLarge,
                          ),
                        ),
                        Text(
                          money(item.totalAmount),
                          style: AppTextStyles.labelLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: (item.percentage / 100).clamp(0.0, 1.0),
                        backgroundColor: AppColors.disabledBackground,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${item.percentage.toStringAsFixed(1)}%',
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _HighlightCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: Icon(
                icon,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangeCard extends StatelessWidget {
  final String title;
  final double percentage;

  const _ChangeCard({
    required this.title,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = percentage > 0;
    final isDown = percentage < 0;

    final icon = isUp
        ? Icons.trending_up_rounded
        : isDown
            ? Icons.trending_down_rounded
            : Icons.remove_rounded;

    final text = '${percentage.abs().toStringAsFixed(1)}%';

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 6,
        ),
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryLight,
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(title),
        trailing: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class _BudgetUsageCard extends StatelessWidget {
  final double percentage;

  const _BudgetUsageCard({
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = (percentage / 100).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'استخدام الميزانية',
                    style: AppTextStyles.labelLarge,
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: AppTextStyles.labelLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: normalized,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
