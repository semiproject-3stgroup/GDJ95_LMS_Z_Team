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
					<button type="button" id="modify">수정</button>
					<button type="button" id="delete">삭제</button>
				</form>
			</c:if>		
			
			<input type="hidden" name="postId" value="${one.bo.postId}">
			
			<hr>
			
			<div id="commentsArea"></div>
			
			<div id="addComment">
				<textarea id="commentContent"></textarea>
				<button type="button" id="addCommentBtn">저장</button>
			</div>
			
			<a href="${pageContext.request.contextPath}/deptBoard">목록</a>							
		</main>
	</div>
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>
	
</body>
<script>
	$(()=>{
		const postId = $('input[name="postId"]').val();
		commentTable(postId);
	});
	
	$('#delete').click(()=>{
		if (confirm('삭제하시겠습니까?')) {
			$('form').attr('action', '${pageContext.request.contextPath}/deptBoardRemove');
			$('form').submit();
		}
	});
	
	$('#modify').click(()=>{
		$('form').attr('action', '${pageContext.request.contextPath}/deptBoardModify');
		$('form').submit();
	});
	
	$('#addCommentBtn').click(()=>{
		const postId = $('input[name="postId"]').val();
		const content = $('#commentContent').val();
		
		addComment(postId, content);		
	});
	
	
	$(document).on('click', '.removeCommentBtn', function() {
		const commentId = $(this).data('commentId');
		const postId = $('input[name="postId"]').val();
		
		if(!confirm('댓글을 삭제하시겠습니까?')) return;
		
		$.ajax({
			url:'/rest/removeComment'
			, data: { commentId : commentId	}
			, success: ()=>{
				commentTable(postId);
			}
			, error: ()=>{
				alert('댓글 삭제 실패')
			}
		});		
	});
	
	function commentTable(postId) {
		$.ajax({
			url: '/rest/comment'			
			, data: {postId : postId}
			, success: (data)=>{
				
				const cArea = $('#commentsArea');
				const loginUserId = ${userId};
				let html = '<table>'
				
				data.forEach(item => {
					html += `					
						<tr><td>작성자 \${item.userName}</td></tr>							 
						<tr><td>\${item.content}</td></tr>																							
						`;
						
					if(item.userId === loginUserId) {
						html += `
							<tr><td><button type="button" class="removeCommentBtn" data-comment-id="\${item.commentId}">삭제</button></td></tr>	
							`
					}
						
					html += '<tr><td><hr></td></tr>';						
				});									
				
				html += '</table>';
				
				cArea.html(html);
			}
			, error: () => {
				alert('댓글 불러오기 실패');
			}
		});		
	}	
	
	function addComment(postId, content) {
		$.ajax({
			url: '/rest/addComment'
			, type: 'post'
			, data: {
				postId : postId
				, content : content
				}
			, success: () => {
				commentTable(postId);
				$('#commentContent').val('')
			}
			, error: () => {
				alert('댓글 저장 실패');
			}
		});				
	}		
		
</script>
</html>