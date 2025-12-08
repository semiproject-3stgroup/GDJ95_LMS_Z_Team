package com.example.lms.dto;

import lombok.Data;

@Data
public class Course {
    private Long courseId;
    private String courseName;

    private Integer courseYear;
    private String courseSemester;
    private Double credit;
    private Integer maxCapacity;
    private String status;

    // 화면용
    private String profName;   
    
 // 수업 요일/시간 요약
    private String scheduleSummary;
}