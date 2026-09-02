import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/notification.dart';
import '../../../domain/enums/notification_type.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_empty_view.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/app_loading.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  late Future<List<AppNotification>> _future;

  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    final repository = ref.read(notificationRepositoryProvider);

    _future = _showUnreadOnly
        ? repository.getUnreadNotifications()
        : repository.getNotifications();
  }

  Future<void> _refresh() async {
    setState(_loadNotifications);

    try {
      await _future;
    } catch (_) {}
  }

  Future<void> _markAsRead(
    AppNotification notification,
  ) async {
    if (notification.isRead) {
      return;
    }

    try {
      await ref
          .read(notificationRepositoryProvider)
          .markAsRead(notification.id);

      if (!mounted) return;

      _showMessage('تم تحديد الإشعار كمقروء.');
      _refresh();
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString());
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await ref.read(notificationRepositoryProvider).markAllAsRead();

      if (!mounted) return;

      _showMessage('تم تحديد جميع الإشعارات كمقروءة.');
      _refresh();
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString());
    }
  }

  Future<void> _deleteNotification(
    AppNotification notification,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف الإشعار'),
          content: const Text(
            'هل أنت متأكد من حذف هذا الإشعار؟',
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
      await ref
          .read(notificationRepositoryProvider)
          .deleteNotification(notification.id);

      if (!mounted) return;

      _showMessage('تم حذف الإشعار.');
      _refresh();
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString());
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String _notificationTitle(
    NotificationType type,
    String fallback,
  ) {
    if (fallback.trim().isNotEmpty) {
      return fallback;
    }

    switch (type) {
      case NotificationType.budgetWarning:
        return 'تنبيه الميزانية';

      case NotificationType.budgetExceeded:
        return 'تجاوز الميزانية';

      case NotificationType.goalProgress:
        return 'تقدم مالي';

      case NotificationType.reminder:
        return 'تذكير';

      case NotificationType.monthlyReport:
        return 'التقرير الشهري';

      case NotificationType.unusualSpending:
        return 'إنفاق غير معتاد';
    }
  }

  IconData _notificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.budgetWarning:
        return Icons.warning_amber_rounded;

      case NotificationType.budgetExceeded:
        return Icons.error_outline_rounded;

      case NotificationType.goalProgress:
        return Icons.flag_outlined;

      case NotificationType.reminder:
        return Icons.notifications_active_outlined;

      case NotificationType.monthlyReport:
        return Icons.bar_chart_rounded;

      case NotificationType.unusualSpending:
        return Icons.trending_up_rounded;
    }
  }

  Color _notificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.budgetWarning:
        return AppColors.warning;

      case NotificationType.budgetExceeded:
        return AppColors.error;

      case NotificationType.goalProgress:
        return AppColors.success;

      case NotificationType.reminder:
        return AppColors.primary;

      case NotificationType.monthlyReport:
        return AppColors.info;

      case NotificationType.unusualSpending:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        actions: [
          if (!_showUnreadOnly)
            IconButton(
              tooltip: 'تحديد الكل كمقروء',
              onPressed: _markAllAsRead,
              icon: const Icon(
                Icons.done_all_rounded,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              12,
              16,
              4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('الكل'),
                    selected: !_showUnreadOnly,
                    onSelected: (_) {
                      setState(() {
                        _showUnreadOnly = false;
                      });
                      _loadNotifications();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('غير المقروءة'),
                    selected: _showUnreadOnly,
                    onSelected: (_) {
                      setState(() {
                        _showUnreadOnly = true;
                      });
                      _loadNotifications();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<AppNotification>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const AppLoading(
                      message: 'جاري تحميل الإشعارات...',
                    );
                  }

                  if (snapshot.hasError) {
                    return AppErrorView(
                      error: snapshot.error!,
                      onRetry: _refresh,
                    );
                  }

                  final notifications = snapshot.data ?? [];

                  if (notifications.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 120),
                        AppEmptyView(
                          icon: Icons.notifications_none_rounded,
                          title: _showUnreadOnly
                              ? 'لا توجد إشعارات غير مقروءة'
                              : 'لا توجد إشعارات',
                          subtitle: 'ستظهر هنا الإشعارات المالية المهمة.',
                        ),
                      ],
                    );
                  }

                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      12,
                      16,
                      24,
                    ),
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];

                      return _NotificationCard(
                        notification: notification,
                        title: _notificationTitle(
                          notification.type,
                          notification.title,
                        ),
                        icon: _notificationIcon(
                          notification.type,
                        ),
                        color: _notificationColor(
                          notification.type,
                        ),
                        onTap: () => _markAsRead(notification),
                        onDelete: () => _deleteNotification(
                          notification,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.notification,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: notification.isRead
          ? AppColors.surface
          : AppColors.primaryLight.withOpacity(0.35),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.12),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.labelLarge,
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 9,
                            height: 9,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.message,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat(
                        'yyyy-MM-dd  HH:mm',
                      ).format(
                        notification.createdAt,
                      ),
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('حذف'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
