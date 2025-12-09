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
    <style>
    /* 전체 폼을 감싸는 박스 */
    .form-box {
        background: #ffffff;
        padding: 24px;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        max-width: 600px;
        margin-top: 20px;
    }

    /* 라벨 */
    .form-box label {
        display: block;
        margin-top: 15px;
        margin-bottom: 6px;
        font-size: 14px;
        font-weight: 600;
        color: #374151;
    }

    /* text input / date input / select */
    .form-box input[type="text"],
    .form-box input[type="date"],
    .form-box select {
        width: 100%;
        padding: 10px 12px;
        border: 1px solid #d1d5db;
        border-radius: 6px;
        font-size: 14px;
        box-sizing: border-box;
    }

    /* 날짜 범위 */
    .date-range {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .date-range input {
        flex: 1;
    }

    /* textarea */
    .form-box textarea {
        width: 100%;
        height: 150px;
        padding: 10px 12px;
        border-radius: 6px;
        border: 1px solid #d1d5db;
        font-size: 14px;
        resize: vertical;
        box-sizing: border-box;
    }

    /* 버튼 그룹 */
    .btn-group {
        display: flex;
        gap: 10px;
        margin-top: 20px;
    }

    /* 저장 버튼 */
    #btn {
        padding: 10px 16px;
        background-color: #2563eb;
        color: #fff;
        font-size: 15px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
    }

    #btn:hover {
        background-color: #1e40af;
    }

    /* 취소 버튼 (a 태그를 버튼처럼) */
    .btn-cancel {
        padding: 10px 16px;
        background-color: #6b7280;
        color: #fff;
        font-size: 15px;
        border-radius: 6px;
        text-decoration: none;
        display: inline-block;
    }

    .btn-cancel:hover {
        background-color: #4b5563;
    }

</style>
    
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">

        <!-- 왼쪽 사이드바 include -->
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
		
		<!-- 오른쪽 본문 -->
        <main class="main-content">
	    <h1 class="page-title">과제 수정</h1>
	
	    <div class="form-box">
	        <form>
	            <input type="text" name="assignmentId" value="${assignment.assignmentId}" hidden>
	
	            <label>제목</label>
	            <input type="text" name="assignmentName" value="${assignment.assignmentName}">
	
	            <label>기간</label>
	            <div class="date-range">
	                <input type="date" name="startdate" value="${startdate}">
	                ~
	                <input type="date" name="enddate" value="${enddate}">
	            </div>
	
	            <label>내용</label>
	            <textarea name="assignmentContent">${assignment.assignmentContent}</textarea>
	
	            <div class="btn-group">
	                <button type="button" id="btn">저장</button>
	
	                <a href="${pageContext.request.contextPath}/profAssignmentOne?assignmentId=${assignment.assignmentId}"
	                   class="btn-cancel">취소</a>
	            </div>
	        </form>
	    </div>
	</main>
	</div>
</body>
<script>
	$('#btn').click(()=>{
		$('form').attr({
			method: 'post'
			, action: '${pageContext.request.contextPath}/profAssignmentModify'
		});
		$('form').submit();
	});
</script>
</html>