<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>질문 게시판</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
</head>
<body class="board-page qna-page">

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">

        <div class="board-2col">
            <!-- 왼쪽 : Q&A 게시판 -->
            <section class="board-main">
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
                        <a href="${pageContext.request.contextPath}/qna/writeForm/${courseId}"
                           class="btn btn-primary">
                            글쓰기
                        </a>
                    </div>
                </div>

                <!-- 검색 폼 -->
                <form method="get"
                      action="${pageContext.request.contextPath}/qna/list/${courseId}"
                      class="board-search-bar">
                    <input type="text"
                           name="searchKeyword"
                           class="board-search-input"
                           placeholder="검색어를 입력하세요"
                           value="${searchKeyword}">
                    <button type="submit" class="btn btn-secondary board-search-btn">
                        검색
                    </button>
                </form>

                <!-- 목록 카드 -->
                <div class="card board-list-card">
                    <table class="table board-table">
                        <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>작성일</th>
                            <th>조회수</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty qnaList}">
                            <tr>
                                <td colspan="5" class="table-empty">
                                    등록된 게시글이 없습니다.
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="qna" items="${qnaList}">
                            <tr>
                                <td class="table-cell-center">
                                    ${qna.postId}
                                </td>
                                <td class="table-cell-title">
                                    <c:url var="detailUrl" value="/qna/one/${courseId}/${qna.postId}" />
                                    <a href="${pageContext.request.contextPath}${detailUrl}"
                                       class="board-title-link">
                                        ${qna.title}
                                    </a>
                                    <c:if test="${qna.commentCount > 0}">
                                        [${qna.commentCount}]
                                    </c:if>
                                </td>
                                <td class="table-cell-center">
                                    ${qna.userName}
                                </td>
                                <td class="table-cell-center">
                                    ${qna.formattedCreatedate}
                                </td>
                                <td class="table-cell-center">
                                    ${qna.hitCount}
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- 페이징 -->
                <div class="pagination">
                    <%-- 처음 / 이전 --%>
                    <c:if test="${currentPage > 1}">
                        <c:url var="firstPageUrl" value="/qna/list/${courseId}">
                            <c:param name="page" value="1"/>
                            <c:param name="searchKeyword" value="${searchKeyword}"/>
                        </c:url>
                        <a href="${pageContext.request.contextPath}${firstPageUrl}"
                           class="page-link">&laquo; 처음</a>

                        <c:url var="prevPageUrl" value="/qna/list/${courseId}">
                            <c:param name="page" value="${currentPage - 1}"/>
                            <c:param name="searchKeyword" value="${searchKeyword}"/>
                        </c:url>
                        <a href="${pageContext.request.contextPath}${prevPageUrl}"
                           class="page-link">&lt; 이전</a>
                    </c:if>

                    <%-- 페이지 번호 --%>
                    <c:forEach begin="${startPage}" end="${endPage}" var="p">
                        <c:choose>
                            <c:when test="${p == currentPage}">
                                <span class="page-link current">${p}</span>
                            </c:when>
                            <c:otherwise>
                                <c:url var="pageUrl" value="/qna/list/${courseId}">
                                    <c:param name="page" value="${p}"/>
                                    <c:param name="searchKeyword" value="${searchKeyword}"/>
                                </c:url>
                                <a href="${pageContext.request.contextPath}${pageUrl}"
                                   class="page-link">${p}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <%-- 다음 / 마지막 --%>
                    <c:if test="${currentPage < totalPages}">
                        <c:url var="nextPageUrl" value="/qna/list/${courseId}">
                            <c:param name="page" value="${currentPage + 1}"/>
                            <c:param name="searchKeyword" value="${searchKeyword}"/>
                        </c:url>
                        <a href="${pageContext.request.contextPath}${nextPageUrl}"
                           class="page-link">다음 &gt;</a>

                        <c:url var="lastPageUrl" value="/qna/list/${courseId}">
                            <c:param name="page" value="${totalPages}"/>
                            <c:param name="searchKeyword" value="${searchKeyword}"/>
                        </c:url>
                        <a href="${pageContext.request.contextPath}${lastPageUrl}"
                           class="page-link">마지막 &raquo;</a>
                    </c:if>
                </div>
            </section>

            <!-- 오른쪽 : 안내/배너 -->
            <aside class="board-side">
                <div class="board-side-card">
                    <div class="board-side-top">
                        <div>
                            <h2 class="board-side-title">Q&amp;A 이용 안내</h2>
                            <p class="board-side-text">
                                강의와 과제 관련 궁금한 점이 있다면 질문 게시판을 이용해 주세요.
                            </p>
                        </div>
                        <ul class="board-side-links">
                            <li>
                                <a href="${pageContext.request.contextPath}/assignment/list/${courseId}">
                                    ✅ 진행 중인 과제 보기
                                </a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/course/my">
                                    📚 내 수강 과목
                                </a>
                            </li>
                        </ul>
                    </div>

                    <div class="board-side-banner"></div>
                </div>
            </aside>
        </div>

    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
