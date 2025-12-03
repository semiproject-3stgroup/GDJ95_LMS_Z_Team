<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>

    <!-- CSS 로딩 -->
    <link rel="stylesheet" href="/css/layout.css">
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">

        <!-- 왼쪽 사이드바 include -->
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
		
		<!-- 오른쪽 본문 -->
        <main class="main-content">
	
			<h1>교수과제관리</h1>
			<c:forEach var="c" items="${course}">
				${c.courseName}<br>
				<c:forEach var="a" items="${list}">
					<c:if test="${c.courseName==a.courseName}">
						<a href="${pageContext.request.contextPath}/profAssignmentOne?assignmentId=${a.assignmentId}">${a.assignmentName}</a> ${a.startdate}, ${a.enddate}<br>
					</c:if>			
				</c:forEach>
				<hr>							
			</c:forEach>
												
			<a href="${pageContext.request.contextPath}/profAssignmentAdd">등록</a>						
		</main>
	</div>
</body>
</html>