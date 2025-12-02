package com.example.lms.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.ScoreRecord;
import com.example.lms.mapper.ScoreMapper;

@Service
public class ScoreService {

    @Autowired
    private ScoreMapper scoreMapper;

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
}
