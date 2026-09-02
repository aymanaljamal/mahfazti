import '../enums/notification_type.dart';

class AppNotification {
  final int id;
  final NotificationType type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });
}
