<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>과제 관리</title>

    <!-- 공통 레이아웃 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
   
   <style>
    /* 리스트 전체 기본 스타일 */
    .notice-list {
        list-style: none;
        margin: 0;
        padding: 0;
    }

    /* 한 줄(제목 + 날짜)을 가로 배치 */
    .notice-list li {
        display: flex;
        align-items: center;
        padding: 6px 0;
        border-bottom: 1px solid #e5e7eb;
    }

    /* 제목 영역(왼쪽 영역) */
    .notice-list a {
        flex: none;                  /* 확장 금지 → 테이블처럼 보이게 */
        width: 250px;                /* 제목 칸 폭 */
        text-decoration: none;
        color: #374151;
        font-size: 15px;
        transition: color 0.15s ease;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;     /* 너무 길면 ... 처리 */
    }

    /* hover 시 제목 강조 */
    .notice-list a:hover {
        color: #2563eb;
        text-decoration: underline;
    }

    /* 날짜 영역(오른쪽 영역) */
    .assignment-date {
        width: 150px;                /* 날짜 칸 폭 */
        text-align: right;
        font-size: 12px;
        color: #6b7280;
        margin-left: 8px;
        white-space: nowrap;
    }

    /* 마감 배지 */
    .deadline-badge {
        color: #dc2626;
        font-weight: 700;
        margin-left: 4px;
    }
</style>


</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">

        <!-- 왼쪽 사이드바 include -->
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

        <!-- 오른쪽 본문 -->
        <main class="main-content">

            <!-- 공통 페이지 타이틀 클래스 사용 -->
            <h1 class="page-title">과제</h1>

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
                                    <span class = "assignment-date">
                                        ${a.startdate} ~ ${a.enddate}
	                                    <c:if test="${a.over}">
										    <span class="deadline-badge">마감</span>
										</c:if>
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