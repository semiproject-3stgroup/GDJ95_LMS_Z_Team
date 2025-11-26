package com.example.lms.mapper;

import org.apache.ibatis.annotations.Mapper;
import com.example.lms.dto.User;

@Mapper
public interface UserMapper {
    User login(User user); // loginId + password 조회
}