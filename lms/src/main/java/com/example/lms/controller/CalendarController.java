package com.example.lms.controller;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.lms.dto.Event;
import com.example.lms.service.EventService;

@Controller
public class CalendarController {

    @Autowired
    private EventService eventService;

    /**
     * 학사 일정 캘린더 화면
     */
    @GetMapping("/calendar/academic")
    public String academicCalendar() {
        // 일정 JS에서 AJAX로 불러오기
        return "calendar/academicCalendar";
    }

    /**
     * FullCalendar용 학사 일정 JSON
     * id / title / start / end 형식으로 내려줌
     */
    @GetMapping("/api/calendar/events")
    @ResponseBody
    public List<Map<String, Object>> academicEventsJson() {

        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");

        List<Event> list = eventService.getEventList();
        List<Map<String, Object>> result = new ArrayList<>();

        for (Event e : list) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", e.getEventId());
            map.put("title", e.getEventName());
            map.put("start", e.getEventFromdate().format(fmt));
            map.put("end", e.getEventTodate().format(fmt));

            Map<String, Object> ext = new HashMap<>();
            ext.put("description", e.getEventContext());
            map.put("extendedProps", ext);

            result.add(map);
        }
        return result;
    }

    /**
     * 일정 상세 화면
     */
    @GetMapping("/calendar/academic/{eventId}")
    public String academicDetail(@PathVariable("eventId") Long eventId,
                                 Model model) {
        Event event = eventService.getEvent(eventId); // 단건 조회 메서드 이미 있을 거라 가정
        model.addAttribute("event", event);
        return "calendar/academicDetail";
    }
}
