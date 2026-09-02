import 'package:flutter/material.dart';

import '../../core/errors/app_exception.dart';
import '../theme/app_colors.dart';

class AppErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const AppErrorView({
    super.key,
    required this.error,
    this.onRetry,
  });

  String get message {
    if (error is AppException) {
      return (error as AppException).message;
    }

    return 'حدث خطأ غير متوقع.';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'حدث خطأ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}