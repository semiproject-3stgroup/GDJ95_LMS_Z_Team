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

    // 내 정보 수정 액션
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
    
    // 회원가입 폼
    @GetMapping("/signup")
    public String signupForm() {
        return "auth/signup";
    }

    // 회원가입 액션
    @PostMapping("/signup")
    public String signup(User user, RedirectAttributes ra) {

        int row = userService.signup(user);

        if (row == 1) {
            ra.addFlashAttribute("msg", "회원가입이 완료되었습니다. 로그인 해주세요.");
            return "redirect:/login";
        } else {
            ra.addFlashAttribute("msg", "회원가입에 실패했습니다. 다시 시도해주세요.");
            return "redirect:/signup";
        }
    }
    
    // 아이디 찾기 폼
    @GetMapping("/find-id")
    public String findIdForm() {
        return "auth/findId";
    }

    // 아이디 찾기 액션
    @PostMapping("/find-id")
    public String findId(
            @RequestParam String userName,
            @RequestParam String email,
            Model model) {

        String loginId = userService.findLoginId(userName, email);

        if (loginId == null) {
            model.addAttribute("errorMsg", "일치하는 회원 정보를 찾을 수 없습니다.");
        } else {
            model.addAttribute("foundLoginId", loginId);
        }

        // 폼에 다시 채워줄 값
        model.addAttribute("userName", userName);
        model.addAttribute("email", email);

        return "auth/findId";
    }
    
    // 비밀번호 찾기 폼
    @GetMapping("/find-password")
    public String findPasswordForm() {
        return "auth/findPassword";
    }

    // 비밀번호 찾기 액션
    @PostMapping("/find-password")
    public String findPassword(
            @RequestParam String loginId,
            @RequestParam String userName,
            @RequestParam String email,
            Model model,
            RedirectAttributes ra) {

        boolean exists = userService.existsUserForPasswordReset(loginId, userName, email);

        if (!exists) {
            model.addAttribute("errorMsg", "일치하는 회원 정보를 찾을 수 없습니다.");
            model.addAttribute("loginId", loginId);
            model.addAttribute("userName", userName);
            model.addAttribute("email", email);
            return "auth/findPassword";
        }

        // 성공 시: 재설정 화면으로 넘김
        ra.addFlashAttribute("infoMsg", "본인 확인이 완료되었습니다. 새 비밀번호를 설정해 주세요.");
        return "redirect:/reset-password?loginId=" + loginId;
    }

    // 비밀번호 재설정 폼
    @GetMapping("/reset-password")
    public String resetPasswordForm(@RequestParam(required = false) String loginId,
                                    Model model) {

        if (loginId == null || loginId.isBlank()) {
            // 직접 URL 치고 들어온 경우 막기
            return "redirect:/find-password";
        }

        model.addAttribute("loginId", loginId);
        return "auth/resetPassword";
    }

    // 비밀번호 재설정 액션
    @PostMapping("/reset-password")
    public String resetPassword(@RequestParam String loginId,
                                @RequestParam String newPassword,
                                @RequestParam String confirmPassword,
                                RedirectAttributes ra,
                                Model model) {

        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("errorMsg", "비밀번호가 일치하지 않습니다.");
            model.addAttribute("loginId", loginId);
            return "auth/resetPassword";
        }

        // 여기서는 간단히 길이만 체크
        if (newPassword.length() < 8 || newPassword.length() > 16) {
            model.addAttribute("errorMsg", "비밀번호는 8~16자여야 합니다.");
            model.addAttribute("loginId", loginId);
            return "auth/resetPassword";
        }

        int row = userService.resetPassword(loginId, newPassword);

        if (row == 1) {
            ra.addFlashAttribute("msg", "비밀번호가 변경되었습니다. 새 비밀번호로 로그인해 주세요.");
            return "redirect:/login";
        } else {
            model.addAttribute("errorMsg", "비밀번호 변경에 실패했습니다. 다시 시도해 주세요.");
            model.addAttribute("loginId", loginId);
            return "auth/resetPassword";
        }
    }
}
