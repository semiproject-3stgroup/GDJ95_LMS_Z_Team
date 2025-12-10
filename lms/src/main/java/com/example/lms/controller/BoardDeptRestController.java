package com.example.lms.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.example.lms.dto.BoardDepartment;
import com.example.lms.dto.BoardDeptComment;
import com.example.lms.dto.User;
import com.example.lms.service.BoardDeptService;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;



@RestController
public class BoardDeptRestController {
	@Autowired
	BoardDeptService boardBeptService;
	
	@GetMapping("/rest/deptBoard")
	public Map<String, Object> BoardDepartment(
			@RequestParam(defaultValue = "1") int currentPage
			, @RequestParam(defaultValue = "10") int rowPerPage
			, HttpSession session) {
		
		User user = (User)session.getAttribute("loginUser");
		int departmentId = user.getDepartmentId();
		
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
	
	@PostMapping("/rest/uploadFile")
	public Map<String, Object> BoardFileTemp(
				@RequestParam("uploadFile") MultipartFile file
				, HttpSession session) {
		
		String path = session.getServletContext().getRealPath("/upload/");
		
		Map<String, Object> result = new HashMap<>();
		
		String tempFileId = boardBeptService.saveTempFile(file, path);
		
		result.put("success", true);
		result.put("tempFileId", tempFileId);
		
		return result;
	}
	
	@PostMapping("/rest/deleteFile")
	public Map<String, Object> deleteTempFile(
				@RequestParam("tempFileId") String tempFileId
				, HttpSession session) {
		
		String path = session.getServletContext().getRealPath("/upload/");
		Map<String, Object> result = new HashMap<>();
		
		boardBeptService.deleteTempFile(tempFileId, path);
		
		result.put("success", true);
		return result;
	}
	
	@GetMapping("/rest/comment")
	public List<BoardDeptComment> deptPostComment(int postId) {
		
		List<BoardDeptComment> comments = boardBeptService.selectDeptBoardPostComments(postId);
		return comments;				
	}
	
	@PostMapping("/rest/addComment")
	public String addDeptPostComment(BoardDeptComment boardDeptComment, HttpSession session) {
				
		User user = (User)session.getAttribute("loginUser");
		boardDeptComment.setUserId(user.getUserId());		
		
		boardBeptService.addDeptPostComment(boardDeptComment);
		
		return "success";
	}
	
	@GetMapping("/rest/removeComment")
	public String removeDeptPostComment(int commentId) {
		
		boardBeptService.removeDeptPostComment(commentId);
		
		return "success";
	}
}
