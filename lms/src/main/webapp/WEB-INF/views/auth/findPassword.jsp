<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<main class="auth-main">

    <div class="auth-card">

        <h1 class="auth-title">비밀번호 찾기</h1>
        <p class="auth-subtitle">
            회원가입 시 등록한 정보를 입력해주세요.
        </p>

        <form method="post" action="${pageContext.request.contextPath}/find-password" class="auth-form">

            <div class="auth-field">
                <label for="loginId">아이디</label>
                <input type="text"
                       id="loginId"
                       name="loginId"
                       class="auth-input"
                       required>
            </div>

            <div class="auth-field">
                <label for="userName">이름</label>
                <input type="text"
                       id="userName"
                       name="userName"
                       class="auth-input"
                       required>
            </div>

            <div class="auth-field">
                <label for="email">이메일</label>
                <input type="email"
                       id="email"
                       name="email"
                       class="auth-input"
                       required>
            </div>

            <button type="submit" class="btn btn-primary auth-submit">
                다음 단계
            </button>
        </form>

        <div class="auth-meta">
            <div class="auth-meta-links">
                <a href="${pageContext.request.contextPath}/login" class="auth-link">
                    로그인 화면으로
                </a>
            </div>
            <div class="auth-meta-sub">
                계정이 기억나지 않나요?
                <a href="${pageContext.request.contextPath}/find-id" class="auth-link-strong">
                    아이디 찾기
                </a>
            </div>
        </div>

    </div>

</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
