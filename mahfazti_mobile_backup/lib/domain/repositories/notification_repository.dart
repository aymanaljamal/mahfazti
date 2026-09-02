import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getNotifications();

  Future<List<AppNotification>> getUnreadNotifications();

  Future<int> getUnreadNotificationsCount();

  Future<void> markAsRead(int id);

  Future<void> markAllAsRead();

  Future<void> deleteNotification(int id);
}
