package com.example.lms.dto;

import lombok.Data;

@Data
public class CourseTimeSlot {

    // 1=월, 2=화, 3=수, 4=목, 5=금
    private int dayOfWeek;

    // 1교시 ~ 9교시
    private int period;

    private Long courseId;
    private String courseName;
    private String professorName;
}
