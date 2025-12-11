<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LMS 학과 게시판</title>

    <!-- CSS 로딩 -->
    <link rel="stylesheet" href="/css/layout.css">
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body class="board-page dept-page">

	<%@ include file="/WEB-INF/views/common/header.jsp" %>
	   
	<div class="layout">
	    
	    <!-- 왼쪽 사이드바 include -->
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
        
	    <!-- 메인 콘텐츠 -->
	    <main class="content">
	
	      <!-- 페이지 헤더 -->
	      <section class="board-header">
	        <div class="board-header-text">
	          <h1 class="board-title">학과 게시판</h1>
	          <p class="board-subtitle">000 학과 게시판입니다</p>
	        </div>
	      </section>
	
	      <!-- -->
	      <section class="board-body">
	      
	      	<div>
	            <select class="rows-select">
	              <option>10</option>
	              <option>20</option>
	              <option>50</option>
	            </select>
	            줄 씩
	         </div>
	      
	        <table class="board-table" border="1">
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
	          </tbody>
	        </table>
			<a href="${pageContext.request.contextPath}/deptBoardAdd">글쓰기</a>
			<div class="board-footer">
				<div class="pagination">	
				</div>
			</div>
		</section>
		</main>
	</div>
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>
		
</body>
<script>
	window.onload = function() {
		const rowPerPage = document.querySelector('.rows-select').value;
		boardTable(1, rowPerPage);
	}
	
	function boardTable(page, rowPerPage) {
		$.ajax({
			url: '/rest/deptBoard'
			, method: 'get'
			, data:{
				currentPage: page
				, rowPerPage: rowPerPage					
			}
			, success: (data)=>{
				updateTable(data.list);
				updatePagination(data);
			}
			, error: () => {console.log('error')}
		});
	}
	
	function updateTable(list) {
		const tbody = document.querySelector('tbody');
		tbody.innerHTML = '';
		
		list.forEach(item => {
			tbody.innerHTML += `
				<tr>
					<td>\${item.postId}</td>
          			<td>\${item.category}</td>
          			<td>
          				<a href="${pageContext.request.contextPath}/deptBoardOne?postId=\${item.postId}">\${item.title}</a>
          			</td>
          			<td>\${item.userId}</td>
          			<td>\${item.createdate}</td>
          			<td>0</td>
				</tr>											
				`;
		});
	}
	
	function updatePagination(data) {
		const page = document.querySelector('.pagination');
		const rowPerPage = data.rowPerPage;
		let html = '';
		if(data.beginPage > 1) {
			html += `<a href="#" onclick="boardTable(\${data.beginPage-1},\${rowPerPage})">이전</a>`;
		}
		for(let i=data.beginPage; i <= data.endPage; i++) {
			if(i===data.currentPage) {
				html += `<span class="pageNum">\${i}</span>`;
			} else {
				html += `<a href="#" onclick="boardTable(\${i}, \${rowPerPage})">\${i}</a>`;	
			}			
		}
		if(data.currentPage<data.lastPage) {
			html += `<a href="#" onclick="boardTable(\${data.endPage + 1}, \${rowPerPage})">다음</a>`;
		}
		
		page.innerHTML = html;
	}
	
	document.querySelector('.rows-select').addEventListener('change', (e)=>{
		boardTable(1, e.target.value);
	});
</script>
</html>