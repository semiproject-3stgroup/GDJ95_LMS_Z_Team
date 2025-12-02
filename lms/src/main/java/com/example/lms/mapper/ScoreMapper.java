package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.ScoreRecord;

@Mapper
public interface ScoreMapper {

    List<ScoreRecord> selectStudentScores(@Param("userId") Long userId);

}
