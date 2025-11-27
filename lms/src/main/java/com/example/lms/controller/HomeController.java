package com.example.lms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
	
	@GetMapping("/access-denied")
	public String accessDenied() {
	    return "error/accessDenied";  // /WEB-INF/views/error/accessDenied.jsp
	}

    @GetMapping({"/", "/home"})
    public String home() {
        // 나중에 메인에 넘길 데이터 있으면 Model 써서 넘기기
        return "home";
    }
}