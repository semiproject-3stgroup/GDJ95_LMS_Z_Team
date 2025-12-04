package com.example.lms.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
    
    // ✅ 메인페이지용 다가오는 일정 요약
    @Override
    public List<MyCalendarEvent> getUpcomingMyAndSchoolEvents(User loginUser, int limit) {

        if (loginUser == null) {
            throw new IllegalStateException("로그인 정보가 없습니다.");
        }

        // 지금 시점 기준 ~ 1개월 정도만 조회 (원하면 주 단위로 바꿔도 됨)
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime end = now.plusMonths(1);

        // 기존 메서드 재사용 (학사+내 일정 통합 로직 있음)
        List<MyCalendarEvent> all = getMyCalendarEvents(loginUser, now, end);

        // 혹시 모를 과거 데이터 필터 + 정렬 + limit
        List<MyCalendarEvent> upcoming = all.stream()
        		.filter(e -> e.getStart() != null)
                .filter(e -> !e.getStart().isBefore(now))          // 과거 제외
                .filter(e -> !"ASSIGNMENT".equals(e.getType()))    // 과제 제외(다가오는 일정에 중복으로 안보이게)
                .sorted(Comparator.comparing(MyCalendarEvent::getStart))
                .limit(limit)
                .collect(Collectors.toList());

        log.debug("Upcoming my+school events (limit {}): {}", limit, upcoming.size());

        return upcoming;
    }
}
