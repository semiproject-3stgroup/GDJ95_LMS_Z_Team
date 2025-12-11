<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>수강생 목록</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">

    <style>
        .student-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .student-table th,
        .student-table td {
            padding: 12px 16px;
        }
        .student-table th {
            background-color: #f4f4f4;
            border-bottom: 1px solid #e0e0e0;
            font-weight: 600;
        }
        .student-table td {
            border-bottom: 1px solid #f0f0f0;
        }
        .student-table tr:nth-child(even) td {
            background-color: #fafafa;
        }
        .student-table tr:hover td {
            background-color: #f1f5f9;
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">

    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">

        <h2 class="page-title">
            수강생 목록 - ${course.courseName}
            (${course.courseYear}년 ${course.courseSemester})
        </h2>

        <div style="margin-bottom: 12px;">
            <a href="${pageContext.request.contextPath}/course/prof"
               class="home-btn secondary"
               style="margin-right: 8px;">
                ← 담당 강의 목록으로
            </a>

            <a href="${pageContext.request.contextPath}/profScoring?courseId=${course.courseId}"
               class="home-btn primary"
               style="margin-right: 6px;">
                성적 관리
            </a>

            <a href="${pageContext.request.contextPath}/profAttendance?courseId=${course.courseId}"
               class="home-btn outline">
                출석 관리
            </a>
            
            <a href="${pageContext.request.contextPath}/profAssignment?courseId=${course.courseId}"
			   class="home-btn secondary"
			   style="margin-right: 6px;">
			    과제 관리
			</a>
        </div>

        <c:choose>
            <c:when test="${empty students}">
                <div class="box">
                    <p class="empty-text">이 강의를 수강 중인 학생이 없습니다.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table class="student-table">
                    <thead>
                    <tr>
                        <th>학번</th>
                        <th>이름</th>
                        <th>학과</th>
                        <th>연락처</th>
                        <th>이메일</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="s" items="${students}">
                        <tr>
                            <td>${s.studentNo}</td>
                            <td>${s.userName}</td>
                            <td>${s.departmentName}</td>
                            <td>${s.phone}</td>
                            <td>${s.email}</td>
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
