<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출석 상세</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">

<style>
    .main-content {
        padding: 40px;
    }

    .page-title-center {
        text-align: center;
        font-size: 22px;
        font-weight: 700;
        margin-bottom: 16px;
    }

    .student-info {
        text-align: center;
        margin-bottom: 24px;
        color: #4b5563;
    }

    .attendance-detail-table {
        width: 100%;
        border-collapse: collapse;
        background-color: #ffffff;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }

    .attendance-detail-table th,
    .attendance-detail-table td {
        padding: 12px 16px;
    }

    .attendance-detail-table th {
        background-color: #f4f4f4;
        text-align: left;
        border-bottom: 1px solid #e0e0e0;
        font-weight: 600;
    }

    .attendance-detail-table td {
        border-bottom: 1px solid #f5f5f5;
    }

    .attendance-detail-table tr:nth-child(even) td {
        background-color: #fafafa;
    }

    .attendance-detail-table tr:hover td {
        background-color: #f1f5f9;
    }

    .back-btn {
        display: inline-block;
        margin-bottom: 16px;
        padding: 6px 12px;
        border-radius: 4px;
        border: 1px solid #d1d5db;
        background-color: #ffffff;
        font-size: 14px;
        text-decoration: none;
        color: #111827;
    }

    .back-btn:hover {
        background-color: #f3f4f6;
    }

    .status-pill {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 999px;
        font-size: 13px;
    }
    .status-attend {
        background-color: #dcfce7;
        color: #15803d;
    }
    .status-late {
        background-color: #fef9c3;
        color: #92400e;
    }
    .status-absent {
        background-color: #fee2e2;
        color: #b91c1c;
    }
</style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">

        <div style="margin-bottom: 16px;">
            <a href="javascript:history.back();" class="back-btn">← 뒤로가기</a>
        </div>

        <h2 class="page-title-center">
            <c:if test="${not empty course}">
                ${course.courseYear}년 ${course.courseSemester} ${course.courseName}
            </c:if>
        </h2>

        <div class="student-info">
            <span>${studentNo}</span>
            &nbsp;|&nbsp;
            <span>${userName}</span>
        </div>

        <table class="attendance-detail-table">
            <thead>
                <tr>
                    <th style="width: 40%;">일자</th>
                    <th style="width: 60%;">출결상태</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty history}">
                    <tr>
                        <td colspan="2">등록된 출석 정보가 없습니다.</td>
                    </tr>
                </c:if>

                <c:forEach var="row" items="${history}">
                    <tr>
                        <td>${row.attendanceDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${row.attendance == 1}">
                                    <span class="status-pill status-attend">출석</span>
                                </c:when>
                                <c:when test="${row.attendance == 2}">
                                    <span class="status-pill status-late">지각</span>
                                </c:when>
                                <c:when test="${row.attendance == 0}">
                                    <span class="status-pill status-absent">결석</span>
                                </c:when>
                                <c:otherwise>
                                    -
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

    </main>
</div>

</body>
</html>
