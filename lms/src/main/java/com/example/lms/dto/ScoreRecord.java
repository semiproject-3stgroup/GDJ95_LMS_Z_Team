package com.example.lms.dto;

import lombok.Data;

@Data
public class ScoreRecord {

    private Long userId;    
    private Long courseId;

    // course 테이블 정보
    private String courseName;
    private Integer courseYear;
    private String courseSemester;
    private Double credit;   

    // score 테이블 정보
    private Double exam1Score;
    private Double exam2Score;
    private Double assignmentScore;
    private Double attendanceScore;
    private Double scoreTotal;

    // 계산용 필드 (DB 컬럼 아님)
    private String letterGrade;  
    private Double gradePoint;  
}
