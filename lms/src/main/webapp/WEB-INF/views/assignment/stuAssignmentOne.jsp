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

			<h1>one</h1>
		
				<label>제목</label>
				${course.courseName }:
				${assignment.assignmentName}				
				<label>작성일</label>
					<c:if test="${assignment.updatedate!=null}">
						${assignment.updatedate}
					</c:if>
					<c:if test="${assignment.updatedate==null}">
						${assignment.createdate}
					</c:if>
				<label>내용</label>
				${assignment.assignmentContent}
				<label>기간</label>
				${assignment.startdate} ~ ${assignment.enddate} 		

				<hr>

				<label>제출여부</label>
				<c:choose>
					<c:when test="${empty assignmentSubmit.file}">미제출</c:when>
					<c:otherwise>
						제출완료
						<label>파일</label>
						<a href="${pageContext.request.contextPath}/upload/${assignment.courseId}/${assignmentSubmit.file}" download="${assignmentSubmit.file}">${assignmentSubmit.file}</a>
						${not empty assignmentSubmit.updatedate ? assignmentSubmit.updatedate : assignmentSubmit.createdate}
					</c:otherwise>
				</c:choose>							
				
				
				
				<form method="post" encType="multipart/form-data">		
					<input type="hidden" name="assignmentId" value="${assignment.assignmentId}" >
					<input type="hidden" name="userId" value="${userId}">
					<input type="hidden" name="file" value="${assignmentSubmit.file}">	
					<div id="uploadArea" hidden>						
						<div id="dropZone" style="width: 300px; height: 100px; border: 2px dashed #aaa; text-align: center; line-height: 100px;">
					    		<div id="filename">선택된 파일 없음</div>
					    </div>					    					    					   
					    
					    <input type="file" id="uploadFile" name="uploadFile" hidden>
					    					    					    
					    <button type="button" id="uploadBtn">저장</button>
					</div>
				</form>
				
				<c:if test="${empty assignmentSubmit.file}">
					<button type="button" id="addBtn">제출하기</button>
				</c:if>
				<c:if test="${not empty assignmentSubmit.file}">
					<button type="button" id="modifyBtn">수정하기</button>
				</c:if>																														
		</main>
	</div>		
</body>
<script>
	$(document).ready(()=>{
				
		$('#addBtn, #modifyBtn').click((e)=>{
			const btn = $(e.target);
			
			if(btn.attr('id') === 'addBtn') {
				$('form').attr('action', '${pageContext.request.contextPath}/stuAssignmentSubmit');
				$('form').data('mode', 'add');
				
			} else {
				$('form').attr('action', '${pageContext.request.contextPath}/stuAssignmentModify');
				$('form').data('mode', 'modify');
			}					
			
			if($('#uploadArea').attr('hidden')) {
				$('#uploadArea').removeAttr('hidden');
				btn.data('ori',btn.text());
				btn.text('취소');
			} else {
				$('#uploadArea').attr('hidden', true);
				btn.text(btn.data('ori'));
				
				$('#uploadFile').val();
				$('#filename').text('선택된 파일 없음');
			}						
		});
		
		$('#dropZone').on("dragover", (e) => {
		    e.preventDefault();
		    $('#dropZone').css("background", "#f0f0f0");	  
		});

		$('#dropZone').on("dragleave", () => {
			$('#dropZone').css("background", "white");
		});

		$('#dropZone').on("drop", (e) => {
		    e.preventDefault();
		    $('#dropZone').css("background", "white");		    		
			
			const files = e.originalEvent.dataTransfer.files;
			
			if (files.length === 0) return;
			if (files.length > 1) {
	           alert('파일은 한 개만 올려주세요');
	           return;
			}			
			
			$('#uploadFile')[0].files = files;
			
			$('#filename').text(files[0].name);
			
		});	

		$('#dropZone').on('click', ()=>{
			$('#uploadFile').click();		
		});	
		
		$('#uploadFile').change((e)=>{
			if(e.target.files.length>0) {
				$('#filename').text(e.target.files[0].name);
			} else {
				$('#filename').text('선택된 파일 없음');
			}			
		});
		
		$('#uploadBtn').click(()=>{

			if(!$('#uploadFile')[0].files.length) {
				alert('파일이 없습니다')
				return;
			}
			
			if($('form').data('mode')==='modify') {
				if(!confirm('기존 파일을 덮어씁니까?')) {
					return;
				}
			}			
			$('form').submit();			
		});					
	});

</script>
</html>