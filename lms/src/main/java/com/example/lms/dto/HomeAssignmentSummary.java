package com.example.lms.dto;

import java.time.LocalDateTime;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class HomeAssignmentSummary {

    private Integer assignmentId;   // 과제 ID
    private Long courseId;          // 강의 ID
    private String courseName;      // 강의명
    private String assignmentName;  // 과제명

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime endDate;  // 마감일시

    private Integer dday;           // 남은일수

}
