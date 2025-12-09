package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.Score;
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

    // 수강생 성적 리스트
    List<Score> selectStudentsScore(int courseId);
    
    Score selectStudentScore(@Param("userId") int userId, @Param("courseId") int courseId);
        
    // [권순표]알림 기능을 위한 메서드 추가
    int upsertStudentScore(ScoreRecord scoreRecord);
    
    // [권순표] 성적 존재 여부 체크 (INSERT / UPDATE 구분용)
    int existsStudentScore(@Param("userId") Long userId,
            @Param("courseId") Long courseId);


}
