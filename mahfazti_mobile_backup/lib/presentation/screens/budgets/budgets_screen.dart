import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/budget.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_empty_view.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/app_loading.dart';

class BudgetsScreen extends ConsumerStatefulWidget {
  const BudgetsScreen({super.key});

  @override
  ConsumerState<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends ConsumerState<BudgetsScreen> {
  late Future<List<Budget>> _future;

  int? _selectedYear;
  int? _selectedMonth;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _selectedYear = now.year;
    _selectedMonth = now.month;

    _loadBudgets();
  }

  void _loadBudgets() {
    _future = ref.read(budgetRepositoryProvider).getBudgets(
          year: _selectedYear,
          month: _selectedMonth,
        );
  }

  Future<void> _refresh() async {
    setState(_loadBudgets);

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

  Future<void> _deleteBudget(Budget budget) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف الميزانية'),
          content: Text(
            'هل أنت متأكد من حذف ميزانية ${budget.categoryName}؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await ref.read(budgetRepositoryProvider).deleteBudget(budget.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حذف الميزانية بنجاح.'),
        ),
      );

      await _refresh();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الميزانيات'),
        actions: [
          IconButton(
            tooltip: 'الفترة',
            onPressed: _showPeriodPicker,
            icon: const Icon(
              Icons.calendar_month_rounded,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/budgets/add');

          if (!mounted) return;

          _loadBudgets();
          setState(() {});
        },
        icon: const Icon(Icons.add),
        label: const Text('إضافة ميزانية'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Budget>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(
                message: 'جاري تحميل الميزانيات...',
              );
            }

            if (snapshot.hasError) {
              return AppErrorView(
                error: snapshot.error!,
                onRetry: _refresh,
              );
            }

            final budgets = snapshot.data ?? [];

            if (budgets.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 120),
                  AppEmptyView(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'لا توجد ميزانيات',
                    subtitle: 'لا توجد ميزانية للفترة المحددة.',
                  ),
                ],
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                110,
              ),
              itemCount: budgets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final budget = budgets[index];

                return _BudgetCard(
                  budget: budget,
                  money: _money,
                  onEdit: () async {
                    await context.push(
                      '/budgets/edit/${budget.id}',
                    );

                    if (!mounted) return;

                    _loadBudgets();
                    setState(() {});
                  },
                  onDelete: () => _deleteBudget(budget),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _showPeriodPicker() async {
    int selectedYear = _selectedYear ?? DateTime.now().year;
    int selectedMonth = _selectedMonth ?? DateTime.now().month;

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
                  const SizedBox(height: 20),
                  DropdownButtonFormField<int>(
                    value: selectedYear,
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
                      if (value == null) return;

                      setModalState(() {
                        selectedYear = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: selectedMonth,
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
                            DateFormat(
                              'MMMM',
                              'ar',
                            ).format(
                              DateTime(
                                2026,
                                month,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    onChanged: (value) {
                      if (value == null) return;

                      setModalState(() {
                        selectedMonth = value;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedYear = selectedYear;
                          _selectedMonth = selectedMonth;
                        });

                        _loadBudgets();

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

class _BudgetCard extends StatelessWidget {
  final Budget budget;
  final String Function(double) money;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BudgetCard({
    required this.budget,
    required this.money,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    budget.categoryName,
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${budget.month}/${budget.year}',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    money(budget.amount),
                    style: AppTextStyles.amountSmall,
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else {
                  onDelete();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Text('تعديل'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('حذف'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
