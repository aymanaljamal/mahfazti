import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/validators.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/enums/user_role.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/app_loading.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late Future<User> _future;

  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _profileImageUrl;

  bool _editing = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _roleLabel(UserRole role) {
    switch (role) {
      case UserRole.user:
        return 'مستخدم';

      case UserRole.admin:
        return 'مدير';
    }
  }

  void _loadUser() {
    _future = _loadUserData();
  }

  Future<User> _loadUserData() async {
    final user = await ref.read(userRepositoryProvider).getCurrentUser();

    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _phoneController.text = user.phone ?? '';
    _profileImageUrl = user.profileImageUrl;

    return user;
  }

  Future<void> _refresh() async {
    setState(_loadUser);

    try {
      await _future;
    } catch (_) {
      // FutureBuilder handles the error state.
    }
  }

  void _startEditing(User user) {
    setState(() {
      _editing = true;

      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _phoneController.text = user.phone ?? '';
      _profileImageUrl = user.profileImageUrl;
    });
  }

  void _cancelEditing() {
    setState(() {
      _editing = false;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await ref.read(userRepositoryProvider).updateCurrentUser(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            phone: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
            profileImageUrl: _profileImageUrl,
          );

      if (!mounted) return;

      setState(() {
        _editing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم تحديث الملف الشخصي بنجاح.',
          ),
        ),
      );

      _loadUser();
      setState(() {});
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        _getErrorMessage(error),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text(
            'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
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
              child: const Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await ref.read(authRepositoryProvider).logout();

      if (!mounted) return;

      context.go('/login');
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        _getErrorMessage(error),
      );
    }
  }

  String _getErrorMessage(Object error) {
    return error.toString();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String _initials(User user) {
    final first =
        user.firstName.trim().isNotEmpty ? user.firstName.trim()[0] : '';

    final last = user.lastName.trim().isNotEmpty ? user.lastName.trim()[0] : '';

    final initials = '$first$last'.trim();

    return initials.isEmpty ? '؟' : initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        actions: [
          if (!_editing)
            IconButton(
              tooltip: 'تعديل',
              onPressed: () async {
                final user = await _future;

                if (!mounted) return;

                _startEditing(user);
              },
              icon: const Icon(
                Icons.edit_outlined,
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<User>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(
                message: 'جاري تحميل الملف الشخصي...',
              );
            }

            if (snapshot.hasError) {
              return AppErrorView(
                error: snapshot.error!,
                onRetry: _refresh,
              );
            }

            final user = snapshot.data;

            if (user == null) {
              return AppErrorView(
                error: Exception(
                  'تعذر تحميل بيانات المستخدم.',
                ),
                onRetry: _refresh,
              );
            }

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(18),
              children: [
                _ProfileHeader(
                  user: user,
                  initials: _initials(user),
                ),
                const SizedBox(height: 20),
                if (_editing) _buildEditForm() else _buildInfoCard(user),
                const SizedBox(height: 18),
                _buildAccountCard(user),
                const SizedBox(height: 18),
                _buildLogoutButton(),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(User user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.person_outline_rounded,
              title: 'الاسم',
              value: user.fullName,
            ),
            const Divider(height: 26),
            _InfoRow(
              icon: Icons.email_outlined,
              title: 'البريد الإلكتروني',
              value: user.email,
            ),
            const Divider(height: 26),
            _InfoRow(
              icon: Icons.phone_outlined,
              title: 'رقم الهاتف',
              value: user.phone?.isNotEmpty == true ? user.phone! : 'غير مضاف',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'تعديل البيانات',
                style: AppTextStyles.headlineSmall,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _firstNameController,
                enabled: !_saving,
                validator: (value) {
                  return Validators.name(
                    value,
                    fieldName: 'الاسم الأول',
                  );
                },
                decoration: const InputDecoration(
                  labelText: 'الاسم الأول',
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _lastNameController,
                enabled: !_saving,
                validator: (value) {
                  return Validators.name(
                    value,
                    fieldName: 'اسم العائلة',
                  );
                },
                decoration: const InputDecoration(
                  labelText: 'اسم العائلة',
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _phoneController,
                enabled: !_saving,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }

                  return Validators.phone(value);
                },
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _saveProfile,
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
              const SizedBox(height: 10),
              SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: _saving ? null : _cancelEditing,
                  child: const Text('إلغاء'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard(User user) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 6,
        ),
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryLight,
          child: const Icon(
            Icons.verified_user_outlined,
            color: AppColors.primary,
          ),
        ),
        title: const Text(
          'نوع الحساب',
        ),
        subtitle: Text(
          _roleLabel(user.role),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _saving ? null : _logout,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(
            color: AppColors.error,
          ),
        ),
        icon: const Icon(
          Icons.logout_rounded,
        ),
        label: const Text(
          'تسجيل الخروج',
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final User user;
  final String initials;

  const _ProfileHeader({
    required this.user,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.profileImageUrl?.trim();

    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.primaryLight,
              backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
              child: !hasImage
                  ? Text(
                      initials,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 14),
            Text(
              user.fullName,
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              user.email,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 21,
          backgroundColor: AppColors.primaryLight,
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.labelLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
