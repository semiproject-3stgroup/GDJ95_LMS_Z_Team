package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.Event;

@Mapper
public interface EventMapper {

    List<Event> selectEventList();    // 전체 학사 일정

    List<Event> selectUpcomingEvents(int limit); // 다가오는 일정 (메인용)

    Event selectEventOne(Long eventId); // 상세 조회

    int insertEvent(Event event);   // 등록

    int updateEvent(Event event);   // 수정

    int deleteEvent(Long eventId);  // 삭제
}
