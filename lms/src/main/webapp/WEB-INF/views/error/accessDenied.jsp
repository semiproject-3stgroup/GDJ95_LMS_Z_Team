<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>접근 권한 없음</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="content">
        <h2>접근 권한이 없습니다.</h2>
        <p>이 페이지에 접근할 수 있는 권한이 없습니다.</p>

        <div style="margin-top:16px;">
            <a href="${pageContext.request.contextPath}/home">홈으로 이동</a>
        </div>
    </main>
</div>

</body>
</html>