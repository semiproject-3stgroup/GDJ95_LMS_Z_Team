package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.Course;
import com.example.lms.dto.CourseRegistration;
import com.example.lms.dto.CourseTimeSlot;
import com.example.lms.dto.EnrolledCourseSummary;
import com.example.lms.dto.WeeklyTimetableSlot;

@Mapper
public interface CourseMapper {

    // 메인페이지: 로그인한 학생의 수강 중 강의 요약 리스트
    List<EnrolledCourseSummary> selectEnrolledCoursesForHome(
            @Param("studentId") Long studentId,
            @Param("limit") int limit
    );
    
    // 알림 기능: 해당 강의를 수강 중인 학생 ID 목록
    List<Long> selectEnrolledStudentIdsByCourseId(
            @Param("courseId") Long courseId
    );
    
    //  성적 알림용: 과목 기본 정보 조회
    Course selectCourseBasicById(@Param("courseId") Long courseId);

    //  학생이 신청 가능한 강의 목록
    List<Course> selectOpenCoursesForRegister(
            @Param("studentId") Long studentId,
            @Param("year") Integer year,
            @Param("semester") String semester
    );

    //  학생이 이미 신청한 강의 목록
    List<Course> selectMyRegisteredCourses(
            @Param("studentId") Long studentId,
            @Param("year") Integer year,
            @Param("semester") String semester
    );

    //  수강신청 INSERT
    int insertCourseRegistration(CourseRegistration reg);

    //  수강취소 (status 변경 or 삭제)
    int cancelCourseRegistration(
            @Param("studentId") Long studentId,
            @Param("courseId") Long courseId
    );

    //  제한 룰 체크용
    int countRegisteredCoursesInSemester(
            @Param("studentId") Long studentId,
            @Param("year") Integer year,
            @Param("semester") String semester
    );

    int countEnrolledStudentsInCourse(@Param("courseId") Long courseId);
    
    int countTimeConflict(@Param("studentId") Long studentId,
            @Param("courseId") Long courseId);
    
    int countAlreadyRegistered(
            @Param("studentId") Long studentId,
            @Param("courseId") Long courseId
    );
    
    // 예상시간표
    List<WeeklyTimetableSlot> selectWeeklyTimetableByStudent(
            @Param("studentId") Long studentId,
            @Param("year") Integer year,
            @Param("semester") String semester
    );
    
 // 주간 시간표(현재 수강 + 미리보기 과목 포함)
    List<CourseTimeSlot> selectWeeklyTimetable(
            @Param("studentId") Long studentId,
            @Param("previewCourseId") Long previewCourseId
    );
}
