package com.example.lms.service;

import java.util.List;
import java.util.Map;

import com.example.lms.dto.Course;
import com.example.lms.dto.CourseTimeSlot;
import com.example.lms.dto.EnrolledCourseSummary;
import com.example.lms.dto.WeeklyTimetableSlot;

public interface CourseService {

    List<Course> getMyCourses(Long userId);

    List<EnrolledCourseSummary> getEnrolledCoursesForHome(Long studentId, int limit);

    // 신청 가능한 강의 목록 (화면용)
    List<Course> getOpenCoursesForRegister(Long studentId, Integer year, String semester);

    // 내가 신청한 강의 목록
    List<Course> getMyRegisteredCourses(Long studentId, Integer year, String semester);

    // 수강 신청 (단건)
    void registerCourse(Long studentId, Long courseId);

    // 수강 신청 (여러 과목 한 번에) - 실패 사유: courseId → 메시지
    Map<Long, String> registerCoursesBulk(Long studentId, List<Long> courseIds);

    // 수강 취소
    void cancelCourse(Long studentId, Long courseId);

    // 수강 신청할 때 옆에 주간 시간표 (학기 기준)
    List<WeeklyTimetableSlot> getWeeklyTimetable(Long studentId,
                                                 Integer year,
                                                 String semester);

    // 주간 시간표 조회(현재 수강 + 미리보기 과목들 포함)
    List<CourseTimeSlot> getWeeklyTimetable(Long studentId, List<Long> previewCourseIds);
    
    // ===== 교수용 강의/수강생 조회 =====

    // 교수 본인이 담당하는 강의들
    List<Course> getProfessorCourses(Long profId, Integer year, String semester);

    // 특정 강의 기본 정보 (제목, 연도/학기 등)
    Course getCourseBasic(Long courseId);

    // 특정 강의 수강생 목록
    List<com.example.lms.dto.CourseStudent> getCourseStudents(Long courseId);
}
