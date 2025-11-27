<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>학사 일정 등록</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">
        <h2>학사 일정 등록</h2>

        <form method="post" action="${pageContext.request.contextPath}/admin/events/add">
            <div class="form-row">
                <label>행사명</label>
                <input type="text" name="eventName" required>
            </div>

            <div class="form-row">
                <label>시작일시</label>
                <input type="datetime-local" name="eventFromdate" required>
            </div>

            <div class="form-row">
                <label>종료일시</label>
                <input type="datetime-local" name="eventTodate" required>
            </div>

            <div class="form-row">
                <label>내용</label>
                <textarea name="eventContext" rows="4" cols="40" required></textarea>
            </div>

            <div class="form-row">
                <button type="submit">등록</button>
                <a href="${pageContext.request.contextPath}/admin/events">목록으로</a>
            </div>
        </form>
    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
