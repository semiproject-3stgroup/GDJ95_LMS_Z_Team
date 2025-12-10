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

import com.example.lms.dto.AttendanceDetail;
import com.example.lms.dto.Course;
import com.example.lms.dto.Score;
import com.example.lms.dto.User;
import com.example.lms.service.ScoreService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ScoreController {
	
	@Autowired
	ScoreService scoreService;

	@GetMapping("/profScoring")
	public String courseStudentList(@RequestParam int courseId, Model model) { 
		
		List<Map<String, Object>> list = scoreService.courseStudentList(courseId);
        Course course = scoreService.getCourseBasic(courseId);
		
		model.addAttribute("list", list);
        model.addAttribute("course", course);
        model.addAttribute("courseId", courseId);
		
		return "score/profScoring";
	}
	
	@GetMapping("/profScoringOne")
	public String courseStudentScoringOne(int courseId, int userId, String userName, Model model) {						
		
		Score score = scoreService.selectStudentScore(userId, courseId);
		
		model.addAttribute("score", score);
		model.addAttribute("userName", userName);
		model.addAttribute("courseId", courseId);
		model.addAttribute("userId", userId);
		
		return "score/profScoringOne";
	}
	
	@PostMapping("/profSaveScore")
	public String courseStudentScoreSave(Score score) {
		
		scoreService.courseStudentScoreSave(score);
		
		return "redirect:/profScoring?courseId="+score.getCourseId();
	}
	
	@GetMapping("/profAttendance")
	public String courseStudentAttendance(@RequestParam int courseId, Model model) {
		List<Map<String, Object>> list = scoreService.courseStudentList(courseId);
		List<Map<String, Object>> attendance = scoreService.courseStudentAttendanceStatusList(courseId);
        Course course = scoreService.getCourseBasic(courseId);
		
		model.addAttribute("attendance", attendance);
		model.addAttribute("list", list);
		model.addAttribute("courseId", courseId);
        model.addAttribute("course", course);
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
	        @RequestParam("userIdList") List<Integer> userIds,
	        @RequestParam("statusList") List<Integer> statusList,
	        String date,
	        int courseId) {

	    scoreService.saveAttendance(userIds, statusList, date, courseId);
	    return "redirect:/profAttendance?courseId=" + courseId;
	}
	
	/**
	 * 교수용 : 특정 수강생 일자별 출결 상세
	 */
	@GetMapping("/profAttendanceDetail")
	public String profAttendanceDetail(@RequestParam int courseId,
	                                   @RequestParam long userId,
	                                   @RequestParam String userName,
	                                   @RequestParam String studentNo,
	                                   Model model) {

	    Course course = scoreService.getCourseBasic(courseId);
	    List<AttendanceDetail> history = scoreService.getAttendanceHistory(courseId, userId);

	    model.addAttribute("course", course);
	    model.addAttribute("history", history);
	    model.addAttribute("userName", userName);
	    model.addAttribute("studentNo", studentNo);

	    return "score/attendanceDetail";
	}

	/**
	 * 학생용 : 본인 일자별 출결 상세
	 */
	@GetMapping("/stuAttendanceDetail")
	public String stuAttendanceDetail(@RequestParam int courseId,
	                                  HttpSession session,
	                                  Model model) {

	    User loginUser = (User) session.getAttribute("loginUser");
	    if (loginUser == null) {
	        return "redirect:/login";
	    }

	    long userId = loginUser.getUserId();
	    Course course = scoreService.getCourseBasic(courseId);
	    List<AttendanceDetail> history = scoreService.getAttendanceHistory(courseId, userId);

	    model.addAttribute("course", course);
	    model.addAttribute("history", history);
	    model.addAttribute("userName", loginUser.getUserName());
	    model.addAttribute("studentNo", loginUser.getStudentNo());

	    return "score/attendanceDetail";
	}
}
