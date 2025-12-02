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
                // 아이디 / 비밀번호 찾기
                "/find-id",
                "/find-password",
                "/reset-password"
        );
    }
}