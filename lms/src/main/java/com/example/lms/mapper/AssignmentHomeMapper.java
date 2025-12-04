package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.HomeAssignmentSummary;

@Mapper
public interface AssignmentHomeMapper {

    /**
     * 메인페이지용: 학생이 아직 제출하지 않은 과제 중
     * 마감 임박 순 TOP 3
     */
    List<HomeAssignmentSummary> selectUpcomingAssignmentsForHome(@Param("userId") Long userId);

}
