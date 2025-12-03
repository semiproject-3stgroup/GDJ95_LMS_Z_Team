package com.example.lms.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.lms.dto.Assignment;
import com.example.lms.dto.AssignmentSubmit;
import com.example.lms.dto.Course;
import com.example.lms.dto.User;
import com.example.lms.service.AssignmentService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AssignmentController {
	
	@Autowired
	AssignmentService assignmentService;
	
	// ======================== 교수 ============================
	
	// 교수 강의, 과제
	@GetMapping("/profAssignment")
	public String profAssignment(Model model, HttpSession session) {
		
		User user = (User)session.getAttribute("loginUser");
		
		List<Course> course = assignmentService.courseListByProf(user.getUserId());
		List<Map<String, Object>> list = assignmentService.courseListWithAssignment(user.getUserId());						
		model.addAttribute("list", list);
		model.addAttribute("course", course);
						
		return "assignment/profAssignment";
	}
	
	@GetMapping("/profAssignmentAdd")
	public String profAssignmentAdd(Model model, HttpSession session) {
		
		User user = (User)session.getAttribute("loginUser");
		
		List<Course> course = assignmentService.courseListByProf(user.getUserId());
		model.addAttribute("course", course);
		
		return "assignment/profAssignmentAdd";
	}
	
	@PostMapping("/profAssignmentAddActioin")
	public String profAssignmentAddActioin(Assignment assignment) {
		
		assignmentService.addAssignment(assignment);
		
		
		return "redirect:/profprofAssignment";
	}
		
	@PostMapping("/profAssignmentRemove")
	public String profAssignmentRemove(int assignmentId) {
		
		assignmentService.removeAssignment(assignmentId);
						
		return "redirect:/profAssignment";
	}
	
	@GetMapping("/profAssignmentModify")
	public String profAssignmentModify(int assignmentId, Model model) {
		
		Assignment assignment = assignmentService.assignmentOne(assignmentId);
		
		LocalDate startdate = LocalDate.parse(assignment.getStartdate().substring(0, 10)); 
		LocalDate enddate = LocalDate.parse(assignment.getEnddate().substring(0, 10));		
		 						
		model.addAttribute("assignment", assignment);
		model.addAttribute("startdate", startdate);
		model.addAttribute("enddate", enddate);
		return "assignment/profAssignmentModify";
	}
	
	@PostMapping("/profAssignmentModify")
	public String profAssignmentModifyAction(Assignment assignment) {
		
		assignmentService.modifyAssignment(assignment);
		
		return "redirect:/profAssignmentOne?assignmentId="+assignment.getAssignmentId();
	}
	
	@GetMapping("/profAssignmentOne")
	public String profAssignmentOne(Model model, int assignmentId, HttpSession session) {
		
		User user = (User)session.getAttribute("loginUser");
		Assignment assignment = assignmentService.assignmentOne(assignmentId);
		
		log.debug(assignment+"");
		
		Map<String, Object> course = assignmentService.courseOne((long)assignment.getCourseId());

		model.addAttribute("userId", user.getUserId());
		model.addAttribute("assignment", assignment);
		model.addAttribute("course", course);
		
		return "assignment/profAssignmentOne";
	}
	
	
	// ======================== 학생 ============================
	
	@GetMapping("/stuAssignmentOne")
	public String stuAssignmentOne(Model model, int assignmentId, HttpSession session) {
		
		User user = (User)session.getAttribute("loginUser");
		Assignment assignment = assignmentService.assignmentOne(assignmentId);
		
		log.debug(assignment+"");
		
		Map<String, Object> course = assignmentService.courseOne(assignment.getCourseId());
		AssignmentSubmit assignmentSubmit = assignmentService.assignmentOneSubmit(user.getUserId(), assignmentId);
		
		
		model.addAttribute("userId", user.getUserId());
		model.addAttribute("assignment", assignment);
		model.addAttribute("course", course);
		model.addAttribute("assignmentSubmit", assignmentSubmit);
		
		return "assignment/stuAssignmentOne";
	}
	
	
	@GetMapping("/stuAssignment")
	public String stuAssignment(HttpSession session, Model model) {
		
		User user = (User)session.getAttribute("loginUser");
		List<Map<String, Object>> list = assignmentService.courseListByStudent(user.getUserId());
		List<Map<String, Object>> assign = assignmentService.assignmentListByStudent(user.getUserId());				
		
		model.addAttribute("list", list);
		model.addAttribute("assign", assign);		
		
		return "assignment/stuAssignment";
	} 		
}
