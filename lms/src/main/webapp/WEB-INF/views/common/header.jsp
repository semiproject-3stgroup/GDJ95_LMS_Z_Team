<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="site-header">
    <div class="site-header-left">
        <div class="site-logo">L</div>
        <div>
            <span class="site-title-main">LMS 학사관리 시스템</span>
            <span class="site-title-sub">GDJ95 Z팀</span>
        </div>
    </div>

    <div class="site-header-right">
        <c:choose>
            <c:when test="${not empty loginUser}">
                <span>
                    ${loginUser.departmentName}
                    /
                    ${loginUser.userName}
                    /
                    ${loginUser.studentNo}
                </span>

                <a href="${pageContext.request.contextPath}/mypage">마이페이지</a>
                <a href="${pageContext.request.contextPath}/logout">로그아웃</a>
            </c:when>

            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login">로그인</a>
                <a href="${pageContext.request.contextPath}/findId">아이디 찾기</a>
                <a href="${pageContext.request.contextPath}/resetPassword">비밀번호 초기화</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>