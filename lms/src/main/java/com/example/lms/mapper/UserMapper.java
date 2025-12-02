package com.example.lms.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.User;

@Mapper
public interface UserMapper {
	// 로그인
    User login(User user);
    
    // 마이페이지: 내 정보 조회
    User selectUserById(Long userId);

    // 마이페이지: 내 정보 수정
    int updateUserInfo(User user);

    // 비밀번호 변경 (기존 비밀번호 체크도 포함)
    int updateUserPassword(
            @Param("userId") Long userId,
            @Param("currentPassword") String currentPassword,
            @Param("newPassword") String newPassword
    );
    
    // 회원가입
    int insertUser(User user);
    
    // 아이디 찾기용
    String findLoginIdByNameAndEmail(@Param("userName") String userName,
                                     @Param("email") String email);
    
    // 비밀번호 찾기용: 존재 여부 확인
    Integer findUserIdForPasswordReset(@Param("loginId") String loginId,
                                       @Param("userName") String userName,
                                       @Param("email") String email);

    // 비밀번호 업데이트
    int updatePassword(@Param("loginId") String loginId,
                       @Param("password") String password);
    
    
}