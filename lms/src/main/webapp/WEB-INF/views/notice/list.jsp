<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 목록</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/notice.css">
</head>
<body class="notice-page">

    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

        <!-- 메인 컨텐츠 -->
        <main class="main-content">

            <div class="notice-2col">
                <!-- 왼쪽 : 게시판 메인 -->
                <section class="notice-main">
                    <!-- 페이지 헤더 -->
                    <div class="page-header">
                        <h1 class="page-title">공지사항</h1>

                        <div class="page-header-actions">
                            <c:if test="${not empty sessionScope.loginUser 
                                         and sessionScope.loginUser.role == 'ADMIN'}">
                                <a href="${pageContext.request.contextPath}/notice/add"
                                   class="btn btn-primary">
                                    공지 등록
                                </a>
                            </c:if>
                        </div>
                    </div>

                    <!-- 검색 폼 -->
                    <form method="get"
                          action="${pageContext.request.contextPath}/notice/list"
                          class="notice-search-bar">

                        <select name="searchType" class="notice-search-select">
                            <option value="all"
                                <c:if test="${empty searchType or searchType == 'all'}">selected</c:if>>
                                전체
                            </option>
                            <option value="title"
                                <c:if test="${searchType == 'title'}">selected</c:if>>
                                제목
                            </option>
                            <option value="content"
                                <c:if test="${searchType == 'content'}">selected</c:if>>
                                내용
                            </option>
                        </select>

                        <input type="text"
                               name="searchWord"
                               class="notice-search-input"
                               placeholder="검색어를 입력하세요"
                               value="${searchWord}"/>

                        <button type="submit" class="btn btn-secondary notice-search-btn">
                            검색
                        </button>
                    </form>

                    <!-- 목록 카드 -->
                    <div class="card notice-list-card">
                        <table class="table notice-table">
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>조회수</th>
                                    <th>등록일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${empty noticeList}">
                                    <tr>
                                        <td colspan="5" class="table-empty">
                                            등록된 공지가 없습니다.
                                        </td>
                                    </tr>
                                </c:if>

                                <c:forEach var="n" items="${noticeList}">
                                    <tr>
                                        <td class="table-cell-center">
                                            ${n.noticeId}
                                        </td>
                                        <td class="table-cell-title">
                                            <c:if test="${n.pinnedYn == 'Y'}">
                                                <span class="notice-badge-pill">필독</span>
                                            </c:if>

                                            <%-- 상세보기 URL --%>
                                            <c:url var="detailUrl" value="/notice/detail">
                                                <c:param name="noticeId" value="${n.noticeId}" />
                                                <c:param name="page" value="${currentPage}" />
                                                <c:param name="searchType" value="${searchType}" />
                                                <c:param name="searchWord" value="${searchWord}" />
                                            </c:url>

                                            <a class="notice-title-link" href="${detailUrl}">
                                                ${n.title}
                                            </a>
                                        </td>
                                        <td class="table-cell-center">
                                            ${n.writerName}
                                        </td>
                                        <td class="table-cell-center">
                                            ${n.hitCount}
                                        </td>
                                        <td class="table-cell-center">
                                            ${fn:replace(fn:substring(n.createdate, 0, 16), 'T', ' ')}
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- 페이징 영역 -->
                    <div class="pagination">
                        <c:if test="${currentPage > 1}">
                            <%-- 처음 페이지 --%>
                            <c:url var="firstPageUrl" value="/notice/list">
                                <c:param name="page" value="1" />
                                <c:param name="searchType" value="${searchType}" />
                                <c:param name="searchWord" value="${searchWord}" />
                            </c:url>
                            <a href="${firstPageUrl}" class="page-link">&laquo; 처음</a>

                            <%-- 이전 페이지 --%>
                            <c:url var="prevPageUrl" value="/notice/list">
                                <c:param name="page" value="${currentPage - 1}" />
                                <c:param name="searchType" value="${searchType}" />
                                <c:param name="searchWord" value="${searchWord}" />
                            </c:url>
                            <a href="${prevPageUrl}" class="page-link">&lt; 이전</a>
                        </c:if>

                        <c:forEach begin="${startPage}" end="${endPage}" var="p">
                            <c:choose>
                                <c:when test="${p == currentPage}">
                                    <span class="page-link current">${p}</span>
                                </c:when>
                                <c:otherwise>
                                    <c:url var="pageUrl" value="/notice/list">
                                        <c:param name="page" value="${p}" />
                                        <c:param name="searchType" value="${searchType}" />
                                        <c:param name="searchWord" value="${searchWord}" />
                                    </c:url>
                                    <a href="${pageUrl}" class="page-link">${p}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <c:if test="${currentPage < lastPage}">
                            <%-- 다음 페이지 --%>
                            <c:url var="nextPageUrl" value="/notice/list">
                                <c:param name="page" value="${currentPage + 1}" />
                                <c:param name="searchType" value="${searchType}" />
                                <c:param name="searchWord" value="${searchWord}" />
                            </c:url>
                            <a href="${nextPageUrl}" class="page-link">다음 &gt;</a>

                            <%-- 마지막 페이지 --%>
                            <c:url var="lastPageUrl" value="/notice/list">
                                <c:param name="page" value="${lastPage}" />
                                <c:param name="searchType" value="${searchType}" />
                                <c:param name="searchWord" value="${searchWord}" />
                            </c:url>
                            <a href="${lastPageUrl}" class="page-link">마지막 &raquo;</a>
                        </c:if>
                    </div>
                </section>

                <!-- 오른쪽 : 안내 카드 -->
                <aside class="notice-side">
                    <div class="notice-side-card">
                        <!-- 상단 : 제목(왼쪽) + 링크(오른쪽) -->
                        <div class="notice-side-top">
                            <div class="notice-side-copy">
                                <h2 class="notice-side-title">학사 안내</h2>
                                <%-- 안내 문구 제거 --%>
                            </div>

                            <ul class="notice-side-links">
                                <li>
                                    <a href="${pageContext.request.contextPath}/calendar/academic">
                                        📅 학사 캘린더 바로가기
                                    </a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/course/register">
                                        📝 수강신청 페이지
                                    </a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/mypage/score">
                                        🎓 학점 조회
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <!-- 하단 : 세로 배너 이미지 -->
                        <div class="notice-side-illustration"></div>
                    </div>
                </aside>
            </div>

        </main>
    </div>  <!-- .layout 끝 -->

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
