<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>담당 강의 목록</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">

    <style>
        .course-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .course-table th,
        .course-table td {
            padding: 12px 16px;
        }
        .course-table th {
            background-color: #f4f4f4;
            border-bottom: 1px solid #e0e0e0;
            font-weight: 600;
        }
        .course-table td {
            border-bottom: 1px solid #f0f0f0;
        }
        .course-table tr:nth-child(even) td {
            background-color: #fafafa;
        }
        .course-table tr:hover td {
            background-color: #f1f5f9;
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">

    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">
        <h2 class="page-title">담당 강의 목록</h2>

        <!-- 연도/학기 필터 -->
        <form method="get"
              action="${pageContext.request.contextPath}/course/prof"
              class="course-filter-form">
            <label>
                학년도
                <select name="year">
                    <c:forEach var="y" items="${yearList}">
                        <option value="${y}" <c:if test="${year == y}">selected</c:if>>${y}</option>
                    </c:forEach>
                </select>
            </label>

            <label>
                학기
                <select name="semester">
                    <c:forEach var="sem" items="${semesterList}">
                        <option value="${sem}" <c:if test="${semester == sem}">selected</c:if>>${sem}</option>
                    </c:forEach>
                </select>
            </label>

            <button type="submit" class="home-btn secondary">
                필터 적용
            </button>
        </form>

        <c:choose>
            <c:when test="${empty courseList}">
                <div class="box" style="margin-top: 16px;">
                    <p class="empty-text">해당 학기에 담당 중인 강의가 없습니다.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table class="course-table">
                    <thead>
                    <tr>
                        <th>학년도</th>
                        <th>학기</th>
                        <th>강의명</th>
                        <th>학점</th>
                        <th>정원</th>
                        <th>상태</th>
                        <th style="width: 280px;">관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="c" items="${courseList}">
                        <tr>
                            <td>${c.courseYear}</td>
                            <td>${c.courseSemester}</td>
                            <td>${c.courseName}</td>
                            <td>${c.credit}</td>
                            <td>${c.maxCapacity}</td>
                            <td>${c.status}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/course/prof/students?courseId=${c.courseId}"
                                   class="home-btn secondary">
                                    수강생 목록
                                </a>
                                <a href="${pageContext.request.contextPath}/profScoring?courseId=${c.courseId}"
                                   class="home-btn primary"
                                   style="margin-left: 6px;">
                                    성적 관리
                                </a>
                                <a href="${pageContext.request.contextPath}/profAttendance?courseId=${c.courseId}"
                                   class="home-btn outline"
                                   style="margin-left: 6px;">
                                    출석 관리
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>

    </main>
</div>

</body>
</html>
