import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/validators.dart';
import '../../../domain/enums/income_source.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/app_loading.dart';

class EditIncomeScreen extends ConsumerStatefulWidget {
  final int incomeId;

  const EditIncomeScreen({
    super.key,
    required this.incomeId,
  });

  @override
  ConsumerState<EditIncomeScreen> createState() => _EditIncomeScreenState();
}

class _EditIncomeScreenState extends ConsumerState<EditIncomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  IncomeSource? _selectedSource;

  bool _loading = true;
  bool _saving = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadIncome();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadIncome() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final income = await ref
          .read(incomeRepositoryProvider)
          .getIncomeById(widget.incomeId);

      if (!mounted) return;

      setState(() {
        _amountController.text = income.amount.toStringAsFixed(2);

        _descriptionController.text = income.description ?? '';

        _selectedDate = income.date;
        _selectedSource = income.source;

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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      _selectedDate = picked;
    });
  }

  Future<void> _updateIncome() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSource == null) {
      _showMessage('يرجى اختيار مصدر الدخل.');
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
      await ref.read(incomeRepositoryProvider).updateIncome(
            id: widget.incomeId,
            amount: amount,
            source: _selectedSource!,
            date: _selectedDate ?? DateTime.now(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تعديل الدخل بنجاح.'),
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
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: AppLoading(
          message: 'جاري تحميل بيانات الدخل...',
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('تعديل الدخل'),
        ),
        body: AppErrorView(
          error: Exception(_errorMessage),
          onRetry: _loadIncome,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الدخل'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'تعديل تفاصيل الدخل',
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
                    prefixIcon: Icon(Icons.payments_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<IncomeSource>(
                  value: _selectedSource,
                  decoration: const InputDecoration(
                    labelText: 'مصدر الدخل',
                    prefixIcon: Icon(Icons.source_outlined),
                  ),
                  items: IncomeSource.values
                      .map(
                        (source) => DropdownMenuItem<IncomeSource>(
                          value: source,
                          child: Text(
                            _sourceLabel(source),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _saving
                      ? null
                      : (value) {
                          setState(() {
                            _selectedSource = value;
                          });
                        },
                  validator: (value) {
                    if (value == null) {
                      return 'مصدر الدخل مطلوب.';
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
                        DateFormat('yyyy-MM-dd').format(
                          _selectedDate ?? DateTime.now(),
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
                      padding: EdgeInsets.only(bottom: 65),
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
                    onPressed: _saving ? null : _updateIncome,
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
      ),
    );
  }
}
