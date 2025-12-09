package com.example.lms.dto;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class HomeAssignmentSummary {

    private int assignmentId;   // 과제 ID
    private Long courseId;          // 강의 ID
    private String courseName;      // 강의명
    private String assignmentName;  // 과제명

    // 화면에서 그대로 문자열로 쓰는 용도 (yyyy-MM-dd HH:mm 형식으로 매퍼에서 포맷)
    private String endDate;  // 마감일시

    private int dday;           // 남은일수

}
