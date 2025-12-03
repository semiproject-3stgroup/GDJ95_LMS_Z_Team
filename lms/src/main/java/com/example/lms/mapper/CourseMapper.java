package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.EnrolledCourseSummary;

@Mapper
public interface CourseMapper {

    // 메인페이지: 로그인한 학생의 수강 중 강의 요약 리스트
    List<EnrolledCourseSummary> selectEnrolledCoursesForHome(
            @Param("studentId") Long studentId,
            @Param("limit") int limit
    );
}
