<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="sidebar">
    <div class="sidebar-title">메인</div>
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/home">대시보드</a></li>
    </ul>

    <div class="sidebar-title" style="margin-top: 16px;">수업</div>
    <ul class="sidebar-menu">
        <li><a href="#">공지사항</a></li>
        <li><a href="#">수강신청</a></li>
        <li><a href="#">학점조회</a></li>
    </ul>

    <div class="sidebar-title" style="margin-top: 16px;">관리</div>
    <ul class="sidebar-menu">
        <li><a href="#">학과 관리</a></li>
        <li><a href="#">학과별 게시판</a></li>
        <li><a href="#">마이페이지</a></li>
    </ul>
</nav>
