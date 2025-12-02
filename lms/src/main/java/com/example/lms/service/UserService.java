package com.example.lms.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.lms.dto.User;
import com.example.lms.mapper.UserMapper;

@Service
@Transactional
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


        int row = userMapper.updateUserPassword(userId, currentPassword, newPassword);
        return row == 1;
    }
    
    // 회원가입
    public int signup(User user) {

        // 상태 기본값
        user.setStatus("ACTIVE");

        // 역할에 따른 필드 정리
        if ("STUDENT".equals(user.getRole())) {
            // 학생인 경우: employeeNo, userGrade null 되지 않게만 관리
            if (user.getUserGrade() == null) {
                user.setUserGrade(1); // 기본 1학년 같은 값
            }
            user.setEmployeeNo(null);
        } else if ("PROF".equals(user.getRole())) {
            // 교수인 경우
            user.setStudentNo(null);
            user.setUserGrade(null);
        }

        // TODO: 비밀번호 암호화는 로그인 쿼리 수정할 때 함께 적용
        // String encoded = passwordEncoder.encode(user.getPassword());
        // user.setPassword(encoded);

        return userMapper.insertUser(user);
    }
    
 // --- 아이디 찾기 ---
    public String findLoginId(String userName, String email) {
        String loginId = userMapper.findLoginIdByNameAndEmail(userName, email);

        // 필요하면 마스킹 처리
        // ex) abcd1234 → ab****34
        if (loginId != null && loginId.length() > 4) {
            int len = loginId.length();
            String prefix = loginId.substring(0, 2);
            String suffix = loginId.substring(len - 2);
            String masked = prefix + "****" + suffix;
            return masked;
        }

        return loginId; // 짧은 아이디면 그대로
    }
    
    // 비밀번호 찾기: 사용자 존재 여부 확인
    public boolean existsUserForPasswordReset(String loginId, String userName, String email) {
        Integer userId = userMapper.findUserIdForPasswordReset(loginId, userName, email);
        return userId != null;
    }

    // 비밀번호 재설정
    public int resetPassword(String loginId, String newPassword) {

        // TODO: 나중에 암호화 적용할 거면 여기서 encode
        // String encoded = passwordEncoder.encode(newPassword);
        // return userMapper.updatePassword(loginId, encoded);

        return userMapper.updatePassword(loginId, newPassword);
    }
    
}