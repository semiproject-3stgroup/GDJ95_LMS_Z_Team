<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지 상세</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/notice.css">
</head>
<body class="notice-page">

    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

        <main class="main-content">
            <!-- 페이지 헤더 -->
            <div class="page-header">
                <h1 class="page-title">공지사항</h1>

                <div class="page-header-actions">
                    <c:if test="${not empty sessionScope.loginUser 
                                 and sessionScope.loginUser.userId == notice.userId}">
                        <a href="${pageContext.request.contextPath}/notice/edit?noticeId=${notice.noticeId}"
                           class="btn btn-secondary">
                            수정
                        </a>

                        <form action="${pageContext.request.contextPath}/notice/delete"
                              method="post"
                              class="inline-form"
                              onsubmit="return confirm('정말 삭제할까요? 복구할 수 없습니다.');">
                            <input type="hidden" name="noticeId" value="${notice.noticeId}">
                            <input type="hidden" name="page" value="${currentPage}">
                            <button type="submit" class="btn btn-primary btn-danger">
                                삭제
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>

            <!-- 내용 카드 -->
            <div class="card notice-detail-card">
                <h2 class="notice-detail-title">${notice.title}</h2>

                <div class="notice-detail-meta">
                    <span>작성자: ${notice.writerName}</span>
                    <span>조회수: ${notice.hitCount}</span>
                    <span>작성일: ${notice.createdate}</span>
                </div>

                <div class="notice-detail-body">
                    ${notice.content}
                </div>

                <c:if test="${not empty fileList}">
                    <div class="notice-detail-files">
                        <strong>첨부파일</strong>
                        <ul>
                            <c:forEach var="file" items="${fileList}">
                                <li>
                                    <a href="${pageContext.request.contextPath}/notice/file/download?fileId=${file.fileId}">
                                        ${file.originName}
                                    </a>
                                    <span class="file-size">
                                        (${file.fileSize} Byte)
                                    </span>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>
            </div>

            <!-- 버튼 영역 -->
            <div class="notice-detail-footer">
                <a href="${pageContext.request.contextPath}/notice/list?page=${currentPage}
                         &searchType=${searchType}
                         &searchWord=${searchWord}"
                   class="btn btn-secondary">
                    목록으로
                </a>
            </div>
        </main>
    </div>

</body>
</html>
