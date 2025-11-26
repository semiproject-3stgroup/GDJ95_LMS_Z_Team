package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.BoardDepartment;

@Mapper
public interface BoardDeptMapper {
	List<BoardDepartment> selectBoardDeptListRowPerPage(int departmentId, int startRow, int rowPerPage);	
}
