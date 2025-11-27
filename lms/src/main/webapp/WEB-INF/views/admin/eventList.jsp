<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>학사 일정 관리</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">
        <h2>학사 일정 관리</h2>

        <div style="margin:10px 0;">
            <a href="${pageContext.request.contextPath}/admin/events/add">새 일정 등록</a>
        </div>

        <table class="table-basic">
            <thead>
                <tr>
                    <th>행사명</th>
                    <th>시작일시</th>
                    <th>종료일시</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="e" items="${eventList}">
                    <tr>
                        <td>${e.eventName}</td>
                        <td>${e.eventFromdate}</td>
                        <td>${e.eventTodate}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/events/edit?eventId=${e.eventId}">수정</a>

                            <form action="${pageContext.request.contextPath}/admin/events/delete"
                                  method="post"
                                  style="display:inline;">
                                <input type="hidden" name="eventId" value="${e.eventId}">
                                <button type="submit"
                                        onclick="return confirm('삭제할까요?');">
                                    삭제
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
