<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인 | LMS 학사관리 시스템</title>

    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>

<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <!-- 🔹 로그인 전용 레이아웃 -->
    <main class="auth-main">
        <section class="auth-card login-card">
            <h1 class="auth-title">로그인</h1>
            <p class="auth-subtitle">
                학사 일정, 수업, 과제, 성적을 한 번에 관리해보세요.
            </p>

            <!-- 에러 메시지 -->
            <c:if test="${not empty msg}">
                <p class="auth-error">${msg}</p>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post" class="auth-form">
                <div class="auth-field">
                    <label for="loginId">아이디</label>
                    <input type="text" id="loginId" name="loginId"
                           class="auth-input" required>
                </div>

                <div class="auth-field">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password"
                           class="auth-input" required>
                </div>

                <button type="submit"
                        class="home-btn primary auth-submit">
                    로그인
                </button>
            </form>

            <!-- 하단 링크: 아이디 찾기 / 비밀번호 재설정 / 회원가입 -->
            <div class="auth-meta">
                <div class="auth-meta-links">
                    <a href="${pageContext.request.contextPath}/find-id" class="auth-link">
                        아이디 찾기
                    </a>
                    <span class="auth-meta-sep">·</span>
                    <a href="${pageContext.request.contextPath}/reset-password" class="auth-link">
                        비밀번호 재설정
                    </a>
                </div>

                <div class="auth-meta-sub">
                    아직 계정이 없나요?
                    <a href="${pageContext.request.contextPath}/signup" class="auth-link-strong">
                        회원가입
                    </a>
                </div>
            </div>
        </section>
    </main>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
