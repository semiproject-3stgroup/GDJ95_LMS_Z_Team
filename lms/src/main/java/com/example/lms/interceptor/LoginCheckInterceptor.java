package com.example.lms.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;

import com.example.lms.dto.User;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class LoginCheckInterceptor implements HandlerInterceptor {
	
    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        HttpSession session = request.getSession(false);

        // 로그인 여부 체크
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        // 권한(role) 체크
        String role = loginUser.getRole();   // STUDENT / PROF / ADMIN
        String uri  = request.getRequestURI();
        String ctx  = request.getContextPath();
        
        log.debug("Interceptor - uri = {}, role = {}", uri, role);

        // 관리자 전용 URL
        if (uri.startsWith(ctx + "/admin")) {
            if (!"ADMIN".equals(role)) {
                response.sendRedirect(ctx + "/access-denied");
                return false;
            }
        }

        // 공지 등록 접근 관리자만 허용 (/notice/add GET, POST 둘 다)
        if (uri.startsWith(ctx + "/notice/add")) {
            if (!"ADMIN".equals(role)) {
                response.sendRedirect(ctx + "/access-denied");
                return false;
            }
        }

        // 교수 전용 URL
        if (uri.startsWith(ctx + "/prof")) {
            if (!"PROF".equals(role) && !"ADMIN".equals(role)) {
                response.sendRedirect(ctx + "/access-denied");
                return false;
            }
        }

        // 학생 전용 URL
        if (uri.startsWith(ctx + "/student")) {
            if (!"STUDENT".equals(role) && !"ADMIN".equals(role)) {
                response.sendRedirect(ctx + "/access-denied");
                return false;
            }
        }

        return true;
    }
}
