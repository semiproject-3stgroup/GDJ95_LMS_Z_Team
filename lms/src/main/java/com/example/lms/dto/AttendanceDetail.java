package com.example.lms.dto;

import java.time.LocalDate;

import lombok.Data;

/**
 * 일자별 출석 상세 DTO
 */
@Data
public class AttendanceDetail {

    private Long userId;
    private Long courseId;

    private LocalDate attendanceDate; // 출석 일자
    private Integer attendance;       // 0:결석, 1:출석, 2:지각

    private String userName;
    private String studentNo;
}
