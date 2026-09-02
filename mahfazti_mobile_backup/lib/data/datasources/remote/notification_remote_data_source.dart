import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/notification_model.dart';

class NotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _apiClient.get(
      ApiConstants.notifications,
    );

    final data = response.data as List<dynamic>;

    return data
        .map(
          (item) => NotificationModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<List<NotificationModel>> getUnreadNotifications() async {
    final response = await _apiClient.get(
      ApiConstants.unreadNotifications,
    );

    final data = response.data as List<dynamic>;

    return data
        .map(
          (item) => NotificationModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<int> getUnreadNotificationsCount() async {
    final response = await _apiClient.get(
      ApiConstants.unreadNotificationsCount,
    );

    if (response.data is num) {
      return (response.data as num).toInt();
    }

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;

      final value = data['count'] ?? data['unreadCount'] ?? data['data'];

      if (value is num) {
        return value.toInt();
      }
    }

    throw const FormatException(
      'Unexpected unread notifications count response.',
    );
  }

  Future<void> markAsRead(int id) async {
    final path = ApiConstants.markNotificationAsRead.replaceFirst(
      '{id}',
      id.toString(),
    );

    await _apiClient.put(path);
  }

  Future<void> markAllAsRead() async {
    await _apiClient.put(
      ApiConstants.markAllNotificationsRead,
    );
  }

  Future<void> deleteNotification(int id) async {
    final path = '${ApiConstants.notifications}/$id';

    await _apiClient.delete(path);
  }
}
