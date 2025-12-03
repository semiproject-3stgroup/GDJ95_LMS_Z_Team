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
			<h1>과제수정</h1>
			
			<form>
				<input type="text" name="assignmentId" value="${assignment.assignmentId}" hidden>
				<label>제목</label>
				<input type="text" name="assignmentName" value="${assignment.assignmentName}">
				<label>기간</label>
				<input type="date" name="startdate" value="${assignment.startdate}"> ~ <input type="date" name="enddate" value="${assignment.enddate}">
				<label>내용</label>
				<textarea name="assignmentContent">${assignment.assignmentContent}</textarea>
				
				<button type="button" id="btn">저장</button>
			</form>			
		</main>
	</div>
</body>
<script>
	$('#btn').click(()=>{
		$('form').attr({
			method: 'post'
			, action: '${pageContext.request.contextPath}/profAssignmentModify'
		});
		$('form').submit();
	});
</script>
</html>