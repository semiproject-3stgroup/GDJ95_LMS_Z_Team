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
        
	    <!-- 메인 콘텐츠 -->
	    <main class="content">
	    	<!-- 페이지 헤더 -->
			<section class="modify-header">				
					<h2 class="modify-title">글 수정</h2>					
	    	</section>
	    	
	    	<form id="boardForm" method="post" action="${pageContext.request.contextPath}/deptBoardModify">
		    	<input type="hidden" value="${one.bo.postId}" name="postId">
		    	<select name="category">
		    		<option ${one.bo.category=='공지'?'selected':''}>공지</option>
		    		<option ${one.bo.category=='질문'?'selected':''}>질문</option>
		    		<option ${one.bo.category=='기타'?'selected':''}>기타</option>
		    	</select>		    	
		    	<label>제목</label>
		    	<input type="text" name="title" value="${one.bo.title}"> 		    	
		    	<c:if test="${empty one.bo.updatedate}">
					<div>작성날짜${one.bo.createdate}</div>		
				</c:if>
				<c:if test="${not empty one.bo.updatedate}">
					<div>수정날짜${one.bo.updatedate}</div>					
				</c:if>		    	
		    	<label>내용</label>
		    	<textarea name="content">${one.bo.content}</textarea>		    	 
		    	
		    	<div>
			    	첨부파일
			    	<ul id="fileList">
			    		<c:forEach var="fl" items="${one.fl}">
			    			<li>
			    				${fl.originName}
			    				<button type="button" class="deleteBtn" data-file-id="${fl.fileId}">삭제</button>
			  				</li>			  				
						</c:forEach>
			    	</ul>
			    	
			    	<div id="dropZone" style="width: 300px; height: 100px; border: 2px dashed #aaa; text-align: center; line-height: 100px;">
			    		파일을 드래그하세요
			    	</div>
			    	<input type="file" id="uploadFile" multiple style="display:none">
		    	</div>
		    	
		    	<button type="button" id="saveBtn">저장</button>
		    	<a href="${pageContext.request.contextPath}/deptBoardOne?postId=${one.bo.postId}">취소</a>
	    	</form>
	    </main>
    </div>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
<script>			
		
	let deletedFileIds = [];
	
	$('#fileList').on("click", ".deleteBtn", (e)=>{
		const btn = $(e.target);
		const li = btn.parent();
				
		if(btn.data("temp-file-id")) {
			const tempFileId = btn.data("temp-file-id");
	        $.ajax({
	            url: "/rest/deleteFile",
	            type: "post",
	            data: { tempFileId },
	            success: () => {
	                console.log("임시파일 삭제 완료:", tempFileId);
	            },
	            error: () => {
	                console.warn("임시파일 삭제 실패:", tempFileId);
	            }
	        });
	        $("#uploadedFile"+tempFileId).remove();
	        $("#uploadedFileName"+tempFileId).remove();
	    }
		
		if(btn.data("file-id")){
			const fileId = btn.data("file-id");
	        deletedFileIds.push(fileId);
	    }
		
		li.remove();
		
		console.log(deletedFileIds);
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

	    for (const file of files) {
	        uploadFile(file);
	    }
	});

	$('#dropZone').on('click', ()=>{
		$('#uploadFile').click();		
	});
		
	$('#uploadFile').on("change", (e) => {
		 for(let file of e.target.files) {
			uploadFile(file); 
		 }		 
	 });	
	 
	function uploadFile(file) {
	    const formData = new FormData();
	    formData.append("uploadFile", file);

	    $.ajax({
	    	url: "/rest/uploadFile"
	    	, type: "post"
	    	, data: formData
	    	, contentType: false	    	
	    	, processData: false
	    	, success: (data) => {
	    		if(data.success) {
	    			
	    			const li = $("<li>").text(file.name);
	    			const btn = $("<button>").text("삭제")
	    									.attr("type", "button")
	    									.addClass("deleteBtn")
	    									.data("temp-file-id", data.tempFileId)
	    			li.append(btn);
	    			$('#fileList').append(li);
	    			
	    			const inputId = $('<input>').attr({
	    				type: "hidden"
	    				, name: "uploadedFileIds"
	    				, id: "uploadedFile"+data.tempFileId
	    				, value: data.tempFileId
	    			});
	    			
	    			const inputName = $('<input>').attr({
	    				type: "hidden"
	    				, name: "uploadedFileNames"
	    				, id: "uploadedFileName" + data.tempFileId
	    				, value: file.name
	    			});		    					    			    			
	    			
	    			$("#boardForm").append(inputId, inputName);
	    			
	    		} else {
	    			alert("업로드 실패");
	    		}
	    	}
	    	, error: ()=>{
	    			alert("오류")
	    	}	    	
	    });	    	    	    
	}
			
	$('#saveBtn').click(()=>{
		$('#boardForm').submit();
		
		deletedFileIds.forEach(fileId => {
			$('#boardForm').append($('<input>', {
					type: 'hidden'
					, name: 'deletedFileIds'
					, value: fileId
			}));
		});
				
		$('#boardForm').submit();
	});		
						
</script>


</html>