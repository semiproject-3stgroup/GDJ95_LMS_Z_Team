<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<!-- 공통 레이아웃 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">

        <!-- 왼쪽 사이드바 include -->
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
		
		<!-- 오른쪽 본문 -->
        <main class="main-content">	
			
			<h1>학생출석관리</h1>
			
				<c:forEach var="li" items="${list}">
					${li.studentNo} / ${li.userName}	 <br>					
				</c:forEach>
				
				<form action="${pageContext.request.contextPath}/profAttendanceSave">
				
					<input type="hidden" id="courseId" value="${courseId}">
					<input type="date" id="today" name="date">
					
					<div id="attendance"></div>			
				
				<button type="submit">저장</button> 
				
				</form>
			
		</main>
	</div>
	
	
</body>
<script>
$(function() {
	$('#today').change(()=>{
		const date = $('#today').val();
		const courseId = $('#courseId').val();
		
		$.ajax({
			url: '/rest/profAttendance'
			, type: 'post'
			, data: {
				date : date	
				,courseId : courseId
				}	
			, success: (data) => {
				
				let html = `
						<table border="1">
							<tr>
								<td>학번</td>
								<td>이름</td>
								<td>출석</td>
						`;
				data.forEach(item=>{
					html += `
						<tr>
							<td>\${item.studentNo}</td>
							<td>\${item.userName}</td>
							<td>
							<input type="hidden" name="userIdList" value="\${item.userId}">
	                            <select name="statusList">
	                            <option value="" hidden selected>선택</option>
	                            <option value="1" \${item.attendance == '1' ? 'selected' : ''}>출석</option>
	                            <option value="2" \${item.attendance == '2' ? 'selected' : ''}>지각</option>
	                            <option value="0" \${item.attendance == '0' ? 'selected' : ''}>결석</option>
	                        	</select>
							</td>
                		</tr>
            			`;
				});

				html += `</table>`;		
				
				$('#attendance').html(html);
			}			
			, error: () => {
				alert('실패');
			}				
			});
		});	
	
	
	
	
})
</script>

</html>