<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LMS 메인 페이지</title>

    <!-- CSS 로딩 -->
    <link rel="stylesheet" href="/css/layout.css">
</head>

<body>

    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">

        <!-- 🔹 왼쪽 사이드바: 이제 공통 파일 include -->
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
        <%-- 또는 <jsp:include page="/WEB-INF/views/common/sidebar.jsp" /> 도 가능 --%>

        <!-- 🔹 오른쪽 본문 -->
        <main class="main-content">
            <h2>메인 페이지</h2>

            <div class="box">
                <c:choose>
                    <c:when test="${not empty loginUser}">
                        <p style="font-size: 16px; margin-bottom: 10px;">
                            <strong>${loginUser.userName}</strong> 님 환영합니다 😊
                        </p>
                        <p style="color: #555;">
                            학사 일정, 내 강의, 알림, 과제 제출 등<br>
                            앞으로 이 영역에 카드형 컴포넌트들이 배치될 예정입니다.
                        </p>
                    </c:when>

                    <c:otherwise>
                        <p style="font-size: 16px; margin-bottom: 10px;">
                            LMS 학사관리 시스템에 오신 것을 환영합니다.
                        </p>
                        <p style="color: #555; margin-bottom: 20px;">
                            로그인 후 다양한 학사 기능을 이용할 수 있습니다.
                        </p>

                        <a href="${pageContext.request.contextPath}/login"
                           style="font-size: 16px; padding: 10px 18px; background: #4a8fff; color: white; text-decoration: none; border-radius: 4px;">
                            로그인하기
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
