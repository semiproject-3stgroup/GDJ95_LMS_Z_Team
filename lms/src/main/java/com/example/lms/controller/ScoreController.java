package com.example.lms.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.lms.service.ScoreService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ScoreController {
	
	@Autowired
	ScoreService scoreService;

	@GetMapping("/profScoring")
	public String courseStudentList(int courseId, Model model) { 
		
		List<Map<String, Object>> list = scoreService.courseStudentList(courseId);
		
		log.debug(list+"");
		
		model.addAttribute("list", list);
		
		return "score/profScoring";
	}
	
	@GetMapping("/profScoringOne")
	public String courseStudentScoringOne(int courseId, int userId) {
		
		
		return "score/profScoringOne";
	}
	
	@GetMapping("/profAttendance")
	public String courseStudentAttendance(int courseId, Model model) {
		List<Map<String, Object>> list = scoreService.courseStudentList(courseId);
		model.addAttribute("list", list);
		model.addAttribute("courseId", courseId);
		return "score/attendance";
	}
	
	@PostMapping("/rest/profAttendance")
	@ResponseBody
	public List<Map<String, Object>> courseStudentAttendanceDate(String date, int courseId) {
		
		List<Map<String, Object>> todayAtt =  scoreService.selectTodayAttendance(date, courseId);
		
		log.debug(todayAtt+"");
		
		return todayAtt;
	}
	
	@PostMapping("/profAttendanceSave")
	public String saveAttendance(
				@RequestParam("userIdList") List<Integer> userIds
				, @RequestParam("satusList") List<Integer> satusList
				, String date
				, int courseId) {
		
		scoreService.saveAttendance(userIds, satusList, date, courseId);		
		
		return "score/profAttendance?courseId="+courseId;
	}
	
}
