import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/remote/notification_remote_data_source.dart';

class NotificationRepositoryImpl
    implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl({
    required NotificationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<AppNotification>> getNotifications() async {
    final models =
        await _remoteDataSource.getNotifications();

    return models
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<List<AppNotification>>
      getUnreadNotifications() async {
    final models =
        await _remoteDataSource.getUnreadNotifications();

    return models
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<int> getUnreadNotificationsCount() async {
    return await _remoteDataSource
        .getUnreadNotificationsCount();
  }

  @override
  Future<void> markAsRead(
    int id,
  ) async {
    await _remoteDataSource.markAsRead(id);
  }

  @override
  Future<void> markAllAsRead() async {
    await _remoteDataSource.markAllAsRead();
  }

  @override
  Future<void> deleteNotification(
    int id,
  ) async {
    await _remoteDataSource.deleteNotification(id);
  }
}