import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/validators.dart';
import '../../../domain/enums/payment_method.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_loading.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  int? _selectedCategoryId;
  PaymentMethod? _selectedPaymentMethod;

  bool _loading = false;
  bool _loadingCategories = true;
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _loadingCategories = true;
      _categoryError = null;
    });

    try {
      await ref.read(categoryRepositoryProvider).getCategories();
    } catch (error) {
      if (mounted) {
        setState(() {
          _categoryError = error.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingCategories = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  DateTime _buildTimeDateTime() {
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      _selectedDate = picked;
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked == null) return;

    setState(() {
      _selectedTime = picked;
    });
  }

  Future<void> _saveExpense() async {
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
      _loading = true;
    });

    try {
      await ref.read(expenseRepositoryProvider).createExpense(
            amount: amount,
            categoryId: _selectedCategoryId!,
            date: _selectedDate,
            time: _buildTimeDateTime(),
            paymentMethod: _selectedPaymentMethod!,
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تمت إضافة المصروف بنجاح.'),
        ),
      );

      context.pop();
    } catch (error) {
      if (!mounted) return;

      _showMessage(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
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
    final categoriesAsync = ref.watch(
      categoryListProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة مصروف'),
      ),
      body: _loadingCategories
          ? const AppLoading(
              message: 'جاري تحميل الفئات...',
            )
          : _categoryError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.error,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _categoryError!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadCategories,
                          child: const Text(
                            'إعادة المحاولة',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : categoriesAsync.when(
                  loading: () => const AppLoading(
                    message: 'جاري تحميل الفئات...',
                  ),
                  error: (error, _) => Center(
                    child: Text(
                      error.toString(),
                    ),
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
                                'تفاصيل المصروف',
                                style: AppTextStyles.headlineSmall,
                              ),
                              const SizedBox(height: 18),
                              TextFormField(
                                controller: _amountController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
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
                                onChanged: _loading
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
                                      (method) =>
                                          DropdownMenuItem<PaymentMethod>(
                                        value: method,
                                        child: Text(
                                          _paymentMethodLabel(
                                            method,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: _loading
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
                                onPressed: _loading ? null : _pickDate,
                                icon: const Icon(
                                  Icons.calendar_today_outlined,
                                ),
                                label: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('التاريخ'),
                                    Text(
                                      DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(
                                        _selectedDate,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              OutlinedButton.icon(
                                onPressed: _loading ? null : _pickTime,
                                icon: const Icon(
                                  Icons.access_time_outlined,
                                ),
                                label: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('الوقت'),
                                    Text(
                                      _selectedTime.format(
                                        context,
                                      ),
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
                                  onPressed: _loading ? null : _saveExpense,
                                  icon: _loading
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
                                    _loading ? 'جاري الحفظ...' : 'حفظ المصروف',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 52,
                                child: OutlinedButton(
                                  onPressed:
                                      _loading ? null : () => context.pop(),
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
