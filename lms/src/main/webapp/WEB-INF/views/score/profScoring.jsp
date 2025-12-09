<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
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
			
			<h1>학생성적관리</h1>
				<table border="1">
					<tr>
						<td>학번</td>
						<td>이름</td>
						<td>중간고사</td>
						<td>기말고사</td>
						<td>과제</td>
						<td>출석</td>
						<td>총점</td>
					</tr>
					
				<c:forEach var="li" items="${list}">
					<tr>
						<td>${li.studentNo}</td>
						<td>
							<a href="${pageContext.request.contextPath}/profScoringOne?userId=${li.userId}&courseId=${li.courseId}">
								${li.userName}
							</a>
						</td>
						<td>${li.exam1Score}</td>
						<td>${li.exam2Score}</td>
						<td>${li.assignmentScore}</td>
						<td>${li.attendanceScore}</td>
						<td>${li.scoreTotal}</td>
					</tr>
				</c:forEach>
				</table>
					
		</main>
	</div>
</body>
</html>