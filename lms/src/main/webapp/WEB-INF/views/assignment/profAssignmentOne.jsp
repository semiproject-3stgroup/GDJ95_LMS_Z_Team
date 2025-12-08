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
				<c:if test="${course.userId==userId}">
					<form>
						<input type="hidden" id="assignmentId" name=assignmentId value="${assignment.assignmentId}">
						<button type="button" id="modifyBtn">수정</button>
						<button type="button" id="removeBtn">삭제</button>
					</form>
				</c:if>
				<label>제목</label>
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
						
				과제 제출 현황 <br>
				<c:forEach var="stu" items="${students}">
					<div>
						${stu.studentNo} / ${stu.userName} / 
						<c:if test="${not empty stu.file}">
							<a href="${pageContext.request.contextPath}/upload/${assignment.assignmentId}/${stu.file}" download="${stu.file}">${stu.file}</a>
						</c:if>
						<c:if test="${empty stu.file}">미제출</c:if>
						${not empty stu.updatedate ? stu.updatedate : stu.createdate}  
						
							<input type="number" min="0" max="100" value="${stu.assignmentScore}" class="scoreInput" data-user-id="${stu.userId}" style="display:none">											
							<button type="button" class="saveBtn" data-user-id="${stu.userId}" style="display:none">저장</button>
						
						<span id="scoreState-${stu.userId}"></span>
					</div>
				</c:forEach>
				<c:if test="${isDateOver}">
					<button type="button" id="scoringBtn">채점</button>
				</c:if>															
		</main>
	</div>
		
</body>
	<script>
		$('#modifyBtn').click(()=>{
			$('form').removeAttr('action method');
			$('form').attr('action', '${pageContext.request.contextPath}/profAssignmentModify');
			$('form').submit();
		});
		
		$('#removeBtn').click(()=>{
			$('form').removeAttr('action method');
			if(confirm('정말?')){				
				$('form').attr({
					action: '${pageContext.request.contextPath}/profAssignmentRemove'
					, method: 'post'
				});
				
				$('form').submit();
			}
		});
		
		$('.saveBtn').click((e)=>{
			const userId = $(e.target).data('userId');
			const assignmentId = $('#assignmentId').val();
			const score = $('.scoreInput[data-user-id="'+ userId +'"]').val()
			
			if(score === ''){
				alert('점수를 입력하세요');
				return;
			}
			
			addScore(userId, assignmentId, score);
		});
		
		$('#scoringBtn').click(()=>{
			$('.scoreInput').toggle();
			$('.saveBtn').toggle();
			
			if($('.saveBtn').css('display') === 'none') {
				$('#scoringBtn').text('채점')	;
			} else {
				$('#scoringBtn').text('닫기');
			}			
		});
				
		function addScore(userId, assignmentId, score){
			$.ajax({
				url: '/rest/assignmentScore'
				, type: 'post'
				, data: {
					assignmentId : assignmentId
					, userId : userId
					, assignmentScore : score
				}
				, success: ()=>{
					$('#scoreState-'+userId).text('저장완료').css('color', 'green');
				}		
				, error: ()=>{
					$('#scoreState-'+userId).text('저장실패').css('color', 'red');
				}				
			});
		}
	</script>
</html>