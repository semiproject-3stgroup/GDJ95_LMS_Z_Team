package com.example.lms.controller;

import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.lms.dto.MyCalendarEvent;
import com.example.lms.dto.User;
import com.example.lms.service.MyCalendarService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MyCalendarController {

    @Autowired
    private MyCalendarService myCalendarService;

    // ================= 학생용 화면 =================

    @GetMapping("/calendar/my")
    public String myCalendarPage(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        model.addAttribute("loginUser", loginUser);
        return "calendar/my_calendar";
    }

    @GetMapping("/api/calendar/my-events")
    @ResponseBody
    public List<MyCalendarEvent> myCalendarEvents(
            @RequestParam(value = "start", required = false) String startStr,
            @RequestParam(value = "end",   required = false) String endStr,
            HttpSession session) {

        log.debug("my-events startStr={}, endStr={}", startStr, endStr);

        if (startStr == null || startStr.isBlank()
                || endStr == null || endStr.isBlank()) {
            log.warn("FullCalendar에서 빈 리스트 반환");
            return List.of();
        }

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            throw new IllegalStateException("로그인 정보가 없습니다.");
        }

        LocalDateTime start = OffsetDateTime.parse(startStr).toLocalDateTime();
        LocalDateTime end   = OffsetDateTime.parse(endStr).toLocalDateTime();

        return myCalendarService.getMyCalendarEvents(loginUser, start, end);
    }

    // ================= 교수용 화면 =================

    @GetMapping("/calendar/prof")
    public String professorCalendar(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            return "redirect:/login";
        }

        if (!"PROF".equals(loginUser.getRole())) {
            return "redirect:/home";
        }

        model.addAttribute("loginUser", loginUser);
        return "calendar/my_calendar_prof";
    }

    // 교수 - FullCalendar 이벤트용 JSON API
    @GetMapping("/api/calendar/prof-events")
    @ResponseBody
    public List<MyCalendarEvent> getProfessorEvents(
            @RequestParam("start") String startStr,
            @RequestParam("end") String endStr,
            HttpSession session) {

        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null || !"PROF".equals(loginUser.getRole())) {
            throw new IllegalStateException("교수 계정만 접근 가능합니다.");
        }

        // 문자열 LocalDateTime으로 변환
        LocalDateTime start = OffsetDateTime.parse(startStr).toLocalDateTime();
        LocalDateTime end   = OffsetDateTime.parse(endStr).toLocalDateTime();

        // 교수 계정도 공통 메서드 사용
        return myCalendarService.getMyCalendarEvents(loginUser, start, end);
    }
}
