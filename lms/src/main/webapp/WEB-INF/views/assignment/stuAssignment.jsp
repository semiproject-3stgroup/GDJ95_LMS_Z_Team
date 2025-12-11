<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>진행 중인 과제</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body class="assignment-page">

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">

    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">

        <div class="page-header">
            <h1 class="page-title">진행 중인 과제</h1>
        </div>

        <p class="assignment-page-sub">
            이번 학기에 수강 중인 과목의 과제들을 한 곳에서 확인할 수 있어요.
            과제명을 클릭하면 상세 내용과 제출 화면으로 이동합니다.
        </p>

        <c:choose>
            <c:when test="${empty assign}">
                <div class="box assignment-list-card">
                    <p class="empty-text">현재 진행 중인 과제가 없습니다.</p>
                </div>
            </c:when>

            <c:otherwise>
                <div class="box assignment-list-card">

                    <div class="box-header">
                        <h2 class="box-title">이번 학기 과제 목록</h2>
                    </div>

                    <c:forEach var="c" items="${list}">
                        <c:set var="first" value="true" />

                        <c:forEach var="a" items="${assign}">
                            <c:if test="${c.courseId == a.courseId}">

                                <c:if test="${first}">
                                    <c:set var="first" value="false" />
                                    <div class="assignment-course-group">
                                        <div class="assignment-course-header">
                                            <div class="assignment-course-name">
                                                ${c.courseName}
                                            </div>
                                        </div>
                                        <div class="assignment-course-body">
                                </c:if>

                                <a href="${pageContext.request.contextPath}/stuAssignmentOne?assignmentId=${a.assignmentId}"
                                   class="assignment-item-link">
                                    <div class="assignment-item">
                                        <div class="assignment-title-row">
                                            <span class="assignment-title">
                                                ${a.assignmentName}
                                            </span>

                                            <c:if test="${not empty a.dDay}">
                                                <span class="dday-pill dday-soon">
                                                    D-${a.dDay}
                                                </span>
                                            </c:if>
                                        </div>

                                        <div class="assignment-meta-row">
                                            <span class="assignment-period">
                                                제출 기간&nbsp;
                                                ${a.startdate} ~ ${a.enddate}
                                            </span>
                                        </div>
                                    </div>
                                </a>

                            </c:if>
                        </c:forEach>

                        <c:if test="${not first}">
                                </div> <!-- .assignment-course-body -->
                            </div>   <!-- .assignment-course-group -->
                        </c:if>

                    </c:forEach>

                </div>
            </c:otherwise>
        </c:choose>

    </main>
</div>

</body>
</html>
