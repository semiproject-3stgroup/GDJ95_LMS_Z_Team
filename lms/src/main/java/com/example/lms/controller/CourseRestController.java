package com.example.lms.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.lms.dto.CourseTimeSlot;
import com.example.lms.dto.User;
import com.example.lms.service.CourseService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/course")
public class CourseRestController {

    @Autowired
    private CourseService courseService;

    /**
     * 주간 시간표 조회
     * - previewCourseId 가 있으면: 현재 수강 + 해당 과목까지 포함해서 반환
     */
    @GetMapping("/weekly-timetable")
    public List<CourseTimeSlot> getWeeklyTimetable(
            @RequestParam(required = false) Long previewCourseId,
            HttpSession session) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            log.warn("[weekly-timetable] 비로그인 접근");
            return List.of();
        }

        Long studentId = loginUser.getUserId();

        return courseService.getWeeklyTimetable(studentId, previewCourseId);
    }
}
