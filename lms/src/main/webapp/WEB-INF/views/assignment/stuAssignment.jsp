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
        	
        	<h1>학생 과제목록</h1>	
			<c:forEach var="c" items="${list}">
				${c.courseName}<br>
				<c:forEach var="a" items="${assign}">
					<c:if test="${c.courseId==a.courseId}">
						<a href="${pageContext.request.contextPath}/stuAssignmentOne?assignmentId=${a.assignmentId}">${a.assignmentName}</a> : ${a.startdate} ~ ${a.enddate}<br>					
					</c:if>
				</c:forEach>
			</c:forEach>
		</main>
	</div>
	
</body>
</html>