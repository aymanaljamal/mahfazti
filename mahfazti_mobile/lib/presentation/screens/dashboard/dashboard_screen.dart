import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/monthly_report.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/app_loading.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends ConsumerState<DashboardScreen> {
  late Future<_DashboardData> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final now = DateTime.now();

    _future = _loadDashboardData(
      year: now.year,
      month: now.month,
    );
  }

  Future<_DashboardData> _loadDashboardData({
    required int year,
    required int month,
  }) async {
    final monthlyReport = await ref
        .read(reportRepositoryProvider)
        .getMonthlyReport(
          year: year,
          month: month,
        );

    final unreadCount = await ref
        .read(notificationRepositoryProvider)
        .getUnreadNotificationsCount();

    return _DashboardData(
      report: monthlyReport,
      unreadCount: unreadCount,
    );
  }

  Future<void> _refresh() async {
    setState(_load);

    try {
      await _future;
    } catch (_) {
      // FutureBuilder will display the error state.
    }
  }

  String _money(double value) {
    return NumberFormat.currency(
      locale: 'ar',
      symbol: '₪',
      decimalDigits: 2,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('محفظتي'),
        actions: [
          IconButton(
            tooltip: 'الإشعارات',
            onPressed: () {
              context.push('/notifications');
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
          IconButton(
            tooltip: 'الملف الشخصي',
            onPressed: () {
              context.push('/profile');
            },
            icon: const Icon(
              Icons.person_outline_rounded,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<_DashboardData>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const AppLoading(
                message: 'جاري تحميل بياناتك...',
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
              return AppErrorView(
                error: Exception(
                  'تعذر تحميل بيانات لوحة التحكم.',
                ),
                onRetry: _refresh,
              );
            }

            return ListView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(18),
              children: [
                Text(
                  DateFormat(
                    'MMMM yyyy',
                    'ar',
                  ).format(now),
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 16),

                _BalanceCard(
                  balance: data.report.remainingBalance,
                  formatMoney: _money,
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: 'الدخل',
                        value: _money(
                          data.report.totalIncome,
                        ),
                        icon:
                            Icons.trending_up_rounded,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        title: 'المصاريف',
                        value: _money(
                          data.report.totalExpenses,
                        ),
                        icon:
                            Icons.trending_down_rounded,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  'إجراءات سريعة',
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _QuickAction(
                        icon: Icons
                            .remove_circle_outline_rounded,
                        title: 'إضافة مصروف',
                        onTap: () {
                          context.push('/expenses/add');
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons
                            .add_circle_outline_rounded,
                        title: 'إضافة دخل',
                        onTap: () {
                          context.push('/income/add');
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _QuickAction(
                        icon: Icons
                            .account_balance_wallet_outlined,
                        title: 'الميزانيات',
                        onTap: () {
                          context.push('/budgets');
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.bar_chart_rounded,
                        title: 'التقارير',
                        onTap: () {
                          context.push('/reports');
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  'الإشعارات',
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 12),

                Card(
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(16),
                    onTap: () {
                      context.push('/notifications');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                AppColors.primaryLight,
                            child: const Icon(
                              Icons
                                  .notifications_none_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'إشعاراتك',
                                  style: AppTextStyles
                                      .labelLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data.unreadCount == 0
                                      ? 'لا توجد إشعارات غير مقروءة'
                                      : '${data.unreadCount} إشعار غير مقروء',
                                  style: AppTextStyles
                                      .bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          if (data.unreadCount > 0)
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary,
                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                              ),
                              child: Text(
                                '${data.unreadCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                            )
                          else
                            const Icon(
                              Icons.chevron_left_rounded,
                              color:
                                  AppColors.textSecondary,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                _ReportInsightCard(
                  report: data.report,
                  formatMoney: _money,
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/expenses');
              break;
            case 2:
              context.go('/income');
              break;
            case 3:
              context.go('/budgets');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.arrow_downward_rounded,
            ),
            selectedIcon: Icon(
              Icons.arrow_downward_rounded,
            ),
            label: 'المصاريف',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.arrow_upward_rounded,
            ),
            selectedIcon: Icon(
              Icons.arrow_upward_rounded,
            ),
            label: 'الدخل',
          ),
          NavigationDestination(
            icon: Icon(Icons.wallet_outlined),
            selectedIcon: Icon(Icons.wallet_rounded),
            label: 'الميزانية',
          ),
        ],
      ),
    );
  }
}

class _DashboardData {
  final MonthlyReport report;
  final int unreadCount;

  const _DashboardData({
    required this.report,
    required this.unreadCount,
  });
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  final String Function(double) formatMoney;

  const _BalanceCard({
    required this.balance,
    required this.formatMoney,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'الرصيد المتبقي',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          FittedBox(
            alignment: Alignment.centerRight,
            child: Text(
              formatMoney(balance),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white70,
                size: 18,
              ),
              SizedBox(width: 6),
              Text(
                'ملخص وضعك المالي هذا الشهر',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
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
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 21,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 5),
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

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportInsightCard extends StatelessWidget {
  final MonthlyReport report;
  final String Function(double) formatMoney;

  const _ReportInsightCard({
    required this.report,
    required this.formatMoney,
  });

  @override
  Widget build(BuildContext context) {
    final percentage =
        report.overallBudgetUsagePercent;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.infoLight,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.insights_rounded,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'نظرة سريعة',
                    style: AppTextStyles.labelLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _InsightRow(
              title: 'متوسط الإنفاق اليومي',
              value: formatMoney(
                report.averageDailySpending,
              ),
            ),
            const SizedBox(height: 10),
            _InsightRow(
              title: 'مصروفات الشهر السابق',
              value: formatMoney(
                report.previousMonthTotalExpenses,
              ),
            ),
            if (percentage != null) ...[
              const SizedBox(height: 10),
              _InsightRow(
                title: 'استخدام الميزانية',
                value:
                    '${percentage.toStringAsFixed(1)}%',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final String title;
  final String value;

  const _InsightRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: AppTextStyles.labelLarge,
        ),
      ],
    );
  }
}