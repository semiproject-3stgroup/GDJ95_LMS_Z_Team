package com.example.lms.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.User;
import com.example.lms.mapper.UserMapper;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;
    
    // 로그인
    public User login(User user) {
        return userMapper.login(user);
    }
    
    // 마이페이지 - 내 정보 조회
    public User getMyInfo(Long userId) {
        return userMapper.selectUserById(userId);
    }

    // 마이페이지 - 내 정보 수정
    public boolean updateMyInfo(User user) {
        return userMapper.updateUserInfo(user) == 1;
    }

    // 비빌번호변경
    public boolean changePassword(Long userId, String currentPassword, String newPassword) {

        // (암호화 사용 안 한다고 가정) 

        int row = userMapper.updateUserPassword(userId, currentPassword, newPassword);
        return row == 1;
    }
}