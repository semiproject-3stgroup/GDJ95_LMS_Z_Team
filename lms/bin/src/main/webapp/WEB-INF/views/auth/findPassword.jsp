<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
    <link rel="stylesheet" href="/css/auth.css">
</head>
<body>

<div class="auth-page">
    <div class="auth-card">

        <h2>비밀번호 찾기</h2>
        <p class="subtitle">
            회원가입 시 등록한 <strong>아이디</strong>, <strong>이름</strong>, <strong>이메일</strong>을 입력해 주세요.
        </p>

        <c:if test="${not empty errorMsg}">
            <div class="alert error">
                ${errorMsg}
            </div>
        </c:if>

        <c:if test="${not empty infoMsg}">
            <div class="alert success">
                ${infoMsg}
            </div>
        </c:if>

        <form action="/find-password" method="post" class="form-vertical">

            <div class="form-group">
                <label>아이디<span class="req">*</span></label>
                <input type="text" name="loginId" value="${loginId}" required>
            </div>

            <div class="form-group">
                <label>이름<span class="req">*</span></label>
                <input type="text" name="userName" value="${userName}" required>
            </div>

            <div class="form-group">
                <label>이메일<span class="req">*</span></label>
                <input type="email" name="email" value="${email}" required>
            </div>

            <div class="btn-row">
                <a href="/login" class="btn-secondary">로그인 화면으로</a>
                <button type="submit" class="btn-primary">다음 단계</button>
            </div>
        </form>

    </div>
</div>

</body>
</html>
