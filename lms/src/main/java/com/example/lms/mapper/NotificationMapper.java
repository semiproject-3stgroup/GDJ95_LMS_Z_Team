package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.Notification;

@Mapper
public interface NotificationMapper {

    int insertNotification(Notification notification);

    // 헤더 드롭다운용 최근 알림
    List<Notification> selectRecentNotifications(
            @Param("userId") Long userId,
            @Param("limit") int limit);

    // 전체 목록 (필요시 /notifications 페이지에서 사용)
    List<Notification> selectNotificationsByUser(
            @Param("userId") Long userId);

    int countUnreadNotifications(@Param("userId") Long userId);

    int markNotificationAsRead(
            @Param("notificationId") Long notificationId,
            @Param("userId") Long userId);

    int softDeleteNotification(
            @Param("notificationId") Long notificationId,
            @Param("userId") Long userId);
}
