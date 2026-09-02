package com.ayman.mahfazti.notification;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ayman.mahfazti.common.exception.ResourceNotFoundException;
import com.ayman.mahfazti.notification.dto.NotificationResponse;
import com.ayman.mahfazti.user.User;
import com.ayman.mahfazti.user.UserRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;
    private final UserRepository userRepository;

    private Long currentUserId(Authentication authentication) {
        String email = authentication.getName();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found: " + email));
        return user.getId();
    }

    @GetMapping
    public ResponseEntity<List<NotificationResponse>> getAll(Authentication authentication) {
        return ResponseEntity.ok(notificationService.getAll(currentUserId(authentication)));
    }

    @GetMapping("/unread")
    public ResponseEntity<List<NotificationResponse>> getUnread(Authentication authentication) {
        return ResponseEntity.ok(notificationService.getUnread(currentUserId(authentication)));
    }

    @GetMapping("/unread-count")
    public ResponseEntity<Map<String, Long>> getUnreadCount(Authentication authentication) {
        long count = notificationService.getUnreadCount(currentUserId(authentication));
        return ResponseEntity.ok(Map.of("count", count));
    }

    @PutMapping("/{id}/read")
    public ResponseEntity<NotificationResponse> markAsRead(
            Authentication authentication,
            @PathVariable Long id) {

        return ResponseEntity.ok(
                notificationService.markAsRead(currentUserId(authentication), id));
    }

    @PutMapping("/read-all")
    public ResponseEntity<Void> markAllAsRead(Authentication authentication) {
        notificationService.markAllAsRead(currentUserId(authentication));
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            Authentication authentication,
            @PathVariable Long id) {

        notificationService.delete(currentUserId(authentication), id);
        return ResponseEntity.noContent().build();
    }
}
