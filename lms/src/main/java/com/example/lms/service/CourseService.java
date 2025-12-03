package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.Course;
import com.example.lms.dto.EnrolledCourseSummary;

public interface CourseService {
    List<Course> getMyCourses(Long userId);
    
    // 순표: 서희님 저 기능때문에 여기에 메서드좀 추가했습니다. (메인페이지 수강 중 강의 요약 블록용)
    List<EnrolledCourseSummary> getEnrolledCoursesForHome(Long studentId, int limit);
}