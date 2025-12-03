package com.example.lms.dto;

import java.math.BigDecimal;
import lombok.Data;

@Data
public class EnrolledCourseSummary {

    private Long courseId;          // 강의 ID
    private String courseName;      // 강의명
    private Integer courseYear;     // 개설 연도
    private String courseSemester;  // 개설 학기 (1학기, 2학기 등)
    private BigDecimal credit;      // 학점

    private String professorName;   // 담당 교수 이름
    private String courseStatus;    // 강의 상태 (OPEN, CLOSE 등)
}
