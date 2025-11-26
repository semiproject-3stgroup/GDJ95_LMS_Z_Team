package com.example.lms.controller;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.lms.service.BoardDeptService;
import com.example.lms.dto.BoardDepartment;

@Controller
public class BoardDeptController {
	@Autowired
	BoardDeptService boardDeptService;
	
	@GetMapping("/deptBoard")
	public String BoardDepartment(
			Model model
			, @RequestParam(defaultValue = "1") int currentPage
			, @RequestParam(defaultValue = "10") int rowPerPage
			, @RequestParam(defaultValue = "1") int departmentId) {
		
		List<BoardDepartment> list = boardDeptService.getDeptBoardList(currentPage, rowPerPage, departmentId);
		int lastPage = boardDeptService.cntDeptBoardListPage(departmentId, rowPerPage);		
		int beginPage = ((currentPage-1)/10)*10+1;
		int endPage = beginPage + 9;
		if(lastPage<endPage) endPage = lastPage;
				
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("beginPage", beginPage);
		model.addAttribute("endPage", endPage);
		model.addAttribute("list", list);		
		
		return "deptBoard";
	}
}
