<%@ page language="java" contentType="text/html; charset=UTF-8" 
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>

    <!-- 공통 CSS 적용 -->
    <link rel="stylesheet" href="/css/layout.css">
</head>

<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <main class="content">
        <div class="login-container">
            <h2>로그인</h2>

            <c:if test="${not empty msg}">
                <p class="error-msg">${msg}</p>
            </c:if>

            <form action="/login" method="post" class="login-form">
                <label>아이디</label>
                <input type="text" name="loginId" required>

                <label>비밀번호</label>
                <input type="password" name="password" required>

                <button type="submit">로그인</button>
            </form>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>