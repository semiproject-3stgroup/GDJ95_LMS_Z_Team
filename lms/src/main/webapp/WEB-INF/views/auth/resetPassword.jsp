<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 재설정</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<main class="auth-main">

    <div class="auth-card">

        <h1 class="auth-title">비밀번호 재설정</h1>
        <p class="auth-subtitle">새 비밀번호를 입력해 주세요.</p>

        <c:if test="${not empty errorMsg}">
            <div class="auth-error">
                ${errorMsg}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/reset-password"
              method="post"
              id="resetPwForm"
              class="auth-form">

            <!-- 어떤 계정인지 보여주기용 -->
            <div class="auth-field">
                <label>아이디</label>
                <input type="text" value="${loginId}" class="auth-input" disabled>
            </div>

            <!-- 서버로 넘어갈 loginId -->
            <input type="hidden" name="loginId" value="${loginId}">

            <div class="auth-field">
                <label for="newPassword">새 비밀번호</label>
                <input type="password"
                       id="newPassword"
                       name="newPassword"
                       class="auth-input"
                       required
                       placeholder="숫자+특수문자 포함 8~16자">
            </div>

            <div class="auth-field">
                <label for="confirmPassword">새 비밀번호 확인</label>
                <input type="password"
                       id="confirmPassword"
                       name="confirmPassword"
                       class="auth-input"
                       required>
            </div>

            <button type="submit" class="btn btn-primary auth-submit">
                비밀번호 변경
            </button>
        </form>

        <div class="auth-meta">
            <div class="auth-meta-links">
                <a href="${pageContext.request.contextPath}/login" class="auth-link">로그인 화면으로</a>
                <span class="auth-meta-sep">|</span>
                <a href="${pageContext.request.contextPath}/find-id" class="auth-link-strong">아이디 찾기</a>
            </div>
            <div class="auth-meta-sub">
                비밀번호 변경 후 다시 로그인하시기 바랍니다.
            </div>
        </div>

    </div>

</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
document.getElementById('resetPwForm').addEventListener('submit', function (e) {
    const pw = this.newPassword.value;
    const cpw = this.confirmPassword.value;

    if (pw !== cpw) {
        alert('비밀번호가 일치하지 않습니다.');
        e.preventDefault();
        return;
    }

    // 8~16자 + 숫자 + 특수문자 포함
    const rule = /^(?=.*\d)(?=.*[!@#$%^&*()_\-+=\[{\]};:'",.<>/?\\|`~]).{8,16}$/;

    if (!rule.test(pw)) {
        alert('비밀번호는 8~16자이며 숫자와 특수문자를 포함해야 합니다.');
        e.preventDefault();
    }
});
</script>

</body>
</html>
