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
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
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
    final reportFuture = ref.read(reportRepositoryProvider).getMonthlyReport(
          year: year,
          month: month,
        );

    final notificationsFuture =
        ref.read(notificationRepositoryProvider).getUnreadNotificationsCount();

    final results = await Future.wait([
      reportFuture,
      notificationsFuture,
    ]);

    return _DashboardData(
      report: results[0] as MonthlyReport,
      unreadCount: results[1] as int,
    );
  }

  Future<void> _refresh() async {
    setState(_load);

    try {
      await _future;
    } catch (_) {
      // FutureBuilder handles the error.
    }
  }

  String _money(double value) {
    return NumberFormat.currency(
      locale: 'ar',
      symbol: '₪',
      decimalDigits: 2,
    ).format(value);
  }

  String _monthTitle(DateTime date) {
    return DateFormat(
      'MMMM yyyy',
      'ar',
    ).format(date);
  }

  Future<void> _openNotifications() async {
    await context.push('/notifications');

    if (!mounted) return;

    _load();
    setState(() {});
  }

  Future<void> _openProfile() async {
    await context.push('/profile');

    if (!mounted) return;

    _load();
    setState(() {});
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
            onPressed: _openNotifications,
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
          IconButton(
            tooltip: 'الملف الشخصي',
            onPressed: _openProfile,
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
            if (snapshot.connectionState == ConnectionState.waiting) {
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
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                30,
              ),
              children: [
                Text(
                  'ملخصك المالي',
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  _monthTitle(now),
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                _BalanceCard(
                  balance: data.report.remainingBalance,
                  formatMoney: _money,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: 'إجمالي الدخل',
                        value: _money(
                          data.report.totalIncome,
                        ),
                        icon: Icons.arrow_upward_rounded,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SummaryCard(
                        title: 'إجمالي المصاريف',
                        value: _money(
                          data.report.totalExpenses,
                        ),
                        icon: Icons.arrow_downward_rounded,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'الوصول السريع',
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.65,
                  children: [
                    _QuickAction(
                      icon: Icons.remove_circle_outline_rounded,
                      title: 'إضافة مصروف',
                      subtitle: 'سجّل مصروفًا جديدًا',
                      color: AppColors.error,
                      onTap: () async {
                        await context.push(
                          '/expenses/add',
                        );

                        if (!mounted) return;

                        _load();
                        setState(() {});
                      },
                    ),
                    _QuickAction(
                      icon: Icons.add_circle_outline_rounded,
                      title: 'إضافة دخل',
                      subtitle: 'أضف مصدر دخل جديد',
                      color: AppColors.success,
                      onTap: () async {
                        await context.push(
                          '/income/add',
                        );

                        if (!mounted) return;

                        _load();
                        setState(() {});
                      },
                    ),
                    _QuickAction(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'الميزانيات',
                      subtitle: 'تابع ميزانياتك',
                      color: AppColors.primary,
                      onTap: () {
                        context.push('/budgets');
                      },
                    ),
                    _QuickAction(
                      icon: Icons.bar_chart_rounded,
                      title: 'التقارير',
                      subtitle: 'حلل وضعك المالي',
                      color: AppColors.info,
                      onTap: () {
                        context.push('/reports');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'الإشعارات',
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 12),
                _NotificationCard(
                  unreadCount: data.unreadCount,
                  onTap: _openNotifications,
                ),
                const SizedBox(height: 24),
                Text(
                  'نظرة أعمق',
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 12),
                _MonthlyInsightsCard(
                  report: data.report,
                  money: _money,
                ),
                const SizedBox(height: 24),
                _DashboardLinks(
                  onExpenses: () {
                    context.push('/expenses');
                  },
                  onIncome: () {
                    context.push('/income');
                  },
                  onBudgets: () {
                    context.push('/budgets');
                  },
                  onReports: () {
                    context.push('/reports');
                  },
                  onProfile: _openProfile,
                  onNotifications: _openNotifications,
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
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home_rounded,
            ),
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
            icon: Icon(
              Icons.wallet_outlined,
            ),
            selectedIcon: Icon(
              Icons.wallet_rounded,
            ),
            label: 'الميزانية',
          ),
        ],
      ),
    );
  }
}

// =========================================================
// DASHBOARD DATA
// =========================================================

class _DashboardData {
  final MonthlyReport report;
  final int unreadCount;

  const _DashboardData({
    required this.report,
    required this.unreadCount,
  });
}

// =========================================================
// BALANCE CARD
// =========================================================

class _BalanceCard extends StatelessWidget {
  final double balance;
  final String Function(double) formatMoney;

  const _BalanceCard({
    required this.balance,
    required this.formatMoney,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = balance >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  isPositive ? 'وضع جيد' : 'تنبيه',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'الرصيد المتبقي',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
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
            children: [
              Icon(
                isPositive
                    ? Icons.check_circle_outline_rounded
                    : Icons.warning_amber_rounded,
                color: Colors.white70,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                isPositive
                    ? 'رصيدك الحالي ضمن الوضع الإيجابي'
                    : 'مصروفاتك تجاوزت دخلك هذا الشهر',
                style: const TextStyle(
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

// =========================================================
// SUMMARY CARD
// =========================================================

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
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 21,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(
                icon,
                color: color,
                size: 21,
              ),
            ),
            const SizedBox(height: 11),
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

// =========================================================
// QUICK ACTION
// =========================================================

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// NOTIFICATION CARD
// =========================================================

class _NotificationCard extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = unreadCount > 0;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryLight,
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الإشعارات',
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasUnread
                          ? '$unreadCount إشعار غير مقروء'
                          : 'لا توجد إشعارات غير مقروءة',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (hasUnread)
                Container(
                  constraints: const BoxConstraints(
                    minWidth: 30,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    unreadCount.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// MONTHLY INSIGHTS
// =========================================================

class _MonthlyInsightsCard extends StatelessWidget {
  final MonthlyReport report;
  final String Function(double) money;

  const _MonthlyInsightsCard({
    required this.report,
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    final budgetUsage = report.overallBudgetUsagePercent;

    final change = report.percentChangeFromPreviousMonth;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.infoLight,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.insights_rounded,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'نظرة سريعة على الشهر',
                    style: AppTextStyles.labelLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _InsightRow(
              title: 'متوسط الإنفاق اليومي',
              value: money(
                report.averageDailySpending,
              ),
            ),
            const SizedBox(height: 11),
            _InsightRow(
              title: 'مصروفات الشهر السابق',
              value: money(
                report.previousMonthTotalExpenses,
              ),
            ),
            const SizedBox(height: 11),
            _InsightRow(
              title: 'التغير عن الشهر السابق',
              value: '${change.abs().toStringAsFixed(1)}%',
              valueColor: change > 0
                  ? AppColors.error
                  : change < 0
                      ? AppColors.success
                      : AppColors.textPrimary,
            ),
            if (budgetUsage != null) ...[
              const SizedBox(height: 18),
              const Divider(),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'استخدام الميزانية',
                      style: AppTextStyles.labelLarge,
                    ),
                  ),
                  Text(
                    '${budgetUsage.toStringAsFixed(1)}%',
                    style: AppTextStyles.labelLarge,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  minHeight: 9,
                  value: (budgetUsage / 100).clamp(0.0, 1.0),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// =========================================================
// INSIGHT ROW
// =========================================================

class _InsightRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const _InsightRow({
    required this.title,
    required this.value,
    this.valueColor,
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
          style: AppTextStyles.labelLarge.copyWith(
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

// =========================================================
// DASHBOARD LINKS
// =========================================================

class _DashboardLinks extends StatelessWidget {
  final VoidCallback onExpenses;
  final VoidCallback onIncome;
  final VoidCallback onBudgets;
  final VoidCallback onReports;
  final VoidCallback onProfile;
  final VoidCallback onNotifications;

  const _DashboardLinks({
    required this.onExpenses,
    required this.onIncome,
    required this.onBudgets,
    required this.onReports,
    required this.onProfile,
    required this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _LinkTile(
            icon: Icons.receipt_long_outlined,
            title: 'كل المصاريف',
            onTap: onExpenses,
          ),
          const Divider(height: 1),
          _LinkTile(
            icon: Icons.account_balance_wallet_outlined,
            title: 'كل مصادر الدخل',
            onTap: onIncome,
          ),
          const Divider(height: 1),
          _LinkTile(
            icon: Icons.wallet_outlined,
            title: 'إدارة الميزانيات',
            onTap: onBudgets,
          ),
          const Divider(height: 1),
          _LinkTile(
            icon: Icons.analytics_outlined,
            title: 'التقارير المالية',
            onTap: onReports,
          ),
          const Divider(height: 1),
          _LinkTile(
            icon: Icons.notifications_outlined,
            title: 'مركز الإشعارات',
            onTap: onNotifications,
          ),
          const Divider(height: 1),
          _LinkTile(
            icon: Icons.person_outline_rounded,
            title: 'الملف الشخصي',
            onTap: onProfile,
          ),
        ],
      ),
    );
  }
}

// =========================================================
// LINK TILE
// =========================================================

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _LinkTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryLight,
        child: Icon(
          icon,
          color: AppColors.primary,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.labelLarge,
      ),
      trailing: const Icon(
        Icons.chevron_left_rounded,
        color: AppColors.textSecondary,
      ),
    );
  }
}
