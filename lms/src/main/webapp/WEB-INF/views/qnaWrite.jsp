<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>질문 게시판 &gt; 글쓰기</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
</head>
<body class="board-page qna-page">

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">

        <div class="page-header">
            <div>
                <h1 class="page-title">질문 게시글 작성</h1>
                <c:if test="${not empty currentCourseName}">
                    <p style="margin:4px 0 0; font-size:13px; color:#6b7280;">
                        현재 강의 : ${currentCourseName}
                    </p>
                </c:if>
            </div>

            <div class="page-header-actions">
                <a href="${pageContext.request.contextPath}/qna/list/${courseId}"
                   class="btn btn-secondary">
                    목록으로
                </a>
            </div>
        </div>

        <div class="card">
            <form action="${pageContext.request.contextPath}/qna/write/${courseId}"
                  method="post">
                <input type="hidden" name="userId" value="${currentUserId}">
                <input type="hidden" name="courseId" value="${courseId}">

                <!-- 분류 (지금은 실제 저장 안하면 name 빼두거나 나중에 추가) -->
                <div class="board-form-row" style="margin-bottom:14px;">
                    <label class="board-form-label">분류</label>
                    <select class="board-form-input" name="category">
                        <option value="LECTURE">강의 질문</option>
                        <option value="ASSIGNMENT">과제 질문</option>
                        <option value="ETC">기타</option>
                    </select>
                </div>

                <div class="board-form-row" style="margin-bottom:14px;">
                    <label for="title" class="board-form-label">제목</label>
                    <input type="text"
                           id="title"
                           name="title"
                           class="board-form-input"
                           placeholder="제목을 입력하세요."
                           required>
                </div>

                <div class="board-form-row" style="margin-bottom:14px;">
                    <label class="board-form-label">작성자</label>
                    <input type="text"
                           class="board-form-input"
                           value="${sessionScope.loginUser.userName} (ID: ${currentUserId})"
                           readonly>
                </div>

                <div class="board-form-row" style="margin-bottom:14px;">
                    <label for="content" class="board-form-label">내용</label>
                    <textarea id="content"
                              name="content"
                              rows="10"
                              class="board-form-textarea"
                              placeholder="내용을 입력하세요."
                              required></textarea>
                </div>

                <%-- 파일 업로드 아직 구현 안됐으면 name 제거해도 됨 --%>
                <div class="board-form-row" style="margin-bottom:18px;">
                    <label class="board-form-label">첨부파일</label>
                    <input type="file" class="board-form-input">
                </div>

                <div class="board-detail-footer">
                    <button type="submit" class="btn btn-primary">
                        등록
                    </button>
                    <a href="${pageContext.request.contextPath}/qna/list/${courseId}"
                       class="btn btn-secondary">
                        취소
                    </a>
                </div>
            </form>
        </div>

    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
