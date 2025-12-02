package com.example.lms.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class User {
    private Long userId;        // user_id BIGINT
    private String loginId;     // login_id
    private String password;    // password
    private String role;        // role

    private String studentNo;   // student_no
    private String employeeNo;  // employee_no

    private String userName;    // user_name
    private String gender;      // gender (M/F)
    private Integer userGrade;  // user_grade

    private String phone;       // phone
    private String email;       // email

    private String zipCode;     // zip_code
    private String address1;    // address1
    private String address2;    // address2

    private String status;      // status

    private LocalDateTime createdate; // createdate
    private LocalDateTime updatedate; // updatedate

    private Integer departmentId;     // department_id
    private String departmentName;    // department_name
}
