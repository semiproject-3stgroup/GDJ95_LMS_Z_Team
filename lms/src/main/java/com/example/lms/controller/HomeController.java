package com.example.lms.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.lms.dto.BoardNotice;
import com.example.lms.dto.EnrolledCourseSummary;
import com.example.lms.dto.Event;
import com.example.lms.dto.User;
import com.example.lms.service.BoardNoticeService;
import com.example.lms.service.CourseService;
import com.example.lms.service.EventService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class HomeController {
	
	@Autowired
	private CourseService courseService;
	
	@Autowired
	private EventService eventService;
	
    @Autowired
    private BoardNoticeService boardNoticeService;

	@GetMapping("/access-denied")
	public String accessDenied() {
	    return "error/accessDenied";  // /WEB-INF/views/error/accessDenied.jsp
	}

	@GetMapping({"/", "/home"})
	public String home(HttpSession session, Model model) {

	    // 1) 최신 공지 5건
	    List<BoardNotice> recentNotices = boardNoticeService.getRecentNotices(5);
	    model.addAttribute("recentNotices", recentNotices);

	    // 2) 다가오는 일정 5개
	    List<Event> upcoming = eventService.getUpcomingEvents(5);
	    model.addAttribute("upcoming", upcoming);

	    // 3) 수강 중인 강의 요약 (학생일 때만)
	    User loginUser = (User) session.getAttribute("loginUser");

	    if (loginUser != null && "STUDENT".equals(loginUser.getRole())) {

	        Long studentId = loginUser.getUserId();
	        log.debug("### [HomeController] 로그인 학생 user_id = {}", studentId);

	        List<EnrolledCourseSummary> enrolledCourses =
	                courseService.getEnrolledCoursesForHome(studentId, 5);

	        if (enrolledCourses == null) {
	            log.debug("### [HomeController] enrolledCourses = null");
	        } else {
	            log.debug("### [HomeController] enrolledCourses size = {}", enrolledCourses.size());
	        }

	        model.addAttribute("enrolledCourses", enrolledCourses);

	    } else {
	        log.debug("### [HomeController] 학생이 아님 혹은 loginUser = null");
	    }

	    return "home";
	}
}