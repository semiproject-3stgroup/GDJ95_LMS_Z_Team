package com.example.lms.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class MyCalendarEvent {

    private Long eventId;        // schedule_id 또는 assignment_id
    private Long courseId;
    private String courseName;

    private String title;        // 화면에 보일 제목
    private LocalDateTime start; // 시작 일시
    private LocalDateTime end;   // 종료 일시

    private String type;         // CLASS / EXAM / ASSIGNMENT / SCHOOL 등
    private String backgroundColor; // FullCalendar 색상용 (선택)
}
