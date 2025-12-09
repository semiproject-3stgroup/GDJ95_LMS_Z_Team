package com.example.lms.mapper;

import java.util.List;

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
    
    // 전체 사용자 조회(알림용)
    List<User> selectAllUsers();

    // [관리자] 사용자 관리 목록
    /**
     * [관리자] 사용자 목록 조회 (페이징 및 검색 포함)
     */
    List<User> selectUsersWithPagingAndSearch(
            @Param("offset") int offset,
            @Param("pageSize") int pageSize,
            @Param("searchType") String searchType,
            @Param("searchKeyword") String searchKeyword
    );
    
    /**
     * [관리자] 사용자 목록 총 개수 조회 (검색 필터 포함)
     */
    int countUsersWithSearch(
            @Param("searchType") String searchType,
            @Param("searchKeyword") String searchKeyword
    );
    
}