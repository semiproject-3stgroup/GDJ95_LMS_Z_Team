<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기</title>
    <link rel="stylesheet" href="/css/auth.css">
</head>
<body>

<div class="auth-page">
    <div class="auth-card">

        <h2>아이디 찾기</h2>
        <p class="subtitle">
            회원가입 시 등록한 <strong>이름</strong>과 <strong>이메일</strong>을 입력해 주세요.
        </p>

        <!-- 결과 메시지 영역 -->
        <c:if test="${not empty foundLoginId}">
            <div class="alert success">
                <p>회원님의 아이디는 다음과 같습니다.</p>
                <p class="result-id">${foundLoginId}</p>
            </div>
        </c:if>

        <c:if test="${not empty errorMsg}">
            <div class="alert error">
                ${errorMsg}
            </div>
        </c:if>

        <!-- 아이디 찾기 폼 -->
        <form action="/find-id" method="post" class="form-vertical">

            <div class="form-group">
                <label>이름<span class="req">*</span></label>
                <input type="text" name="userName"
                       value="${userName}" required>
            </div>

            <div class="form-group">
                <label>이메일<span class="req">*</span></label>
                <input type="email" name="email"
                       value="${email}" required
                       placeholder="example@university.ac.kr">
            </div>

            <div class="btn-row">
                <a href="/login" class="btn-secondary">로그인 화면으로</a>
                <button type="submit" class="btn-primary">아이디 찾기</button>
            </div>
        </form>

    </div>
</div>

</body>
</html>
