package com.example.lms.dto;

import lombok.Data;

@Data
public class BoardDepartment {
	private int postId;
	private int departmentId;
	private int userId;
	private int hitCount;
	private String category;
	private String title;
	private String content;
	private String file;
	private String createdate;
	private String updatedate;
	private String writerName;
}
