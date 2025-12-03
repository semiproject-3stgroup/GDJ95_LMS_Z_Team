package com.example.lms.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.Event;
import com.example.lms.dto.MyCalendarEvent;
import com.example.lms.dto.User;
import com.example.lms.mapper.EventMapper;
import com.example.lms.mapper.MyCalendarMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MyCalendarServiceImpl implements MyCalendarService {

    @Autowired
    private MyCalendarMapper myCalendarMapper;

    @Autowired
    private EventMapper eventMapper;   // 학사일정용

    @Override
    public List<MyCalendarEvent> getMyCalendarEvents(User loginUser,
                                                     LocalDateTime start,
                                                     LocalDateTime end) {

        if (loginUser == null) {
            throw new IllegalStateException("로그인 정보가 없습니다.");
        }

        Map<String, Object> param = new HashMap<>();
        param.put("userId", loginUser.getUserId());
        param.put("start", start);
        param.put("end", end);

        List<MyCalendarEvent> result = new ArrayList<>();

        // 1) 내 수업 / 과제 일정 (학생/교수 분기)
        switch (loginUser.getRole()) {
            case "STUDENT":
                result.addAll(myCalendarMapper.selectStudentCalendarEvents(param));
                break;
            case "PROF":
                result.addAll(myCalendarMapper.selectProfessorCalendarEvents(param));
                break;
            default:
                // 필요하면 ADMIN 처리 추가
                break;
        }

        // 2) 학사 일정(events)도 같이 가져와서 합치기 (공통)
        List<Event> academicList = eventMapper.selectEventsBetween(start, end);

        for (Event e : academicList) {
            MyCalendarEvent mc = new MyCalendarEvent();
            mc.setEventId(e.getEventId());
            mc.setCourseId(null);
            mc.setCourseName(null);
            mc.setTitle("[학사] " + e.getEventName());
            mc.setStart(e.getEventFromdate());
            mc.setEnd(e.getEventTodate());
            mc.setType("SCHOOL");           // 구분용 타입
            mc.setBackgroundColor("#0f766e");

            result.add(mc);
        }

        // 3) 시작시간 기준 정렬
        result.sort(Comparator.comparing(MyCalendarEvent::getStart));

        log.debug("MyCalendar events size (with academic) = {}", result.size());
        return result;
    }
}
