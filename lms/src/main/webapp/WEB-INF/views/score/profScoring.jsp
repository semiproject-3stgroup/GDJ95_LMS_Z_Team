<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<!-- 공통 레이아웃 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">       

    <style>
        /* 메인 영역 전체에 여백 조금 주기 */
        .main-content {
            padding: 40px;
        }

        /* 테이블을 카드처럼 보이게 */
        .score-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;

            background-color: #ffffff;      /* 테이블 배경 흰색 */
            border-radius: 8px;             /* 모서리 둥글게 */
            overflow: hidden;               /* radius 밖으로 안 튀어나오게 */
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);  /* 살짝 그림자 */
        }

        .score-table th,
        .score-table td {
            padding: 12px 16px;
        }

        .score-table th {
            background-color: #f4f4f4;      /* 헤더 살짝 회색 */
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
            font-weight: 600;
        }

        .score-table td {
            border-bottom: 1px solid #f0f0f0;
        }

        /* 홀수/짝수 줄 색 다르게 */
        .score-table tr:nth-child(even) td {
            background-color: #fafafa;
        }

        /* 마우스 올렸을 때 */
        .score-table tr:hover td {
            background-color: #f1f5f9;
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
			
			<h2>성적</h2>

            <table class="score-table">
                <tr>
                    <th>학번</th>
                    <th>이름</th>
                    <th>중간고사</th>
                    <th>기말고사</th>
                    <th>과제</th>
                    <th>출석</th>
                    <th>총점</th>
                    <th>등급</th>
                </tr>

                <c:forEach var="li" items="${list}">
                    <tr>
                        <td>${li.studentNo}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/profScoringOne?userId=${li.userId}&courseId=${li.courseId}&userName=${li.userName}">
                                ${li.userName}
                            </a>
                        </td>
                        <td>${li.exam1Score}</td>
                        <td>${li.exam2Score}</td>
                        <td>${li.assignmentScore}</td>
                        <td>${li.attendanceScore}</td>
                        <td>${li.scoreTotal}</td>
                        <td>${not empty li.scoreTotal ? li.grade : ""}</td>
                    </tr>
                </c:forEach>
            </table>
					
		</main>
	</div>
</body>
</html>