<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 변경</title>

    <!-- 공통 레이아웃 CSS -->
    <link rel="stylesheet" href="/css/layout.css">

    <!-- 마이페이지  CSS -->
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="content">

        <div class="pw-container">
            <div class="pw-title">비밀번호 변경</div>
            <div class="pw-subtitle">
                현재 비밀번호를 확인하고<br>
                새 비밀번호를 설정바랍니다.
            </div>

            <c:if test="${not empty msg}">
                <div class="pw-alert">
                    ${msg}
                </div>
            </c:if>

            <form action="/mypage/password" method="post">

                <div class="pw-form-group">
                    <label class="pw-label" for="currentPassword">현재 비밀번호</label>
                    <input type="password" id="currentPassword" name="currentPassword"
                           class="pw-input" required>
                </div>

                <div class="pw-form-group">
                    <label class="pw-label" for="newPassword">새 비밀번호</label>
                    <input type="password" id="newPassword" name="newPassword"
                           class="pw-input" required>
                    <div class="pw-helper">숫자 + 특수문자 포함 8~16자</div>
                </div>

                <div class="pw-form-group">
                    <label class="pw-label" for="newPasswordConfirm">새 비밀번호 확인</label>
                    <input type="password" id="newPasswordConfirm" name="newPasswordConfirm"
                           class="pw-input" required>
                </div>

                <div class="pw-btn-area">
                    <button type="submit" class="pw-btn-primary">비밀번호 변경</button>
                    <button type="button" class="pw-btn-secondary"
        					onclick="location.href='/mypage';">마이페이지로</button>

                </div>
            </form>
        </div>

    </main>
</div>

</body>
</html>
