<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        
	    <!-- 메인 콘텐츠 -->
	    <main class="content">
	    	<!-- 페이지 헤더 -->
			<section class="modify-header">				
					<h2 class="modify-title">글 수정</h2>					
	    	</section>
	    	
	    	asdfasdfasdfasdfasdfasdf
	    	카테고리
	    	제목
	    	작성자
	    	<c:if test="${empty one.bo.updatedate}">
				<div>작성날짜${one.bo.createdate}</div>		
			</c:if>
			<c:if test="${not empty one.bo.updatedate}">
				<div>수정날짜${one.bo.updatedate}</div>		
			</c:if>
	    	첨부파일
	    	<c:forEach var="fl" items="${one.fl}">
	    		<input type="checkbox" name="deleteFileIds" value="${fl.fileId}">${fl.originName}.${fl.fileExtension}<br>													
			</c:forEach>
	    	내용
	    </main>
    </div>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>