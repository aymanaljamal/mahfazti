import 'package:flutter/material.dart';

import '../../core/errors/app_exception.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  final String title;

  const AppErrorView({
    super.key,
    required this.error,
    this.onRetry,
    this.title = 'حدث خطأ',
  });

  String get message {
    if (error is AppException) {
      return (error as AppException).message;
    }

    return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 420,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 40,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineSmall,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(
                      Icons.refresh_rounded,
                    ),
                    label: const Text(
                      'إعادة المحاولة',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
