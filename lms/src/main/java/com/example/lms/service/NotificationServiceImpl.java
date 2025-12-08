package com.example.lms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.Course;
import com.example.lms.dto.Event;
import com.example.lms.dto.Notification;
import com.example.lms.dto.User;
import com.example.lms.mapper.CourseMapper;
import com.example.lms.mapper.NotificationMapper;
import com.example.lms.mapper.UserMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class NotificationServiceImpl implements NotificationService {
	
	@Autowired
	private CourseMapper courseMapper;

    @Autowired
    private NotificationMapper notificationMapper;
    
    @Autowired
    private UserMapper userMapper;              // ✅ 필드 추가

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
    
    @Override
    public void notifyScoreChanged(Long studentId, Long courseId, String action) {

        if (studentId == null || courseId == null) {
            return;
        }

        Course course = courseMapper.selectCourseBasicById(courseId);
        if (course == null) {
            return;
        }

        String prefix;
        switch (action) {
            case "CREATE":
                prefix = "[성적 등록] ";
                break;
            case "UPDATE":
                prefix = "[성적 변경] ";
                break;
            default:
                prefix = "[성적 알림] ";
        }

        String courseName = course.getCourseName();
        String title = prefix + courseName;
        String message = "과목 [" + courseName + "] 성적이 반영되었습니다.";

        Notification notification = new Notification();
        notification.setUserId(studentId);
        notification.setCategory("SCORE");
        notification.setTargetType("SCORE");
        notification.setTargetId(courseId.intValue());
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setLinkUrl("/mypage/score");

        // 여기! 이 한 줄만 유지하면 됨
        sendNotification(notification);
    }
    
    @Override
    public void notifyEventCreated(Event event) {
        if (event == null) return;

        // ACTIVE 유저 전체 조회
        List<User> users = userMapper.selectAllUsers();
        if (users == null || users.isEmpty()) return;

        String title = "[학사 일정 등록] " + event.getEventName();
        String message = "새로운 학사 일정이 등록되었습니다: "
                + event.getEventName();

        for (User u : users) {
            Notification n = new Notification();
            n.setUserId(u.getUserId());
            n.setCategory("EVENT");
            n.setTargetType("EVENT");
            if (event.getEventId() != null) {
                n.setTargetId(event.getEventId().intValue());
            }
            n.setTitle(title);
            n.setMessage(message);
            n.setLinkUrl("/calendar/academic"); // 학사 캘린더로 이동

            sendNotification(n); // ✅ 공통 메서드 사용
        }

        log.debug("학사 일정 등록 알림 완료, eventId={}", event.getEventId());
    }

    @Override
    public void notifyEventUpdated(Event event) {
        if (event == null) return;

        List<User> users = userMapper.selectAllUsers();
        if (users == null || users.isEmpty()) return;

        String title = "[학사 일정 변경] " + event.getEventName();
        String message = "학사 일정이 수정되었습니다: "
                + event.getEventName();

        for (User u : users) {
            Notification n = new Notification();
            n.setUserId(u.getUserId());
            n.setCategory("EVENT");
            n.setTargetType("EVENT");
            if (event.getEventId() != null) {
                n.setTargetId(event.getEventId().intValue());
            }
            n.setTitle(title);
            n.setMessage(message);
            n.setLinkUrl("/calendar/academic");

            sendNotification(n);
        }

        log.debug("학사 일정 수정 알림 완료, eventId={}", event.getEventId());
    }
}

