package com.example.lms.controller;

import com.example.lms.dto.User;
import com.example.lms.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/admin/user")
public class AdminUserController {

    @Autowired
    private UserMapper userMapper; // UserMapper 주입

    /**
     * [관리자] 사용자 목록 조회 및 검색 (getUserList)
     *
     * @param page 현재 페이지 번호 (기본값 1)
     * @param pageSize 페이지 당 항목 수 (기본값 10)
     * @param searchType 검색 유형 (이름, ID, 역할, 학과)
     * @param searchKeyword 검색어
     * @param model 모델 객체
     * @return 사용자 목록 JSP 뷰
     */
    @GetMapping("/list")
    public String getUserList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String searchType,
            @RequestParam(required = false) String searchKeyword,
            Model model) {

        // 1. 전체 사용자 수 조회 (검색 조건 적용)
        // 기존의 getTotalUserCount() 대신 countUsersWithSearch() 사용
        int totalCount = userMapper.countUsersWithSearch(searchType, searchKeyword);
        
        // 2. 페이징 계산
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPages == 0) {
            // 결과가 없을 경우 페이지 번호를 1로 설정 (list.jsp의 0 방지 EL 처리와 연동)
            totalPages = 1; 
        }

        // 현재 페이지가 전체 페이지 수를 초과하지 않도록 보정
        int currentPage = Math.min(page, totalPages);
        if (currentPage < 1) {
            currentPage = 1;
        }

        int offset = (currentPage - 1) * pageSize;

        // 페이징 블록 계산
        int pageBlock = 10;
        int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
        int endPage = Math.min(startPage + pageBlock - 1, totalPages);
        
        // 3. 사용자 목록 조회 (페이징 및 검색 조건 적용)
        // 기존의 findUsersWithDepartment(int, int) 대신 selectUsersWithPagingAndSearch() 사용
        List<User> userList = userMapper.selectUsersWithPagingAndSearch(offset, pageSize, searchType, searchKeyword);
        
        // 4. 모델에 데이터 추가
        model.addAttribute("userList", userList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        
        // 검색 파라미터를 JSP에 다시 전달하여 검색어/검색 타입이 유지되도록 함
        model.addAttribute("searchType", searchType);
        model.addAttribute("searchKeyword", searchKeyword);

        // list.jsp 뷰로 이동
        return "admin/user/list"; 
    }
}