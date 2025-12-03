package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.MyCalendarEvent;

@Mapper
public interface MyCalendarMapper {

    // 학생용: 내가 수강 중인 강의 일정 + 과제 마감
    List<MyCalendarEvent> selectStudentCalendarEvents(Map<String, Object> param);

    // 교수용: 내가 담당하는 강의 일정 + 과제 마감
    List<MyCalendarEvent> selectProfessorCalendarEvents(Map<String, Object> param);
}
