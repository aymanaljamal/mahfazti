import '../../domain/entities/notification.dart';
import '../../domain/enums/notification_type.dart';

class NotificationModel {
  final int id;
  final NotificationType type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] as num).toInt(),
      type: NotificationTypeExtension.fromValue(
        json['type'] as String,
      ),
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: json['read'] as bool,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'title': title,
      'message': message,
      'read': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  AppNotification toEntity() {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      message: message,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}