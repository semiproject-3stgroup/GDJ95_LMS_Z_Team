<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
    <!-- CSS 로딩 -->
    <link rel="stylesheet" href="/css/layout.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">

        <!-- 왼쪽 사이드바 include -->
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
		
		<!-- 오른쪽 본문 -->
        <main class="main-content">	

			<h1>one</h1>
		
				<label>제목</label>
				${assignment.assignmentName}
				
				<label>작성일</label>
					<c:if test="${assignment.updatedate!=null}">
						${assignment.updatedate}
					</c:if>
					<c:if test="${assignment.updatedate==null}">
						${assignment.createdate}
					</c:if>
				<label>내용</label>
				${assignment.assignmentContent}
				<label>기간</label>
				${assignment.startdate} ~ ${assignment.enddate} 		

				<hr>

				<label>제출여부</label>
				

																																															
		</main>
	</div>
		
</body>
</html>