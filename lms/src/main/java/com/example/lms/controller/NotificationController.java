package com.example.lms.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.example.lms.dto.Notification;
import com.example.lms.dto.User;
import com.example.lms.service.NotificationService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    @Autowired
    private NotificationService notificationService;

    private Long getLoginUserId(HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        return (loginUser != null) ? loginUser.getUserId() : null;
    }

    @GetMapping("/recent")
    public Map<String, Object> getRecent(HttpSession session,
                                         @RequestParam(defaultValue = "5") int limit) {
        Map<String, Object> res = new HashMap<>();
        Long userId = getLoginUserId(session);

        if (userId == null) {
            res.put("success", false);
            res.put("message", "로그인이 필요합니다.");
            return res;
        }

        List<Notification> list = notificationService.getRecentNotifications(userId, limit);
        int unreadCount = notificationService.getUnreadCount(userId);

        res.put("success", true);
        res.put("items", list);
        res.put("unreadCount", unreadCount);
        return res;
    }

    @GetMapping("/unread-count")
    public Map<String, Object> unreadCount(HttpSession session) {
        Map<String, Object> res = new HashMap<>();
        Long userId = getLoginUserId(session);

        if (userId == null) {
            res.put("success", false);
            res.put("unreadCount", 0);
            return res;
        }

        res.put("success", true);
        res.put("unreadCount", notificationService.getUnreadCount(userId));
        return res;
    }

    @PostMapping("/{id}/read")
    public Map<String, Object> markAsRead(@PathVariable("id") Long id,
                                          HttpSession session) {
        Map<String, Object> res = new HashMap<>();
        Long userId = getLoginUserId(session);

        if (userId == null) {
            res.put("success", false);
            res.put("message", "로그인이 필요합니다.");
            return res;
        }

        notificationService.markAsRead(id, userId);
        res.put("success", true);
        return res;
    }

    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable("id") Long notificationId,
                                      HttpSession session) {

        Map<String, Object> result = new HashMap<>();

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        Long userId = loginUser.getUserId();

        // soft delete 수행
        notificationService.softDelete(notificationId, userId);

        // 남은 미확인 알림 수 재계산
        int unreadCount = notificationService.getUnreadCount(userId);

        result.put("success", true);
        result.put("unreadCount", unreadCount);
        return result;
    }
}
