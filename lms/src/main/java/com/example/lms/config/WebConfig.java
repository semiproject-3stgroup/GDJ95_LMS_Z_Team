package com.example.lms.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.example.lms.interceptor.LoginCheckInterceptor;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        registry.addInterceptor(new LoginCheckInterceptor())
        .addPathPatterns("/**")  // 전체에 인터셉터 적용
        .excludePathPatterns(
        		"/", "/home",
                "/login", "/logout",
                "/signup",
                "/css/**", "/js/**", "/images/**", "/webjars/**",
                "/error",
                "/find-id",
                "/find-password",
                "/reset-password",
                "/calendar",              // 진입점 (비로그인 → academic 으로 redirect)
                "/calendar/academic",     // 학사 일정 캘린더 화면
                "/api/calendar/events"    // 학사 일정 JSON
        );
    }
}