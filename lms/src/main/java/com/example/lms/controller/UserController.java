package com.example.lms.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.lms.dto.Department;
import com.example.lms.dto.User;
import com.example.lms.service.DepartmentService;
import com.example.lms.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {

    @Autowired
    private UserService userService;
    
    @Autowired
    private DepartmentService departmentService; // ★ 추가

    // 마이페이지 메인
    @GetMapping("/mypage")
    public String mypage(HttpSession session, Model model) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/login";

        User user = userService.getMyInfo(loginUser.getUserId());
        model.addAttribute("user", user);

        return "user/mypage";
    }

    // 내 정보 수정 폼
    @GetMapping("/mypage/edit")
    public String mypageEditForm(HttpSession session, Model model) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/login";

        User user = userService.getMyInfo(loginUser.getUserId());
        model.addAttribute("user", user);

        // ★ 학과 목록 추가
        List<Department> deptList = departmentService.getDepartmentList();
        model.addAttribute("departmentList", deptList);

        return "user/mypage_modify";
    }

    // 내 정보 수정 처리
    @PostMapping("/mypage/edit")
    public String mypageEditAction(User formUser, HttpSession session) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/login";

        formUser.setUserId(loginUser.getUserId());
        userService.updateMyInfo(formUser);

        // 세션 정보 갱신
        session.setAttribute("loginUser", userService.getMyInfo(loginUser.getUserId()));

        return "redirect:/mypage";
    }

    @GetMapping("/mypage/password")
    public String mypagePasswordForm(HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login";

        // /WEB-INF/views/user/mypage_modifyPassword.jsp
        return "user/mypage_modifyPassword";
    }

    // 비밀번호 변경 처리
    @PostMapping("/mypage/password")
    public String mypagePasswordAction(
            @RequestParam String currentPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            HttpSession session,
            Model model
    ) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/login";

        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("errorMsg", "새 비밀번호와 확인 비밀번호가 달라!");
            return "user/mypage_modifyPassword";
        }

        boolean success = userService.changePassword(loginUser.getUserId(), currentPassword, newPassword);

        if (!success) {
            model.addAttribute("errorMsg", "현재 비밀번호가 맞지 않아!");
            return "user/mypage_modifyPassword";
        }
        return "redirect:/mypage";
    }
}
