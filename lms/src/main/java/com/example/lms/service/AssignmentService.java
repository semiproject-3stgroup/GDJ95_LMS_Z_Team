package com.example.lms.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.lms.dto.Assignment;
import com.example.lms.dto.AssignmentSubmit;
import com.example.lms.dto.Course;
import com.example.lms.mapper.AssignmentMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class AssignmentService {
	
	@Autowired
	AssignmentMapper assignmentMapper;

	// 강의 과제 목록
	public List<Map<String, Object>> courseListWithAssignment(Long userId) {
		
		List<Map<String, Object>> list = assignmentMapper.selectCourseAndAssignmentByProf(userId);
		
		return list;		
	}
	// 교수 강의 목록
	public List<Course> courseListByProf(Long userId) {
		List<Course> course = assignmentMapper.selectCourseByProf(userId);
		return course;
	}
	// 새 과제 등록
	public void addAssignment(Assignment assignment) {
		
		assignment.setEnddate(assignment.getEnddate() + " 23:59:59");
		
		int row = assignmentMapper.insertAssignmentByProf(assignment);
		if(row!=1) {
			throw new RuntimeException("새 과제 등록 실패");
		}
	}
	// 과제 상세
	public Assignment assignmentOne(int assignmentId) {
		Assignment assignment = assignmentMapper.selectAssignmentOne(assignmentId);
		
		return assignment;
	}
	// 과제 삭제
	public void removeAssignment(int assignmentId) {
		int row = assignmentMapper.deleteAssignmentByProf(assignmentId);
		if(row!=1) {
			throw new RuntimeException("과제 삭제 실패");
		}
	}
	// 강의
	public Map<String, Object> courseOne(Long courseId) {
		Map<String, Object> course = assignmentMapper.selectCourseByCourseId(courseId);
		return course;
	}
	// 과제 수정
	public void modifyAssignment(Assignment assignment) {
		
		assignment.setEnddate(assignment.getEnddate() + " 23:59:59");
		
		int row = assignmentMapper.updateAssignmentByProf(assignment);
		if(row!=1) {
			throw new RuntimeException("과제 수정 실패");
		}
	}
	
	// 학생 수강 목록
	public List<Map<String, Object>> courseListByStudent(Long userId) {
		return assignmentMapper.selectCourseByStudent(userId);				
	}
	
	// 학생 수강 과제목록
	public List<Map<String, Object>> assignmentListByStudent(Long userId) {
		return assignmentMapper.selectAssignmentByStudent(userId); 				
	}
	// 학생 과제제출여부
	public AssignmentSubmit assignmentOneSubmit(long userId, int assignmentId) {
		
		Map<String, Object> data = new HashMap<>();
		data.put("userId", userId);
		data.put("assignmentId", assignmentId);
		
		return assignmentMapper.selectSubmittedAssignmentOne(data);
	}
}
