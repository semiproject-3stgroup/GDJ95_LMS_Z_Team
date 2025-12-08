package com.example.lms.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class CourseRegistration {
    private Long registrationId;
    private Long courseId;
    private Long userId;
    private LocalDateTime registrationDate;
    private String status;
    private LocalDateTime createdate;
    private LocalDateTime updatedate;
}
