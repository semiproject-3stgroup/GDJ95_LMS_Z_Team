<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>성적 관리</title>
	<!-- 공통 레이아웃 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">       

    <style>
        .main-content {
            padding: 40px;
        }

        .score-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;

            background-color: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        .score-table th,
        .score-table td {
            padding: 12px 16px;
        }

        .score-table th {
            background-color: #f4f4f4;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
            font-weight: 600;
        }

        .score-table td {
            border-bottom: 1px solid #f0f0f0;
        }

        .score-table tr:nth-child(even) td {
            background-color: #fafafa;
        }

        .score-table tr:hover td {
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
                성적 관리
                <c:if test="${not empty course}">
                    - ${course.courseName} (${course.courseYear}년 ${course.courseSemester})
                </c:if>
            </h2>

            <div style="margin-bottom: 16px;">
                <a href="${pageContext.request.contextPath}/course/prof"
                   class="home-btn secondary">
                    ← 담당 강의 목록으로
                </a>
                <c:if test="${not empty course}">
                    <a href="${pageContext.request.contextPath}/course/prof/students?courseId=${course.courseId}"
                       class="home-btn outline"
                       style="margin-left: 8px;">
                        수강생 목록
                    </a>
                </c:if>
            </div>

            <table class="score-table">
                <tr>
                    <th>학번</th>
                    <th>이름</th>
                    <th>중간고사</th>
                    <th>기말고사</th>
                    <th>과제</th>
                    <th>출석</th>
                    <th>총점</th>
                    <th>등급</th>
                </tr>

                <c:forEach var="li" items="${list}">
                    <tr>
                        <td>${li.studentNo}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/profScoringOne?userId=${li.userId}&courseId=${li.courseId}&userName=${li.userName}">
                                ${li.userName}
                            </a>
                        </td>
                        <td>${li.exam1Score}</td>
                        <td>${li.exam2Score}</td>
                        <td>${li.assignmentScore}</td>
                        <td>${li.attendanceScore}</td>
                        <td>${li.scoreTotal}</td>
                        <td>${not empty li.scoreTotal ? li.grade : ""}</td>
                    </tr>
                </c:forEach>
            </table>
					
		</main>
	</div>
</body>
</html>
