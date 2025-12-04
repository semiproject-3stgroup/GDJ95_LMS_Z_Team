package com.example.lms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.Notification;
import com.example.lms.mapper.NotificationMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class NotificationServiceImpl implements NotificationService {

    @Autowired
    private NotificationMapper notificationMapper;

    @Override
    public void sendNotification(Notification notification) {
        if (notification == null || notification.getUserId() == null) {
            log.warn("알림 대상 정보 없음: {}", notification);
            return;
        }

        if (notification.getReadYn() == null) {
            notification.setReadYn("N");
        }
        if (notification.getDeleteYn() == null) {
            notification.setDeleteYn("N");
        }

        int result = notificationMapper.insertNotification(notification);
        log.debug("알림 등록 완료 result={}, notification={}", result, notification);
    }

    @Override
    public List<Notification> getRecentNotifications(Long userId, int limit) {
        return notificationMapper.selectRecentNotifications(userId, limit);
    }

    @Override
    public int getUnreadCount(Long userId) {
        return notificationMapper.countUnreadNotifications(userId);
    }

    @Override
    public void markAsRead(Long notificationId, Long userId) {
        notificationMapper.markNotificationAsRead(notificationId, userId);
    }

    @Override
    public void softDelete(Long notificationId, Long userId) {
        notificationMapper.softDeleteNotification(notificationId, userId);
    }
}
