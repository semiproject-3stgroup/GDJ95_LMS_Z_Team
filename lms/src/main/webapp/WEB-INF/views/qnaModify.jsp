<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>질문 게시판 &gt; 수정</title>

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
                <h1 class="page-title">질문 게시글 수정</h1>
                <c:if test="${not empty currentCourseName}">
                    <p style="margin:4px 0 0; font-size:13px; color:#6b7280;">
                        현재 강의 : ${currentCourseName}
                    </p>
                </c:if>
            </div>

            <div class="page-header-actions">
                <a href="${pageContext.request.contextPath}/qna/one/${courseId}/${qnaPost.postId}"
                   class="btn btn-secondary">
                    상세보기
                </a>
            </div>
        </div>

        <c:if test="${param.error == 'unauthorized'}">
            <div class="card" style="margin-bottom:12px;">
                <p style="color:#ef4444; font-weight:600; font-size:13px;">
                    권한이 없습니다. 해당 게시글의 작성자만 수정할 수 있습니다.
                </p>
            </div>
        </c:if>

        <div class="card">
            <form action="${pageContext.request.contextPath}/qna/modify/${courseId}/${qnaPost.postId}"
                  method="post">
                <input type="hidden" name="courseId" value="${courseId}">
                <input type="hidden" name="postId" value="${qnaPost.postId}">
                <input type="hidden" name="userId" value="${currentUserId}">

                <div class="board-form-row" style="margin-bottom:14px;">
                    <label class="board-form-label">게시글 번호</label>
                    <input type="text"
                           class="board-form-input"
                           value="${qnaPost.postId}"
                           readonly>
                </div>

                <div class="board-form-row" style="margin-bottom:14px;">
                    <label class="board-form-label">작성자</label>
                    <input type="text"
                           class="board-form-input"
                           value="${qnaPost.userName} (ID: ${qnaPost.userId})"
                           readonly>
                </div>

                <div class="board-form-row" style="margin-bottom:14px;">
                    <label for="title" class="board-form-label">제목</label>
                    <input type="text"
                           id="title"
                           name="title"
                           class="board-form-input"
                           value="${qnaPost.title}"
                           required>
                </div>

                <div class="board-form-row" style="margin-bottom:14px;">
                    <label for="content" class="board-form-label">내용</label>
                    <textarea id="content"
                              name="content"
                              rows="10"
                              class="board-form-textarea"
                              required>${qnaPost.content}</textarea>
                </div>

                <div class="board-form-row" style="margin-bottom:18px;">
                    <label class="board-form-label">첨부파일</label>
                    <%-- TODO: 실제 파일 수정 로직 연결 시 name 속성 추가 --%>
                    <input type="file" class="board-form-input">
                </div>

                <div class="board-detail-footer">
                    <button type="submit" class="btn btn-primary">
                        수정 완료
                    </button>
                    <a href="${pageContext.request.contextPath}/qna/one/${courseId}/${qnaPost.postId}"
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
