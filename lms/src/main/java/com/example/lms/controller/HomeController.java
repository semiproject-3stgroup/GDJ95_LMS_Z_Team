package com.example.lms.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.lms.dto.Event;
import com.example.lms.dto.BoardNotice;
import com.example.lms.service.EventService;
import com.example.lms.service.BoardNoticeService;

@Controller
public class HomeController {
	
	@Autowired
	private EventService eventService;
	
    @Autowired
    private BoardNoticeService boardNoticeService;

	@GetMapping("/access-denied")
	public String accessDenied() {
	    return "error/accessDenied";  // /WEB-INF/views/error/accessDenied.jsp
	}

	 @GetMapping({"/", "/home"})
	    public String home(Model model) {
		 
		 	//  최신 공지 5건
	        List<BoardNotice> recentNotices = boardNoticeService.getRecentNotices(5);
	        model.addAttribute("recentNotices", recentNotices);


	    	// 다가오는 일정 5개 조회
	    	List<Event> upcoming = eventService.getUpcomingEvents(5);
	    	model.addAttribute("upcoming", upcoming);

	        // 나중에 메인에 넘길 데이터 있으면 Model 써서 넘기기
	        return "home";
	    }
	}