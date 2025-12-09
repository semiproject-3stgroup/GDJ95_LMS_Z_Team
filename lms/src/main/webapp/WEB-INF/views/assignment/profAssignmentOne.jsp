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
        /* 과제 상세 전체 박스 */
        .assignment-box {
            max-width: 900px;
            background-color: #ffffff;
            border-radius: 12px;
            padding: 20px 24px;
            box-shadow: 0 2px 6px rgba(15, 23, 42, 0.06);
            border: 1px solid #e5e7eb;
        }

        /* 제목 */
        .assignment-title {
            font-size: 20px;
            font-weight: 700;
            margin: 0 0 10px;
        }

        /* 상단 버튼 영역 */
        .assignment-actions {
            display: flex;
            gap: 8px;
            margin-bottom: 12px;
        }

        .assignment-actions button {
            padding: 6px 12px;
            border-radius: 999px;
            border: 1px solid #d1d5db;
            font-size: 13px;
            cursor: pointer;
            background-color: #ffffff;
        }

        #modifyBtn {
            border-color: #bfdbfe;
            background-color: #eff6ff;
            color: #1d4ed8;
        }
        #modifyBtn:hover {
            background-color: #dbeafe;
        }

        #removeBtn {
            border-color: #fecaca;
            background-color: #fef2f2;
            color: #b91c1c;
        }
        #removeBtn:hover {
            background-color: #fee2e2;
        }

        /* 라벨 + 값 줄 공통 */
        .assignment-row {
            margin-bottom: 10px;
            font-size: 14px;
        }

        .assignment-row label {
            display: inline-block;
            width: 70px;
            font-weight: 600;
            color: #374151;
        }

        .assignment-row span {
            color: #111827;
        }

        /* 내용 부분 */
        .assignment-content {
            margin: 10px 0 16px;
            padding: 10px 12px;
            border-radius: 8px;
            background-color: #f9fafb;
            font-size: 14px;
            line-height: 1.6;
            white-space: pre-line;
        }

        /* 기간 표시 */
        .assignment-period {
            font-size: 13px;
            color: #4b5563;
        }

        hr {
            margin: 20px 0;
            border: 0;
            border-top: 1px solid #e5e7eb;
        }

        /* 제출 현황 제목 */
        .submission-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        /* 제출 현황 리스트 래퍼 */
        .submission-list > div {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 8px;
            padding: 6px 0;
            border-bottom: 1px solid #e5e7eb;
            font-size: 13px;
			min-height: 40px;
        }

        .submission-list > div:last-child {
            border-bottom: none;
        }

        .submission-student {
            min-width: 180px;
            font-weight: 500;
            color: #111827;
        }

        .submission-file a {
            color: #2563eb;
            text-decoration: none;
        }

        .submission-file a:hover {
            text-decoration: underline;
        }

        .submission-date {
            color: #6b7280;
            font-size: 12px;
        }

        /* 점수 input + 버튼 */
        .scoreInput {
		    width: 120px;       
		    height: 32px;       
		    line-height: 32px;  
		    padding: 4px 6px;
		    border-radius: 6px;
		    border: 1px solid #d1d5db;
		    font-size: 13px;
		    box-sizing: border-box;
		}

        .saveBtn {
             height: 32px;
		    padding: 0 12px;
		    border-radius: 999px;
		    border: 1px solid #22c55e;
		    background-color: #dcfce7;
		    color: #15803d;
		    font-size: 13px;
		    cursor: pointer;
		    display: flex;
		    align-items: center;
        }

        .saveBtn:hover {
            background-color: #bbf7d0;
        }

        .score-state {
            font-size: 12px;
            margin-left: 4px;
        }

        /* 채점 버튼 */
        #scoringBtn {
            margin-top: 10px;
            padding: 6px 14px;
            border-radius: 999px;
            border: 1px solid #2563eb;
            background-color: #2563eb;
            color: #ffffff;
            font-size: 13px;
            cursor: pointer;
        }

        #scoringBtn:hover {
            background-color: #1d4ed8;
        }
        
        /* 목록 버튼 (오른쪽) */
		.btn-list {
		    padding: 6px 14px;
		    background-color: #2563eb;
		    color: white;
		    border-radius: 8px;
		    text-decoration: none;
		    font-size: 14px;
		    font-weight: 600;
		    border: 1px solid #1d4ed8;
		    transition: background-color 0.15s ease;
		}
		
		.btn-list:hover {
		    background-color: #1d4ed8;
		}
		
		.assignment-action-bar {
		    display: flex;
		    justify-content: space-between;  /* 왼쪽: 수정/삭제, 오른쪽: 목록 */
		    align-items: center;
		    margin-top: 8px;
		    margin-bottom: 12px;
		}
		
		/* assignment-actions 안 form도 가로로 나란히 */
		.assignment-actions form {
		    display: flex;
		    gap: 6px;
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
		
		    <div class="assignment-box">
		        <h1 class="assignment-title">${course.courseName}</h1>				       
		
		        <div class="assignment-row">
		            <label>제목</label>
		            <span>${assignment.assignmentName}</span>
		        </div>
		
		        <div class="assignment-row">
		            <label>작성일</label>
		            <span>
		                <c:if test="${assignment.updatedate!=null}">
		                    ${assignment.updatedate}
		                </c:if>
		                <c:if test="${assignment.updatedate==null}">
		                    ${assignment.createdate}
		                </c:if>
		            </span>
		        </div>
		
		        <div class="assignment-row">
		            <label>기간</label>
		            <span class="assignment-period">
		                ${assignment.startdate} ~ ${assignment.enddate}
		            </span>
		        </div>
		
		        <div class="assignment-row">
		            <label>내용</label>
		        </div>
		        <div class="assignment-content">
		            ${assignment.assignmentContent}
		        </div>
		    
		    <div class="assignment-action-bar">    
		        <c:if test="${course.userId==userId}">
		            <div class="assignment-actions">
		                <form>
		                    <input type="hidden" id="assignmentId" name="assignmentId" value="${assignment.assignmentId}">
		                    <button type="button" id="modifyBtn">수정</button>
		                    <button type="button" id="removeBtn">삭제</button>
		                </form>
		            </div>
		        </c:if>
				
			
		    	<a href="${pageContext.request.contextPath}/profAssignment" class="btn-list">목록</a>
			</div>
		        <hr>
		
		        <div class="submission-title">과제 제출 현황</div>
		
		        <div class="submission-list">
		            <c:forEach var="stu" items="${students}">
		                <div>
		                    <span class="submission-student">
		                        ${stu.studentNo}  ${stu.userName}
		                    </span>
		
		                    <span class="submission-file">
		                        <c:if test="${not empty stu.file}">
		                            <a href="${pageContext.request.contextPath}/upload/${assignment.assignmentId}/${stu.file}"
		                               download="${stu.file}">${stu.file}</a>
		                        </c:if>
		                        <c:if test="${empty stu.file}">
		                            미제출
		                        </c:if>
		                    </span>
							
							<c:if test="${not empty stu.file}">							
			                    <span class="submission-date">
			                        ${not empty stu.updatedate ? stu.updatedate : stu.createdate}
			                        ${stu.isLate ? "지각" : ""}                     
			                    </span>
			                    	${not empty stu.updatedate ? stu.updatedate : stu.createdate}
			                    <span>
		                    </c:if>
		                    
		                    </span>
		
		                    <input type="number" min="0" max="100"
		                           value="${stu.assignmentScore}"
		                           class="scoreInput"
		                           data-user-id="${stu.userId}"
		                           style="display:none">
		
		                    <button type="button"
		                            class="saveBtn"
		                            data-user-id="${stu.userId}"
		                            style="display:none">저장</button>
		
		                    <span id="scoreState-${stu.userId}" class="score-state"></span>
		                </div>
		            </c:forEach>
		        </div>
		
		        <c:if test="${isDateOver}">
		            <button type="button" id="scoringBtn">채점</button>
		        </c:if>
		    </div>
		
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
			if(confirm('삭제 하시겠습니까?')){				
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
			$('.score-state').text('');
			
			if($('.saveBtn').css('display') === 'none') {
				$('#scoringBtn').text('채점')	;
			} else {
				$('#scoringBtn').text('닫기')	;
				
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