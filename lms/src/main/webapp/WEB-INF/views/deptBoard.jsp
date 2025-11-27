<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>LMS 학과 게시판</title>

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
        
	    <!-- 메인 콘텐츠 -->
	    <main class="content">
	
	      <!-- 페이지 헤더 -->
	      <section class="board-header">
	        <div class="board-header-text">
	          <h1 class="board-title">학과 게시판</h1>
	          <p class="board-subtitle">000 학과 게시판입니다</p>
	        </div>
	      </section>
	
	      <!-- 과제 리스트 카드 -->
	      <section class="card assignment-card">
	      
	      	<div>
	            <select class="rows-select">
	              <option>10</option>
	              <option>20</option>
	              <option>50</option>
	            </select>
	            줄 씩
	         </div>
	      
	        <table class="assignment-table" border="1">
	          <thead>
	          <tr>
	            <th> </th>
	            <th>카테고리</th>
	            <th>title</th>
	            <th>작성자</th>
	            <th>작성일</th>
	            <th>댓글</th>
	          </tr>
	          </thead>
	          <tbody>
	          	<c:forEach var="l" items="${list}">
	          		<tr>
	          			<td>${l.postId}</td>
	          			<td>${l.category}</td>
	          			<td>${l.title}</td>
	          			<td>${l.userId}</td>
	          			<td>${l.createdate}</td>
	          			<td>0</td>
	          		</tr>
	          	</c:forEach>
	          </tbody>
	        </table>
	

			<div class="board-footer">
				<div class="pagination">
				<c:if test="${currentPage>1}">
	          			<a href="${pageContext.request.contextPath}/deptBoard?currentPage=${beginPage-1}">이전</a>
	          		</c:if>

	          		<c:forEach var="i" begin="${beginPage}" end="${endPage}">
	          			<c:if test="${i!=currentPage}">
	          				<a href="${pageContext.request.contextPath}/deptBoard?currentPage=${i}">${i}</a>
	          			</c:if>
	          			<c:if test="${i==currentPage}">
	          				${i}
	          			</c:if>       			
	          		</c:forEach>
	          		          				          			
	          		<c:if test="${currentPage < lastPage}"> 
	          		   	<a href="${pageContext.request.contextPath}/deptBoard?currentPage=${endPage+1}">다음</a>
	            	</c:if>
				
				</div>
			</div>
		</section>
		</main>
	</div>
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>
		
</body>
<script>
	
</script>
</html>