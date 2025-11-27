package com.example.lms.service;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.lms.dto.BoardDepartment;
import com.example.lms.dto.BoardDepartmentFile;
import com.example.lms.dto.BoardDepartmentForm;
import com.example.lms.mapper.BoardDeptMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class BoardDeptService {
	@Autowired
	BoardDeptMapper boardDeptMapper;
	// 게시물 목록
	public List<BoardDepartment> getDeptBoardList(
			@Param("currentPage") int currentPage
			,@Param("rowPerPage") int rowPerPage
			,@Param("departmentId") int departmentId) {
				
		int startRow = (currentPage-1)*rowPerPage;								 
						
		return boardDeptMapper.selectBoardDeptListRowPerPage(departmentId, startRow, rowPerPage);
	}
	// 게시물 갯수
	public int cntDeptBoardListPage(int departmentId, int rowPerPage) {
		
		return (boardDeptMapper.selectCountBoardDeptList(departmentId)+rowPerPage-1)/rowPerPage;
	}
	// 게시물 추가
	public void addDeptBoard(BoardDepartmentForm bf, String path) {
		BoardDepartment boardDept = new BoardDepartment();
		boardDept.setDepartmentId(bf.getDepartmentId());
		boardDept.setUserId(bf.getUserId());
		boardDept.setCategory(bf.getCategory());
		boardDept.setTitle(bf.getTitle());
		boardDept.setContent(bf.getContent());
		
		int row1 = boardDeptMapper.insertBoardDept(boardDept);
		log.debug("row: " + row1);
		if(row1!=1) {
			throw new RuntimeException("학과 게시판 글등록 실패!");
		}
		
		if(bf.getBoardDeptFile().get(0).getSize() > 0 && !(bf.getBoardDeptFile().get(0).getOriginalFilename().equals(""))) {
			for(MultipartFile mf : bf.getBoardDeptFile()) {
				
				int idx = mf.getOriginalFilename().lastIndexOf(".");
				String extension = mf.getOriginalFilename().substring(idx+1);
				String originName = mf.getOriginalFilename().substring(0, idx);
				String fileName = UUID.randomUUID().toString().replace("-", "");
				
				BoardDepartmentFile boardDeptFile = new BoardDepartmentFile();
				boardDeptFile.setPostId(boardDept.getPostId());
				boardDeptFile.setFileName(fileName);
				boardDeptFile.setOriginName(originName);
				boardDeptFile.setFileExtension(extension);
				boardDeptFile.setFileSize(mf.getSize());
				
				int row2 = boardDeptMapper.insertBoardDeptFile(boardDeptFile);
				
				if(row2!=1) {
					throw new RuntimeException("학과 게시판 파일 DB 업로드 실패!");
				}
				
				try {
					mf.transferTo(new File(path+fileName+"."+extension));
				} catch (Exception e) {
					throw new RuntimeException("학과 게시판 파일 업로드 실패!");
				}
			}
		}
	}
	
}
