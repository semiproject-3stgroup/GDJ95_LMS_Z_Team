package com.example.lms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping({"/", "/home"})
    public String home() {
        // 나중에 메인에 뿌릴 데이터 있으면 Model 써서 넘기면 됨
        return "home";
    }
}