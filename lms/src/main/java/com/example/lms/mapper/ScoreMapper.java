package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.ScoreRecord;

@Mapper
public interface ScoreMapper {

    List<ScoreRecord> selectStudentScores(@Param("userId") Long userId);
    
    // 출석부 호출
    List<Map<String, Object>> selectTodayAttendance(Map<String, Object> map);
    // 출석부 저장
    int insertAttedance(Map<String, Object> map);
    // 출석부 수정
    int updateAttendace(Map<String, Object> map);
    // 출석 현황
    List<Map<String, Object>> selectAttendanceStatus(int courseId);
}
