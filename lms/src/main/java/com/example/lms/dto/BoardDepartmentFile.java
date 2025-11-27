package com.example.lms.dto;

import lombok.Data;

@Data
public class BoardDepartmentFile {
	private int fileId;
	private int postId;
	private String fileName;
	private String originName;
	private String fileExtension;
	private long fileSize;
}
