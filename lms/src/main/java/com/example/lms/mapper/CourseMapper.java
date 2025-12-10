package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.Course;
import com.example.lms.dto.CourseRegistration;
import com.example.lms.dto.CourseTimeSlot;
import com.example.lms.dto.EnrolledCourseSummary;
import com.example.lms.dto.WeeklyTimetableSlot;

@Mapper
public interface CourseMapper {

    // ===== 메인 페이지 요약 =====

    List<EnrolledCourseSummary> selectEnrolledCoursesForHome(
            @Param("studentId") Long studentId,
            @Param("limit") int limit,
            @Param("year") Integer year,
            @Param("semester") String semester
    );

    List<Long> selectEnrolledStudentIdsByCourseId(
            @Param("courseId") Long courseId
    );

    Course selectCourseBasicById(@Param("courseId") Long courseId);


    // ===== 수강신청/수강목록 =====

    List<Course> selectOpenCoursesForRegister(
            @Param("studentId") Long studentId,
            @Param("year") Integer year,
            @Param("semester") String semester
    );

    List<Course> selectMyRegisteredCourses(
            @Param("studentId") Long studentId,
            @Param("year") Integer year,
            @Param("semester") String semester
    );

    int insertCourseRegistration(CourseRegistration reg);

    int cancelCourseRegistration(
            @Param("studentId") Long studentId,
            @Param("courseId") Long courseId
    );

    int countRegisteredCoursesInSemester(
            @Param("studentId") Long studentId,
            @Param("year") Integer year,
            @Param("semester") String semester
    );

    int countEnrolledStudentsInCourse(@Param("courseId") Long courseId);

    int countTimeConflict(
            @Param("studentId") Long studentId,
            @Param("courseId") Long courseId
    );

    int countAlreadyRegistered(
            @Param("courseId") Long courseId,
            @Param("userId") Long userId
    );


    // ===== 시간표 =====

    List<WeeklyTimetableSlot> selectWeeklyTimetableByStudent(
            @Param("studentId") Long studentId,
            @Param("year") Integer year,
            @Param("semester") String semester
    );

    // ✅ 주간 시간표 (현재 ENROLLED + 미리보기 과목들 포함)
    List<CourseTimeSlot> selectWeeklyTimetable(
            @Param("studentId") Long studentId,
            @Param("previewCourseIds") List<Long> previewCourseIds
    );


    // ===== 기타 =====

    Map<String, Object> selectLatestYearSemesterForStudent(
            @Param("studentId") Long studentId
    );
    
    
    // ===== 교수용 강의/수강생 조회 =====

    // 교수 본인이 담당하는 강의 목록
    List<Course> selectCoursesByProfessor(
            @Param("profId") Long profId,
            @Param("year") Integer year,
            @Param("semester") String semester
    );

    // 특정 강의를 수강 중인 학생 목록
    List<com.example.lms.dto.CourseStudent> selectCourseStudents(
            @Param("courseId") Long courseId
    );
}
