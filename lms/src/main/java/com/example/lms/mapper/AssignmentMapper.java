package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.Assignment;
import com.example.lms.dto.AssignmentSubmit;
import com.example.lms.dto.Course;

@Mapper
public interface AssignmentMapper {
	// 강의 과제
	List<Map<String, Object>> selectCourseAndAssignmentByProf(Long userId);
	// 강의 목록(교수)
	List<Course> selectCourseByProf(Long userId);
	// 과제 등록
	int insertAssignmentByProf(Assignment assignment);
	// 과제 상세
	Assignment selectAssignmentOne(int assignmentId);
	// 과제 삭제
	int deleteAssignmentByProf(int assignmentId);
	// 강의 정보
	Map<String, Object> selectCourseByCourseId(Long courseId);
	// 과제 수정
	int updateAssignmentByProf(Assignment assignment);
	// 수강 목록(학생)
	List<Map<String, Object>> selectCourseByStudent(Long userId);
	// 수강 과제목록(학생)
	List<Map<String, Object>> selectAssignmentByStudent(Long userId);
	// 수강 과제제출여부(학생)
	AssignmentSubmit selectSubmittedAssignmentOne(Map<String, Object> data);
	
}
