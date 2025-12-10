<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>학생출석관리</title>

	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <style>
        .main-content {
            padding: 40px;
        }

        .attendance-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;

            background-color: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        .attendance-table th,
        .attendance-table td {
            padding: 12px 16px;
        }

        .attendance-table th {
            background-color: #f4f4f4;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
            font-weight: 600;
        }

        .attendance-table td {
            border-bottom: 1px solid #f5f5f5;
        }

        .attendance-table tr:nth-child(even) td {
            background-color: #fafafa;
        }

        .attendance-table tr:hover td {
            background-color: #f1f5f9;
        }

        .attendance-input-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;

            background-color: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        .attendance-input-table th,
        .attendance-input-table td {
            padding: 10px 14px;
        }

        .attendance-input-table th {
            background-color: #f4f4f4;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
            font-weight: 600;
        }

        .attendance-input-table td {
            border-bottom: 1px solid #f5f5f5;
        }

        .attendance-input-table tr:nth-child(even) td {
            background-color: #fafafa;
        }

        .attendance-input-table tr:hover td {
            background-color: #f1f5f9;
        }

        form {
            margin-top: 30px;
        }

        #today {
            padding: 6px 10px;
            margin-right: 10px;
        }

		#saveBtn {
		    padding: 8px 16px;
		    border: none;
		    border-radius: 4px;
		    background-color: #2563eb;
		    color: #fff;
		    cursor: pointer;
		    margin-right: 8px;
		}
		
		#saveBtn:hover {
		    background-color: #1d4ed8;
		}
		
		.cancel-btn {
		    padding: 8px 16px;
		    border: none;
		    border-radius: 4px;
		    background-color: #6b7280;
		    color: #fff;
		    cursor: pointer;
		}
		
		.cancel-btn:hover {
		    background-color: #4b5563;
		}
    </style>
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">

        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
		
        <main class="main-content">	
			
			<h2 class="page-title">
                출석 관리
                <c:if test="${not empty course}">
                    - ${course.courseName} (${course.courseYear}년 ${course.courseSemester})
                </c:if>
            </h2>

            <div style="margin-bottom: 16px;">
                <a href="${pageContext.request.contextPath}/course/prof"
                   class="home-btn secondary">
                    ← 담당 강의 목록으로
                </a>
                <c:if test="${not empty course}">
                    <a href="${pageContext.request.contextPath}/course/prof/students?courseId=${course.courseId}"
                       class="home-btn outline"
                       style="margin-left: 8px;">
                        수강생 목록
                    </a>
                </c:if>
            </div>
			
			<table class="attendance-table">
				<tr>
					<th>학번</th>
					<th>이름</th>
					<th>출석</th>
					<th>지각</th>
					<th>결석</th>
					<th>출석률</th>
				</tr>
				<c:forEach var="att" items="${attendance}">
					<tr>
						<td>${att.studentNo}</td>
						<td>
                            <a href="${pageContext.request.contextPath}/profAttendanceDetail?courseId=${courseId}&userId=${att.userId}&userName=${att.userName}&studentNo=${att.studentNo}">
                                ${att.userName}
                            </a>
                        </td>
						<td>${att.attend}</td>
						<td>${att.late}</td>
						<td>${att.absent}</td>
						<td>${att.total!=0 ? (att.attend+att.late)*100/att.total : "0" }%</td>					 
					</tr>					
				</c:forEach>
			</table>
				
			<form method="post" action="${pageContext.request.contextPath}/profAttendanceSave">
				<input type="hidden" id="courseId" name="courseId" value="${courseId}">
				<input type="date" id="today" name="date">
					
				<div id="attendance"></div>			
				
				<button type="submit" id="saveBtn" hidden>저장</button> 
				<button type="button" id="cancelBtn" class="cancel-btn" hidden>취소</button>
			</form>
			
		</main>
	</div>
	
	
</body>
<script>
$(function() {
	$('#today').change(()=>{
		const date = $('#today').val();
		const courseId = $('#courseId').val();
		
		$.ajax({
			url: '/rest/profAttendance'
			, type: 'post'
			, data: {
				date : date	
				,courseId : courseId
			}	
			, success: (data) => {
				
				let html = `
						<table class="attendance-input-table">
							<tr>
								<th>학번</th>
								<th>이름</th>
								<th>현재상태</th>
								<th>변경</th>
							</tr>
						`;
				data.forEach(item=>{
					html += `
						<tr>
							<td>\${item.studentNo}</td>
							<td>\${item.userName}</td>
							<td>
								\${item.attendance == 1 ? '출석'
								: item.attendance == 2 ? '지각'
								: item.attendance == 0 ? '결석' : ''}						
							</td>
							<td>
								<input type="hidden" name="userIdList" value="\${item.userId}">
	                            <select name="statusList">
		                            <!-- 기본값: 출석(1), 기존 값이 있으면 그 값으로 선택 -->
		                            <option value="1" \${(item.attendance == null || item.attendance === '' || item.attendance == 1) ? 'selected' : ''}>출석</option>
		                            <option value="2" \${item.attendance == 2 ? 'selected' : ''}>지각</option>
		                            <option value="0" \${item.attendance == 0 ? 'selected' : ''}>결석</option>
	                        	</select>
							</td>
                		</tr>
            		`;
				});

				html += `</table>`;		
				
				$('#attendance').html(html);
			}			
			, error: () => {
				alert('error');
			}				
		});
	
		$('#saveBtn').removeAttr('hidden');
		$('#cancelBtn').removeAttr('hidden');
	});	
	
	$('#cancelBtn').click (()=>{
		$('#attendance').empty();
		$('#saveBtn').attr('hidden', true);
		$('#cancelBtn').attr('hidden', true);
	});			
})
</script>

</html>
