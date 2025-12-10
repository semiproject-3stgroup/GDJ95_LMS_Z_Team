package com.example.lms.dto;

import lombok.Data;

@Data
public class BoardDeptComment {
	private int commentId;
	private int postId;
	private Long userId;
	private String content;
	private String createdate;
	private String updatedate;
	private String userName;
}
