package com.example.lms.service;

import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.lms.dto.Assignment;
import com.example.lms.dto.AssignmentSubmit;
import com.example.lms.dto.Course;
import com.example.lms.dto.Notification;
import com.example.lms.mapper.AssignmentMapper;
import com.example.lms.mapper.CourseMapper;
import com.example.lms.mapper.NotificationMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class AssignmentService {
	
	@Autowired
	AssignmentMapper assignmentMapper;
	
	// [권순표] 알림 기능 추가: 수강 학생 조회용
    @Autowired
    private CourseMapper courseMapper;

    // [권순표] 알림 기능 추가: 알림 저장용
    @Autowired
    private NotificationMapper notificationMapper;
    
    // 날짜 포멧
    public LocalDateTime toDate(String date) {
    	DateTimeFormatter f = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    	return LocalDateTime.parse(date, f);
    }
    // 과제 마감일 지나면 true
    public boolean isDateOver(Assignment assignment) {
    	LocalDateTime end = toDate(assignment.getEnddate());
    	return LocalDateTime.now().isAfter(end);
    }
    // 과제 시작일 지나면 true
    public boolean isDateBegin(Assignment assignment) {
    	LocalDateTime start = toDate(assignment.getEnddate());
    	return LocalDateTime.now().isAfter(start);
    }

	// 강의 과제 목록
	public List<Map<String, Object>> courseListWithAssignment(Long userId) {
		
		List<Map<String, Object>> list = assignmentMapper.selectCourseAndAssignmentByProf(userId);				 						
		
		for(Map<String, Object> li : list) {
			Assignment ass = new Assignment();
			ass.setEnddate(li.get("enddate").toString().replace("T", " "));
			
			boolean over = isDateOver(ass);
			
			li.put("over", over);
		}								
		
		return list; 
	}
	// 교수 강의 목록
	public List<Course> courseListByProf(Long userId) {
		return assignmentMapper.selectCourseByProf(userId);
	}
	// 새 과제 등록
	public void addAssignment(Assignment assignment) {		
		assignment.setEnddate(assignment.getEnddate() + " 23:59:59");
		
		int row = assignmentMapper.insertAssignmentByProf(assignment);
		if(row!=1) {
			throw new RuntimeException("새 과제 등록 실패");
		}
		
		// [권순표] 알림 기능 추가: 과제 등록 알림 발송
        notifyAssignmentToCourseStudents(assignment, "CREATE");
	}
	// 과제 상세
	public Assignment assignmentOne(int assignmentId) {
		return assignmentMapper.selectAssignmentOne(assignmentId);		
	}
	// 과제 삭제
	public void removeAssignment(int assignmentId) {
		
		// [권순표] 알림 기능 추가를 위해 삭제 전 과제 정보 조회
        Assignment assignment = assignmentMapper.selectAssignmentOne(assignmentId);
        if (assignment == null) {
            throw new RuntimeException("존재하지 않는 과제입니다.");
        }
		
		int row = assignmentMapper.deleteAssignmentByProf(assignmentId);
		if(row!=1) {
			throw new RuntimeException("과제 삭제 실패");
		}
		
		// [권순표] 알림 기능 추가: 과제 삭제 알림 발송
        notifyAssignmentToCourseStudents(assignment, "DELETE");
	}
	// 강의
	public Map<String, Object> courseOne(Long courseId) {
		return assignmentMapper.selectCourseByCourseId(courseId);
	}
	
	// 강의 학생 과제제출목록
	public List<Map<String, Object>> courseStudentsSubmitList(long courseId, int assignmentId) {
		List<Map<String, Object>> students = assignmentMapper.selectStudentsListByCourseId(courseId);
		List<AssignmentSubmit> submits = assignmentMapper.selectSubmittedAssignmentByAssignmentId(assignmentId);
		
		Map<Long, AssignmentSubmit> map = new HashMap();
		for(AssignmentSubmit s : submits) {
			map.put(s.getUserId(), s);
		}
				
		List<Map<String, Object>> list = new ArrayList<>();
		for(Map<String, Object> stu : students) {
			AssignmentSubmit s = map.get(stu.get("userId"));
			
			Map<String, Object> submitted = new HashMap<>();
			submitted.put("userId", stu.get("userId"));
			submitted.put("userName", stu.get("userName"));
			submitted.put("studentNo", stu.get("studentNo"));
			
			submitted.put("AssignmentId", null);
			submitted.put("file", null);
			submitted.put("assignmentScore", null);
			submitted.put("createdate", null);
			submitted.put("updatedate", null);
			
			if(s != null) {
				submitted.put("AssignmentId", s.getAssignmentId());
				submitted.put("file", s.getFile());
				submitted.put("assignmentScore", s.getAssignmentScore());
				submitted.put("createdate", s.getCreatedate());
				submitted.put("updatedate", s.getUpdatedate());				
			}
			
			list.add(submitted);		
		}
		
		return list; 
	}
				
	// 과제 채점
	public void assignmentScoring(AssignmentSubmit submit) {
		int row = assignmentMapper.updateSumittedAssignmentByProf(submit);
		if(row==0) {
			int row2 = assignmentMapper.insertSumittedAssignmentOnlyScoreByprof(submit);
			if(row2!=1) {
				throw new RuntimeException("채점 실패");
			}
		}
	}
	
	// 과제 수정
	public void modifyAssignment(Assignment assignment) {		
		assignment.setEnddate(assignment.getEnddate() + " 23:59:59");
		
		int row = assignmentMapper.updateAssignmentByProf(assignment);
		if(row!=1) {
			throw new RuntimeException("과제 수정 실패");
		}
		
		// [권순표] 알림 기능 추가: 과제 수정 알림 발송
        notifyAssignmentToCourseStudents(assignment, "UPDATE");
        
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
	
	// 학생 과제 제출
	public void addAssignmentSubmit(AssignmentSubmit submit, MultipartFile file, String path) {
		if(!file.getOriginalFilename().isEmpty()) {
						
			submit.setFile(file.getOriginalFilename());
			
			int row = assignmentMapper.updateSubmittedAssignment(submit);
			if(row == 0 ) {
				row = assignmentMapper.insertSubmittedAssignment(submit);
					if(row != 1) {
						throw new RuntimeException("파일 등록 실패");
					}
			}						 			
						
			File submitFile = new File(path + submit.getAssignmentId() + "/" + file.getOriginalFilename());
			if(!submitFile.getParentFile().exists()) {
				submitFile.getParentFile().mkdirs();
			}			
			try {file.transferTo(submitFile);}
			catch(Exception e) {throw new RuntimeException("파일 저장 실패");}			
		}
	}
	
	// 학생 과제 수정
	public void modifyAssignmentSubmit(AssignmentSubmit submit, MultipartFile file, String path) {		
		if(!file.getOriginalFilename().isEmpty()) {
			
			File submittedFile = new File(path + submit.getAssignmentId() + "/" + submit.getFile());			
			
			if(submittedFile.exists()) {
				boolean deleted = submittedFile.delete();										
				if(!deleted) {				
					log.debug("파일 삭제 실패: " + file.getOriginalFilename());
				}
			} else {
				log.debug("파일이 존재하지 않습니다: " + file.getOriginalFilename());
			}
			submit.setFile(file.getOriginalFilename());
			int row = assignmentMapper.updateSubmittedAssignment(submit);
			if(row!=1) {
				throw new RuntimeException("과제 수정 실패");
			}
			
			File submitFile = new File(path + submit.getAssignmentId() + "/" + file.getOriginalFilename());
			if(!submitFile.getParentFile().exists()) {
				submitFile.getParentFile().mkdirs();
			}			
			try {file.transferTo(submitFile);}
			catch(Exception e) {throw new RuntimeException("파일 저장 실패");}
		}
	}
	
    //  알림 기능 추가: 과제 등록/수정/삭제 시 공통 알림 발송 메서드
    private void notifyAssignmentToCourseStudents(Assignment assignment, String action) {

        Long courseId = assignment.getCourseId();
        if (courseId == null) {
            log.warn("notifyAssignmentToCourseStudents: courseId가 null입니다. assignmentId={}", assignment.getAssignmentId());
            return;
        }

        // 강의 정보 조회 (courseName 얻기)
        Map<String, Object> courseMap = courseOne(courseId);
        String courseName = courseMap != null ? (String) courseMap.get("courseName") : "";

        // 수강 중인 학생 목록 조회
        List<Long> studentIds = courseMapper.selectEnrolledStudentIdsByCourseId(courseId);
        if (studentIds == null || studentIds.isEmpty()) {
            log.debug("notifyAssignmentToCourseStudents: 수강 중인 학생 없음. courseId={}", courseId);
            return;
        }

        String prefix;
        String message;

        switch (action) {
            case "CREATE":
                prefix = "[과제 등록] ";
                message = "새 과제가 등록되었습니다.";
                break;
            case "UPDATE":
                prefix = "[과제 수정] ";
                message = "등록된 과제가 수정되었습니다.";
                break;
            case "DELETE":
                prefix = "[과제 삭제] ";
                message = "등록된 과제가 삭제되었습니다.";
                break;
            default:
                prefix = "[과제 알림] ";
                message = "과제 관련 알림입니다.";
        }

        String assignmentName = assignment.getAssignmentName() != null ? assignment.getAssignmentName() : "";
        String title = prefix + courseName + " - " + assignmentName;

        String deadlineInfo = assignment.getEnddate() != null ? " (마감: " + assignment.getEnddate() + ")" : "";
        String fullMessage = message + deadlineInfo;

        String linkUrl = "/assignment/detail?assignmentId=" + assignment.getAssignmentId();

        for (Long studentId : studentIds) {
            Notification notification = new Notification();
            notification.setUserId(studentId);
            notification.setCategory("ASSIGNMENT");
            notification.setTargetType("ASSIGNMENT");
            notification.setTargetId(assignment.getAssignmentId());
            notification.setTitle(title);
            notification.setMessage(fullMessage);
            notification.setLinkUrl(linkUrl);

            notificationMapper.insertNotification(notification);
        }
    }
}

