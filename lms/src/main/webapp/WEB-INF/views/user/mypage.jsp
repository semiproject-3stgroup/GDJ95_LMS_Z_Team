<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>

    <!-- 공통 레이아웃 CSS -->
    <link rel="stylesheet" href="/css/layout.css">

    <!-- 마이페이지 CSS -->
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="content">

        <div class="mypage-card">
            <div class="mypage-title">마이페이지</div>
            <div class="mypage-subtitle">
                내 계정 정보를 확인할 수 있습니다.
            </div>

            <div class="mypage-info-row">
                <span class="mypage-info-label">이름</span>
                <span class="mypage-info-value">${user.userName}</span>
            </div>

            <div class="mypage-info-row">
                <span class="mypage-info-label">아이디</span>
                <span class="mypage-info-value">${user.loginId}</span>
            </div>

            <div class="mypage-info-row">
                <span class="mypage-info-label">역할</span>
                <span class="mypage-info-value">
                    <c:choose>
                        <c:when test="${user.role == 'STUDENT'}">학생</c:when>
                        <c:when test="${user.role == 'PROF'}">교수</c:when>
                        <c:when test="${user.role == 'ADMIN'}">관리자</c:when>
                        <c:otherwise>${user.role}</c:otherwise>
                    </c:choose>
                </span>
            </div>

            <c:if test="${user.role == 'STUDENT'}">
                <div class="mypage-info-row">
                    <span class="mypage-info-label">학번</span>
                    <span class="mypage-info-value">${user.studentNo}</span>
                </div>
            </c:if>

            <c:if test="${user.role == 'PROF'}">
                <div class="mypage-info-row">
                    <span class="mypage-info-label">교번</span>
                    <span class="mypage-info-value">${user.employeeNo}</span>
                </div>
            </c:if>

            <div class="mypage-info-row">
                <span class="mypage-info-label">학과</span>
                <span class="mypage-info-value">${user.departmentName}</span>
            </div>

            <div class="mypage-info-row">
                <span class="mypage-info-label">이메일</span>
                <span class="mypage-info-value">${user.email}</span>
            </div>

            <div class="mypage-info-row">
                <span class="mypage-info-label">전화번호</span>
                <span class="mypage-info-value">${user.phone}</span>
            </div>

            <div class="mypage-info-row">
                <span class="mypage-info-label">주소</span>
                <span class="mypage-info-value">
                    (${user.zipCode}) ${user.address1} ${user.address2}
                </span>
            </div>

            <div class="mypage-btn-area">
                <button type="button"
                        class="mypage-btn-primary"
                        onclick="location.href='/mypage/edit';">
                    내 정보 수정
                </button>

                <button type="button"
                        class="mypage-btn-secondary"
                        onclick="location.href='/mypage/password';">
                    비밀번호 변경
                </button>
            </div>
        </div>

    </main>
</div>

</body>
</html>
