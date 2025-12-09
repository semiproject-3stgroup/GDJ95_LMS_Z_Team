<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="sidebar">

    <div class="sidebar-title">메인</div>
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/home">대시보드</a></li>
    </ul>


    <!-- ===========================
         공통 메뉴 (학생 / 교수 / 관리자 모두)
         =========================== -->
    <div class="sidebar-title" style="margin-top: 16px;">수업</div>
    <ul class="sidebar-menu">

        <!-- 공지사항: 모두 공통 -->
        <li><a href="${pageContext.request.contextPath}/notice/list">공지사항</a></li>

        <!-- 학생만: 수강신청, 학점조회 -->
        <c:if test="${loginUser.role == 'STUDENT'}">
            <li><a href="#">수강신청</a></li>
            <li><a href="${pageContext.request.contextPath}/user/mypage/score">학점조회</a></li>
        </c:if>

        <!-- 교수만: 강의 관리, 과제 관리 -->
        <c:if test="${loginUser.role == 'PROF'}">
            <li><a href="${pageContext.request.contextPath}/calendar/prof">강의/과제 캘린더</a></li>
            <li><a href="#">과제 채점</a></li>
        </c:if>

        <!-- 관리자만: 학사일정, 학과관리 -->
        <c:if test="${loginUser.role == 'ADMIN'}">
            <li><a href="${pageContext.request.contextPath}/admin/events">학사일정 관리</a></li>
        </c:if>
    </ul>


    <!-- ===========================
         관리 메뉴 (역할별 분기)
         =========================== -->
    <div class="sidebar-title" style="margin-top: 16px;">관리</div>
    <ul class="sidebar-menu">

        <!-- 학생용 마이페이지 -->
        <c:if test="${loginUser.role == 'STUDENT'}">
            <li><a href="${pageContext.request.contextPath}/mypage">마이페이지</a></li>
        </c:if>

        <!-- 교수용: 학과별 게시판 + 마이페이지 -->
        <c:if test="${loginUser.role == 'PROF'}">
            <li><a href="${pageContext.request.contextPath}/dept/board">학과별 게시판</a></li>
            <li><a href="${pageContext.request.contextPath}/mypage">마이페이지</a></li>
        </c:if>

        <!-- 관리자용: 학과 관리 + 공지 관리 -->
        <c:if test="${loginUser.role == 'ADMIN'}">
            <li><a href="${pageContext.request.contextPath}/admin/user/list">사용자 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/department">학과 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/notice/list">공지 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/mypage">마이페이지</a></li>
        </c:if>

    </ul>

</nav>
