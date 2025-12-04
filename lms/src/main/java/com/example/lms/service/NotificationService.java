package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.Notification;

public interface NotificationService {

    void sendNotification(Notification notification);

    List<Notification> getRecentNotifications(Long userId, int limit);

    int getUnreadCount(Long userId);

    void markAsRead(Long notificationId, Long userId);

    void softDelete(Long notificationId, Long userId);
}
