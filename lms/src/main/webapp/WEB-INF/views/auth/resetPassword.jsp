<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 재설정</title>
    <link rel="stylesheet" href="/css/auth.css">
</head>
<body>

<div class="auth-page">
    <div class="auth-card">

        <h2>비밀번호 재설정</h2>
        <p class="subtitle">
            새 비밀번호를 입력해 주세요.
        </p>

        <c:if test="${not empty errorMsg}">
            <div class="alert error">
                ${errorMsg}
            </div>
        </c:if>

        <form action="/reset-password" method="post" id="resetPwForm" class="form-vertical">

            <!-- 어떤 계정인지 알려주기용 (출력만) -->
            <div class="form-group">
                <label>아이디</label>
                <input type="text" value="${loginId}" disabled>
            </div>

            <!-- 실제로 서버에 넘어갈 loginId -->
            <input type="hidden" name="loginId" value="${loginId}">

            <div class="form-group">
                <label>새 비밀번호<span class="req">*</span></label>
                <input type="password" name="newPassword" required
                       placeholder="숫자+특수문자 포함 8~16자">
            </div>

            <div class="form-group">
                <label>새 비밀번호 확인<span class="req">*</span></label>
                <input type="password" name="confirmPassword" required>
            </div>

            <div class="btn-row">
                <a href="/login" class="btn-secondary">로그인 화면으로</a>
                <button type="submit" class="btn-primary">비밀번호 변경</button>
            </div>
        </form>

    </div>
</div>

<script>
document.getElementById('resetPwForm').addEventListener('submit', function (e) {
    const pw = this.newPassword.value;
    const cpw = this.confirmPassword.value;

    if (pw !== cpw) {
        alert('비밀번호가 일치하지 않습니다.');
        e.preventDefault();
        return;
    }
    if (pw.length < 8 || pw.length > 16) {
        alert('비밀번호는 8~16자여야 합니다.');
        e.preventDefault();
        return;
    }
});
</script>

</body>
</html>
