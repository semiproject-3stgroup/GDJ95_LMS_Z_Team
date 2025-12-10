package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.BoardDepartment;
import com.example.lms.dto.BoardDepartmentFile;
import com.example.lms.dto.BoardDeptComment;

@Mapper
public interface BoardDeptMapper {
	
	// 학과 페이지 목록
	List<BoardDepartment> selectBoardDeptListRowPerPage(int departmentId, int startRow, int rowPerPage);
	
	// 학과 페이지 갯수
	int selectCountBoardDeptList(int departmentId);
	
	// 학과 페이지 글추가
	int insertBoardDept(BoardDepartment boardDept);
	int insertBoardDeptFile(BoardDepartmentFile boardDeptFile);
	
	// 학과 게시물 상세 + 첨부파일 가져오기
	Map<String, Object> selectBaordDeptPost(int postId);
	List<BoardDepartmentFile> selectBoardDeptPostFileList(int postId);
	
	// 학과 게시물 삭제
	int deleteBoardDeptPost(int postId);
	int deleteBoardDeptPostFile(int postId);
	
	// 학과 게시물 수정
	BoardDepartmentFile selectBoardDeptPostFile(int fileId);
	int updateBaordDeptPost(BoardDepartment boardDept);
	int deleteBoardDeptUploadedFile(int fileId);
	
	// 학과 게시물 댓글
	List<BoardDeptComment> selectBoardDeptComment(int postId);	
	int insertBoardDeptComment(BoardDeptComment boardDeptComment);
	int deleteBoardDeptComment(int commentId);
}
