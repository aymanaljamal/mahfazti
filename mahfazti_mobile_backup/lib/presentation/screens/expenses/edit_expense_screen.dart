import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/validators.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/enums/payment_method.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/app_loading.dart';

class EditExpenseScreen extends ConsumerStatefulWidget {
  final int expenseId;

  const EditExpenseScreen({
    super.key,
    required this.expenseId,
  });

  @override
  ConsumerState<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends ConsumerState<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  int? _selectedCategoryId;
  PaymentMethod? _selectedPaymentMethod;

  bool _loading = true;
  bool _saving = false;

  Expense? _expense;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadExpense();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadExpense() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final expense = await ref
          .read(expenseRepositoryProvider)
          .getExpenseById(widget.expenseId);

      if (!mounted) return;

      setState(() {
        _expense = expense;

        _amountController.text = expense.amount.toStringAsFixed(2);

        _descriptionController.text = expense.description ?? '';

        _selectedDate = expense.date;

        _selectedTime = TimeOfDay(
          hour: expense.time.hour,
          minute: expense.time.minute,
        );

        _selectedCategoryId = expense.categoryId;

        _selectedPaymentMethod = expense.paymentMethod;

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

  Future<void> _pickDate() async {
    final currentDate = _selectedDate ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      _selectedDate = picked;
    });
  }

  Future<void> _pickTime() async {
    final currentTime = _selectedTime ?? TimeOfDay.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    if (picked == null) return;

    setState(() {
      _selectedTime = picked;
    });
  }

  DateTime _buildTimeDateTime() {
    final date = _selectedDate ?? DateTime.now();
    final time = _selectedTime ?? TimeOfDay.now();

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  Future<void> _updateExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryId == null) {
      _showMessage('يرجى اختيار الفئة.');
      return;
    }

    if (_selectedPaymentMethod == null) {
      _showMessage('يرجى اختيار طريقة الدفع.');
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
      await ref.read(expenseRepositoryProvider).updateExpense(
            id: widget.expenseId,
            amount: amount,
            categoryId: _selectedCategoryId,
            date: _selectedDate,
            time: _buildTimeDateTime(),
            paymentMethod: _selectedPaymentMethod,
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم تعديل المصروف بنجاح.',
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

  String _paymentMethodLabel(
    PaymentMethod method,
  ) {
    switch (method) {
      case PaymentMethod.cash:
        return 'نقدًا';

      case PaymentMethod.creditCard:
        return 'بطاقة ائتمان';

      case PaymentMethod.debitCard:
        return 'بطاقة خصم';

      case PaymentMethod.bankTransfer:
        return 'تحويل بنكي';

      case PaymentMethod.digitalWallet:
        return 'محفظة إلكترونية';

      case PaymentMethod.other:
        return 'أخرى';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: AppLoading(
          message: 'جاري تحميل بيانات المصروف...',
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('تعديل المصروف'),
        ),
        body: AppErrorView(
          error: Exception(_errorMessage),
          onRetry: _loadExpense,
        ),
      );
    }

    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل المصروف'),
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
          final categoriesExist = categories.any(
            (category) => category.id == _selectedCategoryId,
          );

          return SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'تعديل تفاصيل المصروف',
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
                      value: categoriesExist ? _selectedCategoryId : null,
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
                    DropdownButtonFormField<PaymentMethod>(
                      value: _selectedPaymentMethod,
                      decoration: const InputDecoration(
                        labelText: 'طريقة الدفع',
                        prefixIcon: Icon(
                          Icons.payment_outlined,
                        ),
                      ),
                      items: PaymentMethod.values
                          .map(
                            (method) => DropdownMenuItem<PaymentMethod>(
                              value: method,
                              child: Text(
                                _paymentMethodLabel(
                                  method,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: _saving
                          ? null
                          : (value) {
                              setState(() {
                                _selectedPaymentMethod = value;
                              });
                            },
                      validator: (value) {
                        if (value == null) {
                          return 'طريقة الدفع مطلوبة.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed: _saving ? null : _pickDate,
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                      ),
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('التاريخ'),
                          Text(
                            DateFormat(
                              'yyyy-MM-dd',
                            ).format(
                              _selectedDate ?? DateTime.now(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: _saving ? null : _pickTime,
                      icon: const Icon(
                        Icons.access_time_outlined,
                      ),
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('الوقت'),
                          Text(
                            (_selectedTime ?? TimeOfDay.now()).format(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      maxLength: 500,
                      validator: Validators.description,
                      decoration: const InputDecoration(
                        labelText: 'الوصف',
                        alignLabelWithHint: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                            bottom: 65,
                          ),
                          child: Icon(
                            Icons.description_outlined,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _saving ? null : _updateExpense,
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
