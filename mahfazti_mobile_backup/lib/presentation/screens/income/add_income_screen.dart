import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/validators.dart';
import '../../../domain/enums/income_source.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_loading.dart';

class AddIncomeScreen extends ConsumerStatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  ConsumerState<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends ConsumerState<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  IncomeSource? _selectedSource;

  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      _selectedDate = picked;
    });
  }

  Future<void> _saveIncome() async {
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
      await ref.read(incomeRepositoryProvider).createIncome(
            amount: amount,
            source: _selectedSource!,
            date: _selectedDate,
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تمت إضافة الدخل بنجاح.'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة دخل'),
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
                  'تفاصيل الدخل',
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
                        DateFormat('yyyy-MM-dd').format(_selectedDate),
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
                    onPressed: _saving ? null : _saveIncome,
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
                      _saving ? 'جاري الحفظ...' : 'حفظ الدخل',
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
