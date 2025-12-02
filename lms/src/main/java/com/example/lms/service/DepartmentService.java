package com.example.lms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.Department;
import com.example.lms.mapper.DepartmentMapper;

@Service
public class DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    public List<Department> getDepartmentList() {
        return departmentMapper.selectDepartmentList();
    }
}
