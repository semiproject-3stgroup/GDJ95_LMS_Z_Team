package com.example.lms.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

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
	// 교수 강의, 과제
	@GetMapping("/profAssignment")
	public String profAssignment(
	        Model model,
	        HttpSession session,
	        @RequestParam(required = false) Long courseId   // ⭐ 추가
	) {

	    User user = (User) session.getAttribute("loginUser");

	    List<Course> course = assignmentService.courseListByProf(user.getUserId());
	    List<Map<String, Object>> list = assignmentService.courseListWithAssignment(user.getUserId());

	    model.addAttribute("list", list);
	    model.addAttribute("course", course);

	    // 어떤 강의에서 들어왔는지(필터용) 넘겨주기
	    model.addAttribute("selectedCourseId", courseId);

	    return "assignment/profAssignment";
	}
	
	// 과제 추가
	@GetMapping("/profAssignmentAdd")
	public String profAssignmentAdd(Model model, HttpSession session) {
		
		User user = (User)session.getAttribute("loginUser");
		
		List<Course> course = assignmentService.courseListByProf(user.getUserId());
		model.addAttribute("course", course);
		
		return "assignment/profAssignmentAdd";
	}
	// 과제 추가 액션
	@PostMapping("/profAssignmentAddActioin")
	public String profAssignmentAddActioin(Assignment assignment) {
		
		assignmentService.addAssignment(assignment);
		
		
		return "redirect:/profAssignment";
	}
	// 과제 삭제
	@PostMapping("/profAssignmentRemove")
	public String profAssignmentRemove(int assignmentId) {
		
		assignmentService.removeAssignment(assignmentId);
						
		return "redirect:/profAssignment";
	}
	// 과제 수정
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
	// 과제 수정
	@PostMapping("/profAssignmentModify")
	public String profAssignmentModifyAction(Assignment assignment) {
		
		assignmentService.modifyAssignment(assignment);
		
		return "redirect:/profAssignmentOne?assignmentId="+assignment.getAssignmentId();
	}
	// 과제 상세
	@GetMapping("/profAssignmentOne")
	public String profAssignmentOne(Model model, int assignmentId, HttpSession session) {
		
		User user = (User)session.getAttribute("loginUser");
		Assignment assignment = assignmentService.assignmentOne(assignmentId);
		
		log.debug(assignment+"");
		
		Map<String, Object> course = assignmentService.courseOne(assignment.getCourseId());
		List<Map<String, Object>> students = assignmentService.courseStudentsSubmitList(assignment.getCourseId(), assignmentId);
		
		boolean isDateOver = assignmentService.isDateOver(assignment);										
		
		LocalDateTime end = assignmentService.toDate(assignment.getEnddate().toString());						
		for(Map<String, Object> m : students) {

			boolean isLate = false;
			
			if(m.get("file")!=null) {
				String dateStr;
				if(m.get("updatedate")!=null) {
					dateStr = m.get("updatedate").toString();										
				} else {
					dateStr = m.get("createdate").toString();
				}
				
				isLate = assignmentService.toDate(dateStr).isAfter(end);
			}
			
			m.put("isLate", isLate);
		}
					
		log.debug(students+"#############################################");
		
		model.addAttribute("isDateOver", isDateOver);
		model.addAttribute("userId", user.getUserId());
		model.addAttribute("assignment", assignment);
		model.addAttribute("course", course);
		model.addAttribute("students", students);
		
		return "assignment/profAssignmentOne";
	}
	
	@PostMapping("/rest/assignmentScore")
	@ResponseBody
	public String profAssignmentScore(AssignmentSubmit submit) {
		log.debug(submit+"=================================여기에요");
		assignmentService.assignmentScoring(submit);		
		return "score";
	}
	
	
	// ======================== 학생 ============================
	// 과제 상세
	@GetMapping("/stuAssignmentOne")
	public String stuAssignmentOne(Model model, int assignmentId, HttpSession session) {
		
		User user = (User)session.getAttribute("loginUser");
		Assignment assignment = assignmentService.assignmentOne(assignmentId);
		
		log.debug(assignment+"");
		
		Map<String, Object> course = assignmentService.courseOne(assignment.getCourseId());
		AssignmentSubmit assignmentSubmit = assignmentService.assignmentOneSubmit(user.getUserId(), assignmentId);
		
		log.debug(assignmentSubmit+"");
				
		model.addAttribute("userId", user.getUserId());
		model.addAttribute("assignment", assignment);
		model.addAttribute("course", course);
		model.addAttribute("assignmentSubmit", assignmentSubmit);
		
		return "assignment/stuAssignmentOne";
	}
	
	// 과제 목록
	@GetMapping("/stuAssignment")
	public String stuAssignment(HttpSession session, Model model) {
		
		User user = (User)session.getAttribute("loginUser");
		List<Map<String, Object>> list = assignmentService.courseListByStudent(user.getUserId());
		List<Map<String, Object>> assign = assignmentService.assignmentListByStudent(user.getUserId());				
		
		model.addAttribute("list", list);
		model.addAttribute("assign", assign);		
		
		return "assignment/stuAssignment";
	} 
	
	// 과제 제출
	@PostMapping("/stuAssignmentSubmit")
	public String stuAssignmentSubmit(
				AssignmentSubmit submit
				, MultipartFile uploadFile
				, HttpSession session) {
		
		String path = session.getServletContext().getRealPath("/upload/");
		
		assignmentService.addAssignmentSubmit(submit, uploadFile, path);
				
		return "redirect:/stuAssignmentOne?assignmentId=" + submit.getAssignmentId();
	}
	// 과제 수정
	@PostMapping("/stuAssignmentModify")
	public String stuAssignmentSubmitModify(
				AssignmentSubmit submit
				, MultipartFile uploadFile
				, HttpSession session) {
		
		String path = session.getServletContext().getRealPath("/upload/");
		
		assignmentService.modifyAssignmentSubmit(submit, uploadFile, path);
		
		return "redirect:/stuAssignmentOne?assignmentId=" + submit.getAssignmentId();
	}
}
