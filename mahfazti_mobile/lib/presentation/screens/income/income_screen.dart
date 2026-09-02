import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/income.dart';
import '../../../domain/enums/income_source.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_empty_view.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/app_loading.dart';

class IncomeScreen extends ConsumerStatefulWidget {
  const IncomeScreen({super.key});

  @override
  ConsumerState<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends ConsumerState<IncomeScreen> {
  late Future<List<Income>> _incomeFuture;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadIncome();
  }

  void _loadIncome() {
    _incomeFuture = ref.read(incomeRepositoryProvider).getIncomes(
          startDate: _startDate,
          endDate: _endDate,
        );
  }

  Future<void> _refresh() async {
    setState(() {
      _loadIncome();
    });

    try {
      await _incomeFuture;
    } catch (_) {
      // FutureBuilder handles the error state.
    }
  }

  String _formatMoney(double amount) {
    return NumberFormat.currency(
      locale: 'ar',
      symbol: '₪',
      decimalDigits: 2,
    ).format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _sourceLabel(IncomeSource source) {
    switch (source) {
      case IncomeSource.salary:
        return 'راتب';

      case IncomeSource.freelance:
        return 'عمل حر';

      case IncomeSource.allowance:
        return 'مصروف';

      case IncomeSource.gift:
        return 'هدية';

      case IncomeSource.other:
        return 'أخرى';
    }
  }

  IconData _sourceIcon(IncomeSource source) {
    switch (source) {
      case IncomeSource.salary:
        return Icons.account_balance_wallet_outlined;

      case IncomeSource.freelance:
        return Icons.work_outline_rounded;

      case IncomeSource.allowance:
        return Icons.payments_outlined;

      case IncomeSource.gift:
        return Icons.card_giftcard_rounded;

      case IncomeSource.other:
        return Icons.attach_money_rounded;
    }
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _startDate = picked;

      if (_endDate != null && _endDate!.isBefore(picked)) {
        _endDate = picked;
      }

      _loadIncome();
    });
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _endDate = picked;
      _loadIncome();
    });
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _loadIncome();
    });
  }

  Future<void> _showFilters() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                28,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'تصفية الدخل',
                    style: AppTextStyles.headlineSmall,
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.of(sheetContext).pop();
                      await _pickStartDate();
                    },
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                    ),
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('من تاريخ'),
                        Text(
                          _startDate == null
                              ? 'اختيار'
                              : _formatDate(_startDate!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.of(sheetContext).pop();
                      await _pickEndDate();
                    },
                    icon: const Icon(
                      Icons.event_outlined,
                    ),
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('إلى تاريخ'),
                        Text(
                          _endDate == null ? 'اختيار' : _formatDate(_endDate!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      _clearFilters();
                      setSheetState(() {});
                      Navigator.of(sheetContext).pop();
                    },
                    icon: const Icon(
                      Icons.clear_all_rounded,
                    ),
                    label: const Text('مسح الفلاتر'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteIncome(Income income) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('حذف الدخل'),
          content: Text(
            'هل أنت متأكد من حذف سجل الدخل بقيمة '
            '${_formatMoney(income.amount)}؟',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await ref.read(incomeRepositoryProvider).deleteIncome(income.id);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حذف الدخل بنجاح.'),
        ),
      );

      await _refresh();
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  Future<void> _openAddIncome() async {
    await context.push('/income/add');

    if (!mounted) {
      return;
    }

    setState(() {
      _loadIncome();
    });
  }

  Future<void> _openEditIncome(Income income) async {
    await context.push('/income/edit/${income.id}');

    if (!mounted) {
      return;
    }

    setState(() {
      _loadIncome();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasFilters = _startDate != null || _endDate != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الدخل'),
        actions: [
          IconButton(
            onPressed: _showFilters,
            tooltip: 'تصفية',
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.filter_list_rounded,
                ),
                if (hasFilters)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddIncome,
        icon: const Icon(Icons.add_rounded),
        label: const Text('إضافة دخل'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Income>>(
          future: _incomeFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(
                message: 'جاري تحميل الدخل...',
              );
            }

            if (snapshot.hasError) {
              return AppErrorView(
                error: snapshot.error!,
                onRetry: _refresh,
              );
            }

            final incomes = snapshot.data ?? <Income>[];

            if (incomes.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  top: 120,
                ),
                children: [
                  AppEmptyView(
                    icon: Icons.account_balance_wallet_outlined,
                    title: hasFilters ? 'لا توجد نتائج' : 'لا توجد سجلات دخل',
                    subtitle: hasFilters
                        ? 'جرّب تغيير الفترة الزمنية أو مسح الفلاتر.'
                        : 'ابدأ بإضافة أول مصدر دخل لك.',
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
              itemCount: incomes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final income = incomes[index];

                return _IncomeCard(
                  income: income,
                  money: _formatMoney,
                  date: _formatDate,
                  sourceLabel: _sourceLabel,
                  sourceIcon: _sourceIcon,
                  onEdit: () => _openEditIncome(income),
                  onDelete: () => _deleteIncome(income),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _IncomeCard extends StatelessWidget {
  final Income income;
  final String Function(double) money;
  final String Function(DateTime) date;
  final String Function(IncomeSource) sourceLabel;
  final IconData Function(IncomeSource) sourceIcon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _IncomeCard({
    required this.income,
    required this.money,
    required this.date,
    required this.sourceLabel,
    required this.sourceIcon,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                sourceIcon(income.source),
                color: AppColors.success,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sourceLabel(income.source),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    income.description?.trim().isNotEmpty == true
                        ? income.description!.trim()
                        : 'بدون وصف',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    date(income.date),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '+ ${money(income.amount)}',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: 'المزيد',
                  padding: EdgeInsets.zero,
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) {
                    return const [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                            ),
                            SizedBox(width: 10),
                            Text('تعديل'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                            ),
                            SizedBox(width: 10),
                            Text('حذف'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
