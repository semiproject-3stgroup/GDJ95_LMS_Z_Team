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
import com.example.lms.dto.User;
import com.example.lms.service.EventService;

import jakarta.servlet.http.HttpSession;

@Controller
public class CalendarController {

    @Autowired
    private EventService eventService;

    /**
     * 캘린더
     * - 비로그인: 학사 캘린더
     * - 학생: 내 강의/과제 + 학사 통합 캘린더
     * - 교수: 교수용 캘린더
     */
    @GetMapping("/calendar")
    public String calendarRoot(HttpSession session) {

        User loginUser = (User) session.getAttribute("loginUser");

        // 비로그인 → 학사 일정만 보는 캘린더
        if (loginUser == null) {
            return "redirect:/calendar/academic";
        }

        // 교수 → 교수용 캘린더
        if ("PROF".equals(loginUser.getRole())) {
            return "redirect:/calendar/prof";
        }

        // 그 외(학생, 필요하면 ADMIN도 같이) → 내 캘린더
        return "redirect:/calendar/my";
    }

    /**
     * 학사 일정 캘린더 
     */
    @GetMapping("/calendar/academic")
    public String academicCalendar() {
        // 일정은 AJAX로 불러옴
        return "calendar/academicCalendar";
    }

    /**
     * FullCalendar용 학사 일정 JSON
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
     * 학사 일정 상세 화면
     */
    @GetMapping("/calendar/academic/{eventId}")
    public String academicDetail(@PathVariable("eventId") Long eventId,
                                 Model model) {
        Event event = eventService.getEvent(eventId);
        model.addAttribute("event", event);
        return "calendar/academicDetail";
    }
}
