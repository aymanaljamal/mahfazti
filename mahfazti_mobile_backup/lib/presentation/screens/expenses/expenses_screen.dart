import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/expense.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_empty_view.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/app_loading.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  late Future<List<Expense>> _future;

  DateTime? _startDate;
  DateTime? _endDate;
  int? _categoryId;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _loadExpenses() {
    _future = ref.read(expenseRepositoryProvider).getExpenses(
          startDate: _startDate,
          endDate: _endDate,
          categoryId: _categoryId,
        );
  }

  Future<void> _refresh() async {
    setState(_loadExpenses);

    try {
      await _future;
    } catch (_) {}
  }

  String _money(double amount) {
    return NumberFormat.currency(
      locale: 'ar',
      symbol: '₪',
      decimalDigits: 2,
    ).format(amount);
  }

  Future<void> _pickDate({
    required bool isStart,
  }) async {
    final initialDate =
        isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });

    _loadExpenses();
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _categoryId = null;
    });

    _loadExpenses();
  }

  Future<void> _deleteExpense(Expense expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف المصروف'),
          content: Text(
            'هل أنت متأكد من حذف مصروف ${_money(expense.amount)}؟',
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
      await ref.read(expenseRepositoryProvider).deleteExpense(
            expense.id,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حذف المصروف بنجاح.'),
        ),
      );

      _refresh();
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
        title: const Text('المصاريف'),
        actions: [
          IconButton(
            tooltip: 'تصفية',
            onPressed: _showFilters,
            icon: const Icon(Icons.filter_list_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/expenses/add');
          _loadExpenses();
          setState(() {});
        },
        icon: const Icon(Icons.add),
        label: const Text('إضافة مصروف'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Expense>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(
                message: 'جاري تحميل المصاريف...',
              );
            }

            if (snapshot.hasError) {
              return AppErrorView(
                error: snapshot.error!,
                onRetry: _refresh,
              );
            }

            final expenses = snapshot.data ?? [];

            if (expenses.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 140),
                  AppEmptyView(
                    icon: Icons.receipt_long_outlined,
                    title: 'لا توجد مصاريف',
                    subtitle: 'ابدأ بإضافة أول مصروف لك.',
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
              itemCount: expenses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final expense = expenses[index];

                return _ExpenseCard(
                  expense: expense,
                  money: _money,
                  onEdit: () async {
                    await context.push(
                      '/expenses/edit/${expense.id}',
                    );
                    _loadExpenses();
                    setState(() {});
                  },
                  onDelete: () => _deleteExpense(expense),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _showFilters() async {
    final categories =
        await ref.read(categoryRepositoryProvider).getCategories();

    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'تصفية المصاريف',
                    style: AppTextStyles.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await _pickFilterDate(
                        isStart: true,
                        setModalState: setModalState,
                      );
                    },
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                    ),
                    label: Text(
                      _startDate == null
                          ? 'من تاريخ'
                          : DateFormat('yyyy-MM-dd').format(_startDate!),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await _pickFilterDate(
                        isStart: false,
                        setModalState: setModalState,
                      );
                    },
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                    ),
                    label: Text(
                      _endDate == null
                          ? 'إلى تاريخ'
                          : DateFormat('yyyy-MM-dd').format(_endDate!),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int?>(
                    value: _categoryId,
                    decoration: const InputDecoration(
                      labelText: 'الفئة',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('كل الفئات'),
                      ),
                      ...categories.map(
                        (category) => DropdownMenuItem<int?>(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setModalState(() {
                        _categoryId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _clearFilters();
                            Navigator.pop(context);
                          },
                          child: const Text('مسح'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(_loadExpenses);
                            Navigator.pop(context);
                          },
                          child: const Text('تطبيق'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _pickFilterDate({
    required bool isStart,
    required StateSetter setModalState,
  }) async {
    final initialDate =
        isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setModalState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }
}

class _ExpenseCard extends StatelessWidget {
  final Expense expense;
  final String Function(double) money;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExpenseCard({
    required this.expense,
    required this.money,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                color: AppColors.error,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.categoryName,
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expense.description?.isNotEmpty == true
                        ? expense.description!
                        : 'بدون وصف',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${DateFormat('yyyy-MM-dd').format(expense.date)} • ${DateFormat('HH:mm').format(expense.time)}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '- ${money(expense.amount)}',
                  style: const TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
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
          ],
        ),
      ),
    );
  }
}
