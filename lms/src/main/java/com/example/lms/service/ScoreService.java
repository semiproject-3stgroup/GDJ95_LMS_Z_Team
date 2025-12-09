package com.example.lms.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.Score;
import com.example.lms.dto.ScoreRecord;
import com.example.lms.mapper.AssignmentMapper;
import com.example.lms.mapper.ScoreMapper;

@Service
public class ScoreService {

    @Autowired
    private ScoreMapper scoreMapper;
    
    @Autowired
    private AssignmentMapper assignmentMapper;

    public Map<String, Object> getStudentGrades(Long userId) {

        List<ScoreRecord> list = scoreMapper.selectStudentScores(userId);

        double totalPoint = 0.0;
        double totalCredit = 0.0;

        for (ScoreRecord sr : list) {
            applyGrade(sr);

            if (sr.getGradePoint() == null || sr.getCredit() == null) continue;

            totalPoint  += sr.getGradePoint() * sr.getCredit();
            totalCredit += sr.getCredit();
        }

        double gpa = (totalCredit > 0) ? totalPoint / totalCredit : 0.0;

        Map<String, Object> result = new HashMap<>();
        result.put("scoreList", list);
        result.put("gpa", gpa);

        return result;
    }

    // 총점 → 등급 변환
    private void applyGrade(ScoreRecord sr) {
        Double total = sr.getScoreTotal();
        if (total == null) {
            sr.setLetterGrade("-");
            sr.setGradePoint(null);
            return;
        }

        String grade;
        double point;

        if (total >= 95) {
            grade = "A+";
            point = 4.5;
        } else if (total >= 90) {
            grade = "A0";
            point = 4.0;
        } else if (total >= 85) {
            grade = "B+";
            point = 3.5;
        } else if (total >= 80) {
            grade = "B0";
            point = 3.0;
        } else if (total >= 75) {
            grade = "C+";
            point = 2.5;
        } else if (total >= 70) {
            grade = "C0";
            point = 2.0;
        } else if (total >= 60) {
            grade = "D";
            point = 1.0;
        } else {
            grade = "F";
            point = 0.0;
        }

        sr.setLetterGrade(grade);
        sr.setGradePoint(point);
    }
    
    // 수강생 성적 목록
    public List<Map<String, Object>> courseStudentList(int courseId) {
    	
    	List<Score> scores = scoreMapper.selectStudentsScore(courseId);
    	List<Map<String, Object>> students = assignmentMapper.selectStudentsListByCourseId(courseId); // 수강생 목록(userId, 학번, 이름)
    	
    	
    	Map<Long, Score> map = new HashMap<>();
    	for(Score s : scores) {
    		map.put(s.getUserId(), s);
    	}
    	
    	List<Map<String, Object>> list = new ArrayList<>();
    	for(Map<String, Object> stu : students) {
    		
    		Map<String, Object> m = new HashMap<>();
    		
    		Score score = map.get(stu.get("userId"));
    		
    		m.put("userId", stu.get("userId"));
    		m.put("userName", stu.get("userName"));
    		m.put("studentNo", stu.get("studentNo"));
    		
    		m.put("courseId", null);
    		m.put("exam1Score", null);
    		m.put("exam2Score", null);
    		m.put("assignmentScore", null);
    		m.put("attendanceScore", null);
    		m.put("scoreTotal", null);
    		
    		if(!scores.isEmpty()) {    			
    			m.put("courseId", score.getCourseId());
        		m.put("exam1Score", score.getExam1Score());
        		m.put("exam2Score", score.getExam2Score());
        		m.put("assignmentScore", score.getAssignmentScore());
        		m.put("attendanceScore", score.getAttendanceScore());
        		m.put("scoreTotal", score.getScoreTotal());
    		}
    		
    		list.add(m);    		    		    		        	    	
    	}
    	
    	return list;
    }
    
    // 수강생 성적 저장
    public void courseStudentScoreSave(Score score) {
    	
    	ScoreRecord r = new ScoreRecord();
        r.setUserId(score.getUserId());
        r.setCourseId(score.getCourseId());
        r.setExam1Score(score.getExam1Score());
        r.setExam2Score(score.getExam2Score());
        r.setAssignmentScore(score.getAssignmentScore());
        r.setAttendanceScore(score.getAttendanceScore());
        r.setScoreTotal(score.getScoreTotal());
    	
        int row = scoreMapper.upsertStudentScore(r);
    	
    	if(row < 1) {
    		throw new RuntimeException("점수 등록 실패");
    	}    	    	    	    	    	   
    }
    
    // 수강생 출석 상황
    public List<Map<String, Object>> courseStudentAttendanceStatusList(int courseId) {
    	
    	List<Map<String, Object>> students = assignmentMapper.selectStudentsListByCourseId(courseId);
    	List<Map<String, Object>> states = scoreMapper.selectAttendanceStatus(courseId);
    	
    	Map<Long, Map<String, Object>> map = new HashMap<>();
    	for(Map<String, Object> s : students) {
    		map.put((Long)s.get("userId"), s);    		
    	}
    	
    	
    	List<Map<String, Object>> attendance = new ArrayList<>();
    	for(Map<String,Object> st : states) {
    		
    		Map<String,Object> s = map.get(st.get("userId"));
    		
    		Map<String,Object> list = new HashMap<>();
    		list.put("userId", st.get("userId"));
    		list.put("absent", st.get("count_0"));
    		list.put("attend", st.get("count_1"));
    		list.put("late", st.get("count_2"));
    		list.put("total", st.get("total_days"));
    		
    		list.put("userName", s.get("userName"));
    		list.put("studentNo", s.get("studentNo"));    	
    		
    		attendance.add(list);
    	}
    	    	    	    	
    	return attendance;
    }
        
    // 출석부 리스트
    public List<Map<String, Object>> selectTodayAttendance(String date, int courseId) {
    	
    	Map<String, Object> map = new HashMap<>();
    	map.put("date", date);
    	map.put("courseId", courseId);
    	
    	List<Map<String, Object>> list = scoreMapper.selectTodayAttendance(map);
    	if(!list.isEmpty()) {
    		return list;
    	}
    	
    	list = assignmentMapper.selectStudentsListByCourseId(courseId);
    	
    	
    	for(Map<String, Object> li : list) {
    		li.put("attendance", null);
    		li.put("date", date);
    	}
    	
    	return list;    	    	
    }
    
    // 출석 저장
    public void saveAttendance(List<Integer> userIds, List<Integer> statusList, String date, int courseId) {
    	
    	for(int i=0; i<userIds.size(); i++) {
    		Map<String, Object> map = new HashMap<>();
    		
    		map.put("userId", userIds.get(i));
    		map.put("courseId", courseId);
    		map.put("date", date);
    		map.put("attendance", statusList.get(i));
    		
    		int row = scoreMapper.updateAttendace(map);
    		if(row==0) {
    			row = scoreMapper.insertAttedance(map);
    			if(row!=1) {
    				throw new RuntimeException("출석 오류");
    			}
    		}
    	}    	    	    	    	    	
    }
}
