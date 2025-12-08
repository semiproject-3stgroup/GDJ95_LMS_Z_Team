package com.example.lms.service;

import java.util.List;

import com.example.lms.dto.Course;
import com.example.lms.dto.EnrolledCourseSummary;

public interface CourseService {

    // 
    List<Course> getMyCourses(Long userId);

    List<EnrolledCourseSummary> getEnrolledCoursesForHome(Long studentId, int limit);

    // 신청 가능한 강의 목록 (화면용)
    List<Course> getOpenCoursesForRegister(Long studentId, Integer year, String semester);

    // 내가 신청한 강의 목록
    List<Course> getMyRegisteredCourses(Long studentId, Integer year, String semester);

    // 수강 신청
    void registerCourse(Long studentId, Long courseId);

    // 수강 취소
    void cancelCourse(Long studentId, Long courseId);
}
