package com.example.lms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.lms.service.ScoreService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ScoreController {
	
	@Autowired
	ScoreService scoreService;

	@GetMapping("")
	public String courseStudentList(int courseId) { 
		
		
		
		
		
		return "score/profScoring";
	}
	
}
