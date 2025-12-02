package com.example.lms.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
    private DepartmentService departmentService; // 

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

        // 학과 목록 추가
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

    // 비밀번호 변경 폼
    @GetMapping("/mypage/password")
    public String passwordForm() {
        return "user/mypage_modifyPassword";   // 폴더/파일명 그대로
    }

    // 비밀번호 변경 액션
    @PostMapping("/mypage/password")
    public String changePassword(
            @RequestParam("currentPassword") String currentPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("newPasswordConfirm") String newPasswordConfirm,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        // 세션에서 User 객체로 꺼내기
        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            redirectAttributes.addFlashAttribute("msg", "로그인 후 이용 가능합니다.");
            return "redirect:/login";
        }

        Long loginUserId = loginUser.getUserId();

        // 새 비밀번호 동일 여부 확인
        if (!newPassword.equals(newPasswordConfirm)) {
            redirectAttributes.addFlashAttribute("msg", "새 비밀번호 확인이 일치하지 않습니다.");
            return "redirect:/mypage/password";
        }

        // 숫자 + 특수문자 포함 8~16자 정규식 체크
        String pwPattern = "^(?=.*[0-9])(?=.*[!@#$%^&*(),.?\":{}|<>_+=\\-]).{8,16}$";
        if (!newPassword.matches(pwPattern)) {
            redirectAttributes.addFlashAttribute("msg",
                    "비밀번호는 숫자 + 특수문자 포함 8~16자 이어야 합니다.");
            return "redirect:/mypage/password";
        }

        // 실제 비밀번호 변경
        boolean success = userService.changePassword(loginUserId, currentPassword, newPassword);

        if (!success) {
            redirectAttributes.addFlashAttribute("msg", "현재 비밀번호가 일치하지 않습니다.");
            return "redirect:/mypage/password";
        }

        redirectAttributes.addFlashAttribute("msg", "비밀번호가 변경되었습니다");
        return "redirect:/mypage/password";
    }
    
    // 마이페이지로
    @GetMapping("/user/mypage")
    public String redirectMypage() {
        return "redirect:/mypage";
    }
    
}
