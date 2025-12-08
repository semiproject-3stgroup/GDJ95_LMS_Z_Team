// src/main/java/com/example/lms/dto/WeeklyTimetableSlot.java
package com.example.lms.dto;

import lombok.Data;

@Data
public class WeeklyTimetableSlot {
    // DAYOFWEEK() 결과 (1=일, 2=월, ... 7=토/일)
    private int dayOfWeek;      // 2~6만 쓸 예정 (월~금)
    private int period;         // 1~9교시

    private Long courseId;
    private String courseName;
    private String professorName;
}
