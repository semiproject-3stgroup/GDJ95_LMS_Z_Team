package com.example.lms.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.ScoreRecord;
import com.example.lms.mapper.AssignmentMapper;
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

    /**
     * 성적 입력/수정 + 알림 발송(upsert)
     */
    public int saveStudentScore(ScoreRecord scoreRecord) {

        Long studentId = scoreRecord.getUserId();
        Long courseId  = scoreRecord.getCourseId();

        if (studentId == null || courseId == null) {
            throw new IllegalArgumentException("studentId, courseId는 필수입니다.");
        }

        // 이미 성적이 있는지 확인 → 0이면 CREATE, 1 이상이면 UPDATE
        int exists = scoreMapper.existsStudentScore(studentId, courseId);

        // 점수 upsert
        int row = scoreMapper.upsertStudentScore(scoreRecord);

        // 알림 액션 구분
        String action = (exists > 0) ? "UPDATE" : "CREATE";

        // 알림 호출
        notificationService.notifyScoreChanged(studentId, courseId, action);

        return row;
    }

    // ===================== 출석 / 수강생 관련 (정순오 파트) =====================

    // 과목 수강생 목록
    public List<Map<String, Object>> courseStudentList(int courseId) {
        return assignmentMapper.selectStudentsListByCourseId(courseId); // userId, 학번, 이름
    }

    // 과목별 출석 요약 리스트
    public List<Map<String, Object>> courseStudentAttendanceStatusList(int courseId) {

        List<Map<String, Object>> students = assignmentMapper.selectStudentsListByCourseId(courseId);
        List<Map<String, Object>> states   = scoreMapper.selectAttendanceStatus(courseId);

        Map<Long, Map<String, Object>> map = new HashMap<>();
        for (Map<String, Object> s : students) {
            map.put((Long) s.get("userId"), s);
        }

        List<Map<String, Object>> attendance = new ArrayList<>();
        for (Map<String, Object> st : states) {

            Map<String, Object> s = map.get(st.get("userId"));

            Map<String, Object> one = new HashMap<>();
            one.put("userId",  st.get("userId"));
            one.put("absent",  st.get("count_0"));
            one.put("attend",  st.get("count_1"));
            one.put("late",    st.get("count_2"));
            one.put("total",   st.get("total_days"));

            if (s != null) {
                one.put("userName",  s.get("userName"));
                one.put("studentNo", s.get("studentNo"));
            }

            attendance.add(one);
        }

        return attendance;
    }

    // 특정 날짜 출석부 리스트
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

    // 출석 저장 (있으면 update, 없으면 insert)
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
}
