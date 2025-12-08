package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.ScoreRecord;

@Mapper
public interface ScoreMapper {

    List<ScoreRecord> selectStudentScores(@Param("userId") Long userId);
    
    // [권순표]알림 기능을 위한 메서드 추가
    int upsertStudentScore(ScoreRecord scoreRecord);

}
