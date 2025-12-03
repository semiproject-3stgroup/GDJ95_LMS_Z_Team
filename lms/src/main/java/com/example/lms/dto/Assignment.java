package com.example.lms.dto;

import lombok.Data;

@Data
public class Assignment {
	private int assignmentId;
	private long courseId;
	private String assignmentName;
	private String assignmentContent;
	private String startdate;
	private String enddate;
	private String createdate;
	private String updatedate;
}
