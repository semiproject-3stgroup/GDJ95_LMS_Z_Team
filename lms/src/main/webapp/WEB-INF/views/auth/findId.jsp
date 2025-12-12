<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<main class="auth-main">

    <div class="auth-card">

        <h1 class="auth-title">아이디 찾기</h1>
        <p class="auth-subtitle">
            회원가입 시 등록한 <strong>이름</strong>과 <strong>이메일</strong>을 입력하십시오.
        </p>

        <!-- 결과 메시지 -->
        <c:if test="${not empty foundLoginId}">
            <div class="auth-error" style="background:#ecfdf3;border:1px solid #bbf7d0;color:#166534;">
                <div style="font-weight:600; margin-bottom:6px;">회원님의 아이디는 다음과 같습니다.</div>
                <div style="font-size:18px; font-weight:800; letter-spacing:0.5px;">
                    ${foundLoginId}
                </div>
            </div>
        </c:if>

        <c:if test="${not empty errorMsg}">
            <div class="auth-error">
                ${errorMsg}
            </div>
        </c:if>

        <!-- 아이디 찾기 폼 -->
        <form action="${pageContext.request.contextPath}/find-id"
              method="post"
              class="auth-form">

            <div class="auth-field">
                <label for="userName">이름</label>
                <input type="text"
                       id="userName"
                       name="userName"
                       class="auth-input"
                       value="${userName}"
                       required>
            </div>

            <div class="auth-field">
                <label for="email">이메일</label>
                <input type="email"
                       id="email"
                       name="email"
                       class="auth-input"
                       value="${email}"
                       required
                       placeholder="example@university.ac.kr">
            </div>

            <button type="submit" class="btn btn-primary auth-submit">
                아이디 찾기
            </button>
        </form>

        <div class="auth-meta">
		  <div class="auth-meta-links">
		    <a href="${pageContext.request.contextPath}/login" class="auth-link">로그인 화면으로</a>
		    <span class="auth-meta-sep">|</span>
		    <a href="${pageContext.request.contextPath}/find-password" class="auth-link-strong">비밀번호 찾기</a>
		  </div>
		</div>

</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
