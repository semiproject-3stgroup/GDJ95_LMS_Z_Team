<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>교수 과제 관리</title>

    <!-- 공통 레이아웃 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">

        <!-- 왼쪽 사이드바 include -->
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

        <!-- 오른쪽 본문 -->
        <main class="main-content">

            <!-- 공통 페이지 타이틀 클래스 사용 -->
            <h1 class="page-title">교수 과제 관리</h1>

            <!-- 박스(card) 하나로 과제 목록 감싸기 -->
            <div class="box">
                <c:forEach var="c" items="${course}">
                    <!-- 과목 이름 -->
                    <h3 style="margin-bottom: 6px;">${c.courseName}</h3>

                    <!-- 공통 리스트 스타일 활용 (layout.css 의 .notice-list) -->
                    <ul class="notice-list">
                        <c:forEach var="a" items="${list}">
                            <c:if test="${c.courseName == a.courseName}">
                                <li>
                                    <a href="${pageContext.request.contextPath}/profAssignmentOne?assignmentId=${a.assignmentId}">
                                        ${a.assignmentName}
                                    </a>
                                    <span style="font-size: 12px; color:#6b7280; margin-left:8px;">
                                        ${a.startdate} ~ ${a.enddate}
                                    </span>
                                </li>
                            </c:if>
                        </c:forEach>
                    </ul>

                    <hr>
                </c:forEach>

                <!-- 공통 버튼 스타일 사용 -->
                <a href="${pageContext.request.contextPath}/profAssignmentAdd"
                   class="btn btn-primary"
                   style="margin-top: 12px;">
                    과제 등록하기
                </a>
            </div>

        </main>
    </div>
</body>
</html>