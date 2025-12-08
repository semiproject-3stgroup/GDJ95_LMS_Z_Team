package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.Event;
import com.example.lms.dto.Notification;

public interface NotificationService {

    void sendNotification(Notification notification);

    List<Notification> getRecentNotifications(Long userId, int limit);

    int getUnreadCount(Long userId);

    void markAsRead(Long notificationId, Long userId);

    // 숨기기
    void softDelete(Long notificationId, Long userId);
    
    // 성적 입력/수정 알림 (학생 1명 대상)
    void notifyScoreChanged(Long studentId, Long courseId, String action);
    
    // 학사일정 생성알림
    void notifyEventCreated(Event event);
    
    // 학사일정 수정알림    
    void notifyEventUpdated(Event event);
}
