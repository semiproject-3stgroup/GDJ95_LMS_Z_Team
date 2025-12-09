<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<!-- 공통 레이아웃 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <style>
        .score-card {
            max-width: 520px;
            padding: 28px;
            margin-top: 20px;
            background: white;
            border-radius: 10px;
            border: 1px solid #e5e7eb;
        }
        .score-form-row {
            display: flex;
            flex-direction: column;
            margin-bottom: 16px;
        }
        .score-form-row label {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 6px;
        }
        .score-input {
            padding: 10px 12px;
            border-radius: 10px;
            border: 1px solid #d1d5db;
            font-size: 14px;
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
	
			<h1 class="page-title">${userName} 성적 입력</h1>
			
			<div class="score-card box">
			    
			    <form method="post" action="${pageContext.request.contextPath}/profSaveScore">
				    <div class="score-form-row">
				        <label>중간고사</label>
				        <input type="number" class="score-input" min="0" max="100" name="exam1Score" value="${score.exam1Score}">
				    </div>
				
				    <div class="score-form-row">
				        <label>기말고사</label>
				        <input type="number" class="score-input" min="0" max="100" name="exam2Score" value="${score.exam1Score}">
				    </div>
				
				    <div class="score-form-row">
				        <label>과제</label>
				        <input type="number" class="score-input" min="0" max="100" name="assignmentScore" value="${score.assignmentScore}">
				    </div>
				
				    <div class="score-form-row">
				        <label>출석</label>
				        <input type="number" class="score-input" min="0" max="100" name="attendanceScore" value="${score.attendanceScore}">
				    </div>
				
				    <div class="score-form-row">
				        <label>총점</label>
				        <input type="number" class="score-input score-total" min="0" max="100" name="scoreTotal" value="${score.scoreTotal}">
				    </div>
				    
				    <input type="hidden" name="courseId" value="${courseId}">
				    <input type="hidden" name="userId" value="${userId}">
				    				
				    <div class="score-btn-area">
				        <button type="submit" class="btn btn-primary">저장하기</button>
				    </div>
				</form>
			</div>
		</main>
	</div>
</body>
</html>