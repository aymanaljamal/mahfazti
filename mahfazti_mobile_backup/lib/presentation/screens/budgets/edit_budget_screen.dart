import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/validators.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/app_loading.dart';

class EditBudgetScreen extends ConsumerStatefulWidget {
  final int budgetId;

  const EditBudgetScreen({
    super.key,
    required this.budgetId,
  });

  @override
  ConsumerState<EditBudgetScreen> createState() => _EditBudgetScreenState();
}

class _EditBudgetScreenState extends ConsumerState<EditBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  int? _selectedCategoryId;
  int? _selectedYear;
  int? _selectedMonth;

  bool _loading = true;
  bool _saving = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadBudget() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final budget = await ref
          .read(budgetRepositoryProvider)
          .getBudgetById(widget.budgetId);

      if (!mounted) return;

      setState(() {
        _amountController.text = budget.amount.toStringAsFixed(2);

        _selectedCategoryId = budget.categoryId;
        _selectedYear = budget.year;
        _selectedMonth = budget.month;

        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.toString();
        _loading = false;
      });
    }
  }

  Future<void> _updateBudget() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryId == null ||
        _selectedYear == null ||
        _selectedMonth == null) {
      _showMessage('يرجى إكمال بيانات الميزانية.');
      return;
    }

    final amount = double.tryParse(
      _amountController.text.trim(),
    );

    if (amount == null || amount <= 0) {
      _showMessage('أدخل مبلغًا صحيحًا.');
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await ref.read(budgetRepositoryProvider).updateBudget(
            id: widget.budgetId,
            amount: amount,
            categoryId: _selectedCategoryId!,
            year: _selectedYear!,
            month: _selectedMonth!,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم تعديل الميزانية بنجاح.',
          ),
        ),
      );

      context.pop();
    } catch (error) {
      if (!mounted) return;

      _showMessage(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: AppLoading(
          message: 'جاري تحميل بيانات الميزانية...',
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('تعديل الميزانية'),
        ),
        body: AppErrorView(
          error: Exception(_errorMessage),
          onRetry: _loadBudget,
        ),
      );
    }

    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الميزانية'),
      ),
      body: categoriesAsync.when(
        loading: () => const AppLoading(
          message: 'جاري تحميل الفئات...',
        ),
        error: (error, _) => AppErrorView(
          error: error,
          onRetry: () {
            ref.invalidate(categoryListProvider);
          },
        ),
        data: (categories) {
          return SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'تعديل تفاصيل الميزانية',
                      style: AppTextStyles.headlineSmall,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: Validators.amount,
                      decoration: const InputDecoration(
                        labelText: 'المبلغ',
                        suffixText: '₪',
                        prefixIcon: Icon(
                          Icons.payments_outlined,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<int>(
                      value: _selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: 'الفئة',
                        prefixIcon: Icon(
                          Icons.category_outlined,
                        ),
                      ),
                      items: categories
                          .map(
                            (category) => DropdownMenuItem<int>(
                              value: category.id,
                              child: Text(
                                category.name,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: _saving
                          ? null
                          : (value) {
                              setState(() {
                                _selectedCategoryId = value;
                              });
                            },
                      validator: (value) {
                        if (value == null) {
                          return 'الفئة مطلوبة.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<int>(
                      value: _selectedYear,
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
                      onChanged: _saving
                          ? null
                          : (value) {
                              setState(() {
                                _selectedYear = value;
                              });
                            },
                      validator: (value) {
                        if (value == null) {
                          return 'السنة مطلوبة.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<int>(
                      value: _selectedMonth,
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
                            child: Text('$month'),
                          );
                        },
                      ),
                      onChanged: _saving
                          ? null
                          : (value) {
                              setState(() {
                                _selectedMonth = value;
                              });
                            },
                      validator: (value) {
                        if (value == null) {
                          return 'الشهر مطلوب.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _saving ? null : _updateBudget,
                        icon: _saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Icon(
                                Icons.check_rounded,
                              ),
                        label: Text(
                          _saving ? 'جاري الحفظ...' : 'حفظ التعديلات',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: _saving ? null : () => context.pop(),
                        child: const Text('إلغاء'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
