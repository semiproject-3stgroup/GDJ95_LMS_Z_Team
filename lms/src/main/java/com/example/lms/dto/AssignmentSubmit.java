package com.example.lms.dto;

import lombok.Data;

@Data
public class AssignmentSubmit {
	private long userId;
	private int assignmentId;
	private String file;
	private Double assignmentScore;		
	private String createdate;
	private String updatedate;
}
