package com.example.lms.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.lms.dto.BoardDepartment;
import com.example.lms.mapper.BoardDeptMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class BoardDeptService {
	@Autowired
	BoardDeptMapper boardDeptMapper;
	
	public List<BoardDepartment> getDeptBoardList(
			@Param("currentPage") int currentPage
			,@Param("rowPerPage") int rowPerPage
			,@Param("departmentId") int departmentId) {
				
		int startRow = (currentPage-1)*rowPerPage;								 
						
		return boardDeptMapper.selectBoardDeptListRowPerPage(departmentId, startRow, rowPerPage);
	}
	
	public int cntDeptBoardListPage(int departmentId, int rowPerPage) {
		
		return (boardDeptMapper.selectCountBoardDeptList(departmentId)+rowPerPage-1)/rowPerPage;
	}
	
	
	
}
