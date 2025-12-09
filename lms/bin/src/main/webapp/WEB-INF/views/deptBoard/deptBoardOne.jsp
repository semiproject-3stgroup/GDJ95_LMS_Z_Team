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
		
		<main>			
				<div>카테고리${one.bo.category}</div>
				<h2>제목${one.bo.title}</h2>					
				<div>작성자</div>
				
				<c:if test="${empty one.bo.updatedate}">
					<div>작성날짜${one.bo.createdate}</div>		
				</c:if>
				<c:if test="${not empty one.bo.updatedate}">
					<div>수정날짜${one.bo.updatedate}</div>		
				</c:if>
				
				<div>첨부 파일</div>						
							
					<c:forEach var="fl" items="${one.fl}">
						<a href="${pageContext.request.contextPath}/upload/${fl.fileName}.${fl.fileExtension}" download="${fl.originName}.${fl.fileExtension}">
							${fl.originName}.${fl.fileExtension}
						</a><br>
					</c:forEach>								
			
				<div>내용${one.bo.content}</div>


			<c:if test="${one.bo.userId == userId}">					
				<form>	
					<input type="hidden" name="postId" value="${one.bo.postId}">
					
					<button type="button" id="modify">수정</button>
					<button type="button" id="delete">삭제</button>
				</form>
			</c:if>										
		</main>
	</div>
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>
	
</body>
<script>
	$('#delete').click(()=>{
		if (confirm('삭제하시겠습니까?')) {
			$('form').attr('action', '${pageContext.request.contextPath}/deptBoardRemove');
			$('form').submit();
		}
	});
	
	$('#modify').click(()=>{
		$('form').attr('action', '${pageContext.request.contextPath}/deptBoardModify');
		$('form').submit();
	})
	
</script>
</html>