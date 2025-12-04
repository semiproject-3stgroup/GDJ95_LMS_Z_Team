package com.example.lms.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.lms.dto.Notification;   // ★ 알림 DTO import
import com.example.lms.dto.User;
import com.example.lms.mapper.UserMapper;

@Service
@Transactional
public class UserService {

    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private NotificationService notificationService; // 알림 서비스
    
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
        
        if (row == 1) {
            // -----------------------------
            // 비밀번호 변경→ 알림 발송
            // -----------------------------
            Notification n = new Notification();
            n.setUserId(userId);
            n.setCategory("system");
            n.setTargetType("USER");
            n.setTargetId(userId.intValue());
            n.setTitle("비밀번호가 변경되었습니다.");
            n.setMessage("본인이 변경한 것이 아니라면 관리자에게 즉시 문의해주세요.");
            n.setLinkUrl("/mypage/password");

            notificationService.sendNotification(n);
        }
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

        int row = userMapper.updatePassword(loginId, newPassword);

        if (row == 1) {
            // -----------------------------
            // ★ 비밀번호 재설정 알림
            // -----------------------------
            Integer userId = userMapper.findUserIdForPasswordReset(loginId, null, null);

            if (userId != null) {
                Notification n = new Notification();
                n.setUserId(userId.longValue());
                n.setCategory("system");
                n.setTargetType("USER");
                n.setTargetId(userId);
                n.setTitle("비밀번호가 재설정되었습니다.");
                n.setMessage("본인이 요청한 비밀번호 초기화가 완료되었습니다.");
                n.setLinkUrl("/login");

                notificationService.sendNotification(n);
            }
        }

        return row;
    }
    
}