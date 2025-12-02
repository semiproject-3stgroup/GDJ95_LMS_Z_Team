<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>

<h2>마이페이지</h2>

<p>이름 : ${user.userName}</p>
<p>아이디 : ${user.loginId}</p>
<p>역할 : ${user.role}</p>

<c:if test="${user.role == 'STUDENT'}">
    <p>학번 : ${user.studentNo}</p>
</c:if>

<c:if test="${user.role == 'PROF'}">
    <p>교번 : ${user.employeeNo}</p>
</c:if>

<p>학과 : ${user.departmentName}</p>
<p>이메일 : ${user.email}</p>
<p>전화번호 : ${user.phone}</p>

<a href="/mypage/edit">내 정보 수정</a>
<a href="/mypage/password">비밀번호 변경</a>

</body>
</html>
