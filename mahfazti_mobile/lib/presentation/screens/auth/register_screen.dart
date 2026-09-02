import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/validators.dart';
import '../../providers/app_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController =
      TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _loading = true);

    try {
      await ref.read(authRepositoryProvider).register(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            phone: _phoneController.text.trim(),
          );

      if (!mounted) return;

      context.go('/');
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      validator: (value) =>
                          Validators.name(
                        value,
                        fieldName: 'الاسم الأول',
                      ),
                      decoration:
                          const InputDecoration(
                        labelText: 'الاسم الأول',
                        prefixIcon:
                            Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _lastNameController,
                      validator: (value) =>
                          Validators.name(
                        value,
                        fieldName: 'اسم العائلة',
                      ),
                      decoration:
                          const InputDecoration(
                        labelText: 'اسم العائلة',
                        prefixIcon:
                            Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emailController,
                      keyboardType:
                          TextInputType.emailAddress,
                      validator: Validators.email,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'البريد الإلكتروني',
                        prefixIcon:
                            Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: Validators.phone,
                      decoration:
                          const InputDecoration(
                        labelText: 'رقم الهاتف',
                        prefixIcon:
                            Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: Validators.password,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        prefixIcon:
                            const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller:
                          _confirmPasswordController,
                      obscureText:
                          _obscureConfirmPassword,
                      validator: (value) =>
                          Validators.confirmPassword(
                        value,
                        _passwordController.text,
                      ),
                      decoration: InputDecoration(
                        labelText:
                            'تأكيد كلمة المرور',
                        prefixIcon:
                            const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed:
                            _loading ? null : _register,
                        child: _loading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text('إنشاء الحساب'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () => context.go('/login'),
                      child: const Text(
                        'لديك حساب؟ تسجيل الدخول',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}