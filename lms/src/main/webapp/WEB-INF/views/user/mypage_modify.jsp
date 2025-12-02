<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내 정보 수정</title>
    
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>

<h2>내 정보 수정</h2>

<form action="/mypage/edit" method="post">
    <!-- 이름 -->
    <p>
        이름 :
        <input type="text" name="userName" value="${user.userName}">
    </p>

    <!-- 전화번호 -->
    <p>
        전화번호 :
        <input type="text" name="phone" value="${user.phone}">
    </p>

    <!-- 이메일 -->
    <p>
        이메일 :
        <input type="text" name="email" value="${user.email}">
    </p>

    <!-- 우편번호 -->
    <p>
        우편번호 :
        <input type="text" name="zipCode" value="${user.zipCode}">
    </p>

    <!-- 주소 -->
    <p>
        기본주소 :
        <input type="text" name="address1" value="${user.address1}">
    </p>
    <p>
        상세주소 :
        <input type="text" name="address2" value="${user.address2}">
    </p>

    <!-- 학과 (DB 기준 전체 목록) -->
    <p>
        학과 :
        <select name="departmentId">
            <option value="">선택</option>
            <c:forEach var="dept" items="${departmentList}">
                <option value="${dept.departmentId}"
                    <c:if test="${user.departmentId == dept.departmentId}">selected</c:if>>
                    ${dept.departmentName}
                </option>
            </c:forEach>
        </select>
    </p>

    <button type="submit">저장</button>
    <a href="/mypage">취소</a>
</form>

</body>
</html>
