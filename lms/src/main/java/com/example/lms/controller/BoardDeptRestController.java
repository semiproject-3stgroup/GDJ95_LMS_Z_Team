package com.example.lms.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.example.lms.dto.BoardDepartment;
import com.example.lms.service.BoardDeptService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;



@RestController
public class BoardDeptRestController {
	@Autowired
	BoardDeptService boardBeptService;
	
	@GetMapping("/rest/deptBoard")
	public Map<String, Object> BoardDepartment(
			@RequestParam(defaultValue = "1") int currentPage
			, @RequestParam(defaultValue = "10") int rowPerPage
			, @RequestParam(defaultValue = "1") int departmentId) {
		
		List<BoardDepartment> list = boardBeptService.getDeptBoardList(currentPage, rowPerPage, departmentId);
		int lastPage = boardBeptService.cntDeptBoardListPage(departmentId, rowPerPage);		
		int beginPage = ((currentPage-1)/10)*10+1;
		int endPage = beginPage + 9;
		if(lastPage<endPage) endPage = lastPage;
				
		Map<String, Object> map = new HashMap<>();
		map.put("rowPerPage", rowPerPage);
		map.put("currentPage", currentPage);
		map.put("lastPage", lastPage);
		map.put("beginPage", beginPage);
		map.put("endPage", endPage);
		map.put("list", list);		
		
		return map;
			
	}
}
