package com.example.lms.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Notification {

    private Long notificationId;
    private Long userId;

    // notice / assignment / score / schedule
    private String category;

    // NOTICE, ASSIGNMENT, SCORE, EVENT 등
    private String targetType;
    private Integer targetId;

    private String title;       // 최대 150자
    private String message;     // 최대 400자
    private String linkUrl;

    private String readYn;      // Y / N
    private LocalDateTime readDate;

    private String deleteYn;    // Y / N
    private LocalDateTime deleteDate;

    private LocalDateTime createdate;
}