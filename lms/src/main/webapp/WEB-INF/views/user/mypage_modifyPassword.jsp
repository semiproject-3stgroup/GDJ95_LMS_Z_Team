<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 변경</title>
    
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>

<h2>비밀번호 변경</h2>

<c:if test="${not empty errorMsg}">
    <p style="color:red;">${errorMsg}</p>
</c:if>

<form action="/mypage/password" method="post">
    <p>
        현재 비밀번호 :
        <input type="password" name="currentPassword">
    </p>
    <p>
        새 비밀번호 :
        <input type="password" name="newPassword">
    </p>
    <p>
        새 비밀번호 확인 :
        <input type="password" name="confirmPassword">
    </p>

    <button type="submit">변경</button>
    <a href="/mypage">취소</a>
</form>

</body>
</html>
