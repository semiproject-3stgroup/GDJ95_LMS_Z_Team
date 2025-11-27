<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>학사 일정 수정</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">
        <h2>학사 일정 수정</h2>

        <form method="post" action="${pageContext.request.contextPath}/admin/events/edit">
            <input type="hidden" name="eventId" value="${event.eventId}">

            <div class="form-row">
                <label>행사명</label>
                <input type="text" name="eventName"
                       value="${event.eventName}" required>
            </div>

            <div class="form-row">
                <label>시작일시</label>
                <input type="datetime-local" name="eventFromdate"
                       value="${event.eventFromdate}" required>
            </div>

            <div class="form-row">
                <label>종료일시</label>
                <input type="datetime-local" name="eventTodate"
                       value="${event.eventTodate}" required>
            </div>

            <div class="form-row">
                <label>내용</label>
                <textarea name="eventContext" rows="4" cols="40" required>${event.eventContext}</textarea>
            </div>

            <div class="form-row">
                <button type="submit">저장</button>
                <a href="${pageContext.request.contextPath}/admin/events">목록으로</a>
            </div>
        </form>
    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
