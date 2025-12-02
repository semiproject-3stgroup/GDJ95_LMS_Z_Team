package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.Department;

@Mapper
public interface DepartmentMapper {
    List<Department> selectDepartmentList();
}
