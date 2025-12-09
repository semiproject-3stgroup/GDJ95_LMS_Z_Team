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
			
				<table border="1">
					<tr>
						<th>학번</th>
						<th>이름</th>
						<th>출석</th>
						<th>지각</th>
						<th>결석</th>
						<th>출석률</th>
					</tr>
				<c:forEach var="att" items="${attendance}">
					<tr>
						<td>${att.studentNo}</td>
						<td>${att.userName}</td>
						<td>${att.attend}</td>
						<td>${att.late}</td>
						<td>${att.absent}</td>
						<td>${(att.attend+att.late)*100/att.total}%</td>					 
					</tr>					
				</c:forEach>
								
				</table>
				
				
				
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
								<td></td>
						`;
				data.forEach(item=>{
					html += `
						<tr>
							<td>\${item.studentNo}</td>
							<td>\${item.userName}</td>
							<td>
								\${item.attendance == 1 ? '출석'
								: item.attendance == 2 ? '지각'
								: item.attendance == 0 ? '결석' : ''}						
							</td>
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