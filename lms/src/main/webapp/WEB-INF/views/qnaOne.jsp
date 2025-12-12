<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>질문 게시판 &gt; 상세</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
</head>
<body class="board-page qna-page">

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">
        <!-- 페이지 헤더 -->
        <div class="page-header">
            <div>
                <h1 class="page-title">질문 게시판</h1>
                <c:if test="${not empty currentCourseName}">
                    <p style="margin:4px 0 0; font-size:13px; color:#6b7280;">
                        현재 강의 : ${currentCourseName}
                    </p>
                </c:if>
            </div>

            <div class="page-header-actions">
                <a href="${pageContext.request.contextPath}/qna/list/${courseId}"
                   class="btn btn-secondary">
                    목록
                </a>

                <c:if test="${qnaPost.userId == currentUserId}">
                    <a href="${pageContext.request.contextPath}/qna/modifyForm/${courseId}/${qnaPost.postId}"
                       class="btn btn-primary">
                        수정
                    </a>

                    <form action="${pageContext.request.contextPath}/qna/delete/${courseId}/${qnaPost.postId}"
                          method="post"
                          class="inline-form"
                          onsubmit="return confirm('정말로 게시글을 삭제하시겠습니까?');">
                        <button type="submit" class="btn btn-primary btn-danger">
                            삭제
                        </button>
                    </form>
                </c:if>
            </div>
        </div>

        <c:if test="${empty qnaPost}">
            <div class="card board-detail-card" style="text-align:center;">
                <p style="color:#ef4444; font-weight:600;">
                    요청한 게시글을 찾을 수 없습니다.
                </p>
                <div class="board-detail-footer">
                    <a href="${pageContext.request.contextPath}/qna/list/${courseId}"
                       class="btn btn-secondary">
                        목록으로
                    </a>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty qnaPost}">
            <div class="card board-detail-card">
                <h2 class="board-detail-title">${qnaPost.title}</h2>

                <div class="board-detail-meta">
                    <span>작성자: ${qnaPost.userName}</span>
                    <span>작성일: ${qnaPost.formattedCreatedate}</span>
                    <c:if test="${qnaPost.updatedate != null}">
                        <span>수정일: ${qnaPost.formattedUpdatedate}</span>
                    </c:if>
                    <span>조회수: ${qnaPost.hitCount}</span>
                </div>

                <div class="board-detail-body">
                    ${qnaPost.content}
                </div>

                <div class="board-detail-footer">
                    <a href="${pageContext.request.contextPath}/qna/list/${courseId}"
                       class="btn btn-secondary">
                        목록으로
                    </a>

                    <c:if test="${qnaPost.userId == currentUserId}">
                        <a href="${pageContext.request.contextPath}/qna/modifyForm/${courseId}/${qnaPost.postId}"
                           class="btn btn-primary">
                            수정
                        </a>

                        <form action="${pageContext.request.contextPath}/qna/delete/${courseId}/${qnaPost.postId}"
                              method="post"
                              class="inline-form"
                              onsubmit="return confirm('정말로 게시글을 삭제하시겠습니까?');">
                            <button type="submit" class="btn btn-primary btn-danger">
                                삭제
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>
        </c:if>
    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
