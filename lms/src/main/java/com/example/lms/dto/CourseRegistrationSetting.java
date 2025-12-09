package com.example.lms.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class CourseRegistrationSetting {

    private Long settingId;

    private Integer year;          // 2025
    private String  semester;      // "1학기", "2학기" 등

    private LocalDateTime registerStart;
    private LocalDateTime registerEnd;
    private LocalDateTime cancelEnd;

    private String manualOpenYn;   // "Y" / "N"

    private LocalDateTime createdate;
    private LocalDateTime updatedate;
}
