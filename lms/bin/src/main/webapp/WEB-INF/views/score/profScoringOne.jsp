<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	
		<h1>?학생성적</h1>
		
			<label>중간</label>	
			<input type="number" min="0" max="100" >			
			<label>기말</label>
			<input type="number" min="0" max="100" >
			<label>과제</label>
			<input type="number" min="0" max="100" >
			<label>출석</label>
			<input type="number" min="0" max="100" >
			
			<label>총점</label>
			<input type="number" min="0" max="100" >
		
		</main>
	</div>
</body>
</html>