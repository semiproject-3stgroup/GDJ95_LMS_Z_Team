package com.example.lms.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.AttendanceDetail;
import com.example.lms.dto.Course;
import com.example.lms.dto.Score;
import com.example.lms.dto.ScoreRecord;
import com.example.lms.mapper.AssignmentMapper;
import com.example.lms.mapper.CourseMapper;
import com.example.lms.mapper.ScoreMapper;

@Service
public class ScoreService {

    @Autowired
    private ScoreMapper scoreMapper;

    // 성적 알림용
    @Autowired
    private NotificationService notificationService;

    // 출석 / 수강생 조회용
    @Autowired
    private AssignmentMapper assignmentMapper;

    // 강의 기본 정보 조회용
    @Autowired
    private CourseMapper courseMapper;

    /**
     * 특정 과목 기본 정보
     */
    public Course getCourseBasic(long courseId) {
        return courseMapper.selectCourseBasicById(courseId);
    }

    /**
     * 학생별 성적 + GPA 계산
     */
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

    public int saveStudentScore(ScoreRecord scoreRecord) {

        Long studentId = scoreRecord.getUserId();
        Long courseId  = scoreRecord.getCourseId();

        if (studentId == null || courseId == null) {
            throw new IllegalArgumentException("studentId, courseId는 필수입니다.");
        }

        int exists = scoreMapper.existsStudentScore(studentId, courseId);

        int row = scoreMapper.upsertStudentScore(scoreRecord);

        String action = (exists > 0) ? "UPDATE" : "CREATE";

        notificationService.notifyScoreChanged(studentId, courseId, action);

        return row;
    }

    // ===================== 출석 / 수강생 관련 =====================

    public List<Map<String, Object>> courseStudentList(int courseId) {

    	List<Score> scores = scoreMapper.selectStudentsScore(courseId);
    	List<Map<String, Object>> students = assignmentMapper.selectStudentsListByCourseId(courseId);
    	
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
    		
    		m.put("courseId", courseId);
    		m.put("exam1Score", null);
    		m.put("exam2Score", null);
    		m.put("assignmentScore", null);
    		m.put("attendanceScore", null);
    		m.put("scoreTotal", null);
    		
    		if(score != null) {    			    			
        		m.put("exam1Score", score.getExam1Score());
        		m.put("exam2Score", score.getExam2Score());
        		m.put("assignmentScore", score.getAssignmentScore());
        		m.put("attendanceScore", score.getAttendanceScore());
        		m.put("scoreTotal", score.getScoreTotal());
    		}
    		
    		list.add(m);    		    		    		        	
    	}
    	
    	applyGradesByPercent(list);
    	
    	return list;
    }

    
    private void applyGradesByPercent(List<Map<String, Object>> list) {

        list.sort((a, b) -> {
            Double s1 = toScore(a.get("scoreTotal"));
            Double s2 = toScore(b.get("scoreTotal"));
            return Double.compare(s2, s1);
        });

        int n = list.size();

        int aEnd = (int)Math.ceil(n * 0.20);       
        int bEnd = aEnd + (int)Math.ceil(n * 0.30);
        int cEnd = bEnd + (int)Math.ceil(n * 0.30);


        for (int i = 0; i < n; i++) {
            String grade;

            if (i < aEnd) grade = "A";
            else if (i < bEnd) grade = "B";
            else if (i < cEnd) grade = "C";
            else grade = "D";

            list.get(i).put("grade", grade);
        }
        
        list.sort((a, b) -> {
            Long u1 = ((Number)a.get("userId")).longValue();
            Long u2 = ((Number)b.get("userId")).longValue();
            return Long.compare(u1, u2);
        });
    }


    private Double toScore(Object obj) {
        if (obj == null) return 0.0;
        if (obj instanceof Number) return ((Number) obj).doubleValue();
        return Double.parseDouble(obj.toString());
    }
    
    
    public void courseStudentScoreSave(Score score) {

        ScoreRecord r = new ScoreRecord();

        
        r.setUserId(score.getUserId().longValue());
        r.setCourseId(score.getCourseId().longValue());

        r.setExam1Score(score.getExam1Score());
        r.setExam2Score(score.getExam2Score());
        r.setAssignmentScore(score.getAssignmentScore());
        r.setAttendanceScore(score.getAttendanceScore());
        r.setScoreTotal(score.getScoreTotal());

        // (업서트 + 알림 발송)
        int row = this.saveStudentScore(r);

        if (row < 1) {
            throw new RuntimeException("점수 등록 실패");
        }
    }
    


    public List<Map<String, Object>> courseStudentAttendanceStatusList(int courseId) {

        List<Map<String, Object>> students = assignmentMapper.selectStudentsListByCourseId(courseId);
        List<Map<String, Object>> states   = scoreMapper.selectAttendanceStatus(courseId);

        Map<Long, Map<String, Object>> map = new HashMap<>();
        for (Map<String, Object> s : states) {
            map.put((Long) s.get("userId"), s);
        }

        List<Map<String, Object>> attendance = new ArrayList<>();
        for (Map<String, Object> st : students) {

            Map<String, Object> s = map.get(st.get("userId"));

            Map<String, Object> one = new HashMap<>();
            one.put("userId",  st.get("userId"));
            one.put("userName",  st.get("userName"));
            one.put("studentNo", st.get("studentNo"));                        

            if (s != null) {                        	
                one.put("absent", s.get("count_0"));
                one.put("attend", s.get("count_1"));
                one.put("late", s.get("count_2"));
                one.put("total", s.get("total_days"));
            } else {
            	one.put("absent", 0);
                one.put("attend", 0);
                one.put("late", 0);
                one.put("total", 0);
            }

            attendance.add(one);
        }

        return attendance;
    }

    
    public Score selectStudentScore(int userId, int courseId) {    	    	    
    	return scoreMapper.selectStudentScore(userId, courseId);    			    			
    }        

    public List<Map<String, Object>> selectTodayAttendance(String date, int courseId) {

        Map<String, Object> param = new HashMap<>();
        param.put("date", date);
        param.put("courseId", courseId);

        List<Map<String, Object>> list = scoreMapper.selectTodayAttendance(param);
        if (!list.isEmpty()) {
            return list;
        }

        list = assignmentMapper.selectStudentsListByCourseId(courseId);

        for (Map<String, Object> li : list) {
            li.put("attendance", null);
            li.put("date", date);
        }

        return list;
    }

    public void saveAttendance(List<Integer> userIds,
                               List<Integer> statusList,
                               String date,
                               int courseId) {

        for (int i = 0; i < userIds.size(); i++) {
            Map<String, Object> param = new HashMap<>();

            param.put("userId",     userIds.get(i));
            param.put("courseId",   courseId);
            param.put("date",       date);
            param.put("attendance", statusList.get(i));

            int row = scoreMapper.updateAttendace(param);
            if (row == 0) {
                row = scoreMapper.insertAttedance(param);
                if (row != 1) {
                    throw new RuntimeException("출석 오류");
                }
            }
        }
    }

    /**
     * 특정 학생의 일자별 출석 이력 조회
     */
    public List<AttendanceDetail> getAttendanceHistory(int courseId, long userId) {
        return scoreMapper.selectAttendanceHistory(courseId, userId);
    }
}
