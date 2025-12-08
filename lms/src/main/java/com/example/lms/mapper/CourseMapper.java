package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.Course;
import com.example.lms.dto.EnrolledCourseSummary;

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
}
