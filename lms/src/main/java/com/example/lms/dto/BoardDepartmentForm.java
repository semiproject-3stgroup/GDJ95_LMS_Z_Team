package com.example.lms.dto;


import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class BoardDepartmentForm {
	private int departmentId;
	private int userId;
	private String category;
	private String title;
	private String content;
	List<MultipartFile> boardDeptFile;
}
