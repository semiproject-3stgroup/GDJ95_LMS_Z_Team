<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>과제 관리</title>

    <!-- 공통 레이아웃 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">

    <style>
        /* ===== 교수용 과제 목록 전용 스타일 ===== */

        /* 페이지 전체 박스 안쪽 간격 조정 */
        .assignment-wrapper {
            max-width: 1120px;
        }

        /* 과목별 블럭 */
        .assignment-course-block {
            padding: 16px 0;
            border-bottom: 1px solid #e5e7eb;
        }

        .assignment-course-block:last-child {
            border-bottom: none;
        }

        /* 과목명 */
        .assignment-course-name {
            margin: 0 0 6px;
            font-size: 16px;
            font-weight: 600;
            color: #111827;
        }

        /* 과제 리스트 */
        .assignment-list {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        /* 한 줄(제목 + 기간) */
        .assignment-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 6px 0;
        }

        /* 과제 제목 링크 */
        .assignment-link {
            flex: 1;
            min-width: 0;                 /* ellipsis 위해 */
            text-decoration: none;
            color: #374151;
            font-size: 14px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            transition: color 0.15s ease, text-decoration 0.15s ease;
        }

        .assignment-link:hover {
            color: #2563eb;
            text-decoration: underline;
        }

        /* 기간 + 마감 배지 */
        .assignment-date {
            flex: none;
            margin-left: 12px;
            font-size: 12px;
            color: #6b7280;
            white-space: nowrap;
        }

        .deadline-badge {
            display: inline-block;
            margin-left: 6px;
            padding: 2px 6px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
            color: #b91c1c;
            background-color: #fee2e2;
        }

        /* 하단 버튼 영역 */
        .assignment-footer {
            margin-top: 16px;
            display: flex;
            justify-content: flex-end;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">
        <!-- 왼쪽 사이드바 -->
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

        <!-- 오른쪽 본문 -->
        <main class="main-content">

            <h1 class="page-title">과제</h1>

            <div class="box assignment-wrapper">

			    <%-- 선택된 강의가 있을 때는 그 강의만, 없으면 전체 출력 --%>
			    <c:forEach var="c" items="${course}">
			        <c:if test="${empty selectedCourseId or selectedCourseId == c.courseId}">
			            <div class="assignment-course-block">
			                <!-- 과목 이름 -->
			                <h3 class="assignment-course-name">${c.courseName}</h3>
			
			                <!-- 과목별 과제 리스트 -->
			                <ul class="assignment-list">
			                    <c:forEach var="a" items="${list}">
			                        <c:if test="${c.courseName == a.courseName}">
			                            <li class="assignment-item">
			                                <a class="assignment-link"
			                                   href="${pageContext.request.contextPath}/profAssignmentOne?assignmentId=${a.assignmentId}">
			                                    ${a.assignmentName}
			                                </a>
			
			                                <span class="assignment-date">
			                                    ${a.startdate} ~ ${a.enddate}
			                                    <c:if test="${a.over}">
			                                        <span class="deadline-badge">마감</span>
			                                    </c:if>
			                                </span>
			                            </li>
			                        </c:if>
			                    </c:forEach>
			                </ul>
			            </div>
			        </c:if>
			    </c:forEach>
			
			    <!-- 하단 버튼 -->
			    <div class="assignment-footer">
			        <a href="${pageContext.request.contextPath}/profAssignmentAdd"
			           class="btn btn-primary">
			            과제 등록하기
			        </a>
			    </div>
			</div>

        </main>
    </div>
</body>
</html>
