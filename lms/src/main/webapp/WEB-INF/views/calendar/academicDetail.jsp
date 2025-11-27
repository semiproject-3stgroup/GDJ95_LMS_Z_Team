<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>학사 일정 상세</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="content">
        <h2>학사 일정 상세</h2>

        <table class="basic-table" style="margin-top:16px;">
            <tr>
                <th style="width:120px;">행사명</th>
                <td>${event.eventName}</td>
            </tr>
            <tr>
                <th>시작일시</th>
                <td>${event.eventFromdate}</td>
            </tr>
            <tr>
                <th>종료일시</th>
                <td>${event.eventTodate}</td>
            </tr>
            <tr>
                <th>내용</th>
                <td style="white-space:pre-line;">${event.eventContext}</td>
            </tr>
        </table>

        <div style="margin-top:16px;">
            <a href="${pageContext.request.contextPath}/calendar/academic">목록으로</a>
        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
