package com.example.lms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.lms.dto.User;
import com.example.lms.service.UserService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class LoginController {

    @Autowired
    private UserService userService;

    // 로그인 폼
    @GetMapping("/login")
    public String loginForm() {
        return "login"; // login.jsp
    }

    // 로그인 처리
    @PostMapping("/login")
    public String login(User user, HttpSession session, Model model) {

        User loginUser = userService.login(user);

        if (loginUser == null) {
            model.addAttribute("msg", "아이디 또는 비밀번호가 틀렸습니다.");
            return "login";
        }
        
        // 디버그 
        log.debug("loginUser = {}", loginUser);
        // 로그인 성공 → 세션에 저장
        session.setAttribute("loginUser", loginUser);

        return "redirect:/home";
    }

    // 로그아웃
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/home";
    }
}