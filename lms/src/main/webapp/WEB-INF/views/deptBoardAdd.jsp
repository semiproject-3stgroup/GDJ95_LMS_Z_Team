<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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

        <!-- 왼쪽 사이드바 -->
        <nav class="sidebar">
            <div class="sidebar-title">메인</div>
            <ul class="sidebar-menu">
                <li>대시보드</li>
            </ul>

            <div class="sidebar-title" style="margin-top: 16px;">수업</div>
            <ul class="sidebar-menu">
                <li>공지사항</li>
                <li>수강신청</li>
                <li>학점조회</li>
            </ul>

            <div class="sidebar-title" style="margin-top: 16px;">관리</div>
            <ul class="sidebar-menu">
                <li>학과 관리</li>
                <li>학과별 게시판</li>
                <li>마이페이지</li>
            </ul>
        </nav>
	
		<main class="content">

	    <!-- 페이지 헤더 -->
	    <section class="board-header">
	      <div class="board-header-text">
	        <h1 class="board-title">학과 게시판 글쓰기</h1>
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
	            <option selected>선택하세요</option>
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
						
		
		
		$('form').submit();
	});
	
	$('#cancelBtn').click(()=>{
		response.sendRedirect
	})
	
</script>
</html>