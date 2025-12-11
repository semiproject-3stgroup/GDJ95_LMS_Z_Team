<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>

    <!-- CSS 로딩 -->
    <link rel="stylesheet" href="/css/layout.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body class="board-page dept-page">
	<%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">

        <!-- 왼쪽 사이드바 include -->
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
	
		<main class="content">

	    <!-- 페이지 헤더 -->
	    <section class="board-header">
	      <div class="board-header-text">
	        <h2 class="board-title">학과 게시판 글쓰기</h2>
	        <p class="board-subtitle">학과 공지 및 안내 글을 작성합니다.</p>
	      </div>
	    </section>
	
	    <!-- 글쓰기 폼 -->
		<form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/deptBoardAdd" >	
	        제목
	        <div class="form-field">
	          <input name="title" id="title" type="text" class="form-input" placeholder="제목을 입력하세요.">
	        </div>
	      
		    카테고리
	        <div class="form-field">
	          <select name="category" id="category" class="form-select">
	            <option selected disabled hidden>선택하세요</option>
	            <option>공지</option>
	            <option>질문</option>
	            <option>기타</option>
	          </select>
	        </div>
	      		      
	        내용
	        <div class="form-field">
				<textarea name="content" placeholder="게시글 내용을 입력하세요."></textarea>
			</div>
			
			첨부파일
			<div>
				<input type="file" name="boardDeptFile" multiple>
			</div>	
			<button type="button" id="submitBtn">등록</button>
			<a href="${pageContext.request.contextPath}/deptBoard" id="cancelBtn">취소</a>
		</form>	

	  </main>				
	
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
<script>
	$('#submitBtn').click(()=>{
		if(confirm('등록하시겠습니까?')){
			$('form').submit();	
		}							
	});
	
</script>
</html>