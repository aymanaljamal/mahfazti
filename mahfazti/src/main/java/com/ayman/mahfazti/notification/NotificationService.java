package com.ayman.mahfazti.notification;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ayman.mahfazti.common.enums.NotificationType;
import com.ayman.mahfazti.common.exception.ResourceNotFoundException;
import com.ayman.mahfazti.notification.dto.NotificationResponse;
import com.ayman.mahfazti.user.User;
import com.ayman.mahfazti.user.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;
    private final NotificationMapper notificationMapper;

    /**
     * Internal helper other services (Budget, Goal, Report scheduler...) can call
     * directly to create a notification for a user — no HTTP layer needed.
     */
    @Transactional
    public Notification notify(Long userId, NotificationType type, String title, String message) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        Notification notification = Notification.builder()
                .user(user)
                .type(type)
                .title(title)
                .message(message)
                .build();

        return notificationRepository.save(notification);
    }

    @Transactional(readOnly = true)
    public List<NotificationResponse> getAll(Long userId) {
        return notificationMapper.toResponseList(
                notificationRepository.findByUserIdOrderByCreatedAtDesc(userId));
    }

    @Transactional(readOnly = true)
    public List<NotificationResponse> getUnread(Long userId) {
        return notificationMapper.toResponseList(
                notificationRepository.findByUserIdAndIsReadFalseOrderByCreatedAtDesc(userId));
    }

    @Transactional(readOnly = true)
    public long getUnreadCount(Long userId) {
        return notificationRepository.countByUserIdAndIsReadFalse(userId);
    }

    @Transactional
    public NotificationResponse markAsRead(Long userId, Long notificationId) {
        Notification notification = notificationRepository.findByIdAndUserId(notificationId, userId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Notification not found with id: " + notificationId));

        notification.setRead(true);
        return notificationMapper.toResponse(notificationRepository.save(notification));
    }

    @Transactional
    public void markAllAsRead(Long userId) {
        notificationRepository.markAllAsRead(userId);
    }

    @Transactional
    public void delete(Long userId, Long notificationId) {
        Notification notification = notificationRepository.findByIdAndUserId(notificationId, userId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Notification not found with id: " + notificationId));

        notificationRepository.delete(notification);
    }
}
