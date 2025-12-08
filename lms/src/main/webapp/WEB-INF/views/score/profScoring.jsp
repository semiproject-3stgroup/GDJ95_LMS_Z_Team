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
			
			<c:forEach var="li" items="${list}">
				<a href="${pageContext.request.contextPath}/profScoringOne?userId=${li.userId}&courseId=${li.courseId}">${li.studentNo} / ${li.userName} </a> <br>
			</c:forEach>
					
		</main>
	</div>
</body>
</html>