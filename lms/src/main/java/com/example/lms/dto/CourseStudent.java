package com.example.lms.dto;

import lombok.Data;

@Data
public class CourseStudent {
    private Long userId;
    private String studentNo;
    private String userName;
    private String departmentName;
    private String phone;
    private String email;
}
