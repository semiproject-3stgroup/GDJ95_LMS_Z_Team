package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.BoardDepartment;
import com.example.lms.dto.BoardDepartmentFile;

@Mapper
public interface BoardDeptMapper {
	
	// 학과 페이지 목록
	List<BoardDepartment> selectBoardDeptListRowPerPage(int departmentId, int startRow, int rowPerPage);
	
	// 학과 페이지 갯수
	int selectCountBoardDeptList(int departmentId);
	
	// 학과 페이지 글추가
	int insertBoardDept(BoardDepartment boardDept);
	int insertBoardDeptFile(BoardDepartmentFile boardDeptFile);
}
