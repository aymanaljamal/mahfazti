package com.ayman.mahfazti.notification;

import java.util.List;

import org.springframework.stereotype.Component;

import com.ayman.mahfazti.notification.dto.NotificationResponse;

@Component
public class NotificationMapper {

    public NotificationResponse toResponse(Notification notification) {
        if (notification == null) {
            return null;
        }
        return NotificationResponse.builder()
                .id(notification.getId())
                .type(notification.getType())
                .title(notification.getTitle())
                .message(notification.getMessage())
                .isRead(notification.isRead())
                .createdAt(notification.getCreatedAt())
                .build();
    }

    public List<NotificationResponse> toResponseList(List<Notification> notifications) {
        return notifications.stream().map(this::toResponse).toList();
    }
}
