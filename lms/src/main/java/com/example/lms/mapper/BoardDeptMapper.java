package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.BoardDepartment;

@Mapper
public interface BoardDeptMapper {
	
	// 학과 페이지 목록
	List<BoardDepartment> selectBoardDeptListRowPerPage(int departmentId, int startRow, int rowPerPage);
	
	// 학과 페이지 갯수
	int selectCountBoardDeptList(int departmentId);
}
