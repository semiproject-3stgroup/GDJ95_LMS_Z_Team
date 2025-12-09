package com.example.lms.dto;

import lombok.Data;

@Data
public class Score {
	
	private Long userId;
	private Long courseId;
    private Double exam1Score;
    private Double exam2Score;
    private Double assignmentScore;
    private Double attendanceScore;
    private Double scoreTotal;
    private String createdate;
    private String updatedate;
}
