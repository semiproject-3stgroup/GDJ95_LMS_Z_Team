package com.example.lms.controller;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.lms.service.BoardDeptService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

import com.example.lms.dto.BoardDepartment;
import com.example.lms.dto.BoardDepartmentForm;
import com.example.lms.dto.User;

@Slf4j
@Controller
public class BoardDeptController {
	@Autowired
	BoardDeptService boardDeptService;

	// 학과게시판 목록
	@GetMapping("/deptBoard")
	public String BoardDepartment() {
		
		return "deptBoard/deptBoard";
	}
	
	// 학과게시판 글 상세
	@GetMapping("/deptBoardOne")
	public String BoardDepartmentOne(Model model, HttpSession session, int postId) {
		
		User user = (User)session.getAttribute("loginUser");
		
		Map<String, Object> one = boardDeptService.getDeptBoardPost(postId); // Map(제목,내용,카테고리,작성자,id) List(첨부파일)
		log.debug(one+"");
		
		model.addAttribute("userId", user.getUserId());
		model.addAttribute("one", one);
		
		return "deptBoard/deptBoardOne";
	}
	
	// 학과게시판 글 삭제
	@GetMapping("/deptBoardRemove")
	public String BoardDepartmentRemove(HttpSession session, int postId) {
						
		String path = session.getServletContext().getRealPath("/upload/");
				
		boardDeptService.removeDeptBoardPost(postId, path);	
				
		return "redirect:/deptBoard";
	}
			
	// 학과게시판 글 수정 폼
	@GetMapping("/deptBoardModify")
	public String BoardDepartmentModify(Model model, int postId) {
		
		Map<String, Object> one = boardDeptService.getDeptBoardPost(postId); 
		
		model.addAttribute("one", one);
		
		return "deptBoard/deptBoardModify";
	}
	
	// 학과게시판 글 수정 액션
	@PostMapping("/deptBoardModify")
	public String BoardDepartmentModify(BoardDepartment boardDepartment
							, @RequestParam(required=false) List<String> uploadedFileIds
							, @RequestParam(required=false) List<String> uploadedFileNames
							, @RequestParam(required=false) List<Integer> deletedFileIds
							, HttpSession session) {
		
		log.debug("=============================="+deletedFileIds+"deletedFileIds");
		log.debug("=============================="+boardDepartment+"boardDepartment");
		String path = session.getServletContext().getRealPath("/upload/");
		if(deletedFileIds!=null) {
			deletedFileIds.forEach(i->boardDeptService.removeDeptBoardUploadedFile(i, path)); // 게시물 수정(첨부파일 삭제)
		}
		boardDeptService.saveDeptBoardFile(boardDepartment, uploadedFileIds, uploadedFileNames, path); // 게시물 수정(첨부파일 추가 및 DB 등록)
		
		return "redirect:/deptBoardOne?postId="+boardDepartment.getPostId();
	}
	
	// 학과게시판 글쓰기 폼
	@GetMapping("/deptBoardAdd")
	public String BoardDepartmentAdd() {						
		return "deptBoard/deptBoardAdd";
	}
	
	// 학과게시판 글쓰기 액션
	@PostMapping("/deptBoardAdd")
	public String boardDepartmentAdd(BoardDepartmentForm bf, HttpSession session) {

		String path = session.getServletContext().getRealPath("/upload/");
		
		int departmentId = 1;
		int userId = 7;
		
		bf.setDepartmentId(departmentId);
		bf.setUserId(userId);
		
		boardDeptService.addDeptBoard(bf, path);
		
		return "deptBoard/deptBoard";
	}	
}
