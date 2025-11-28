<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 목록</title>
    <link rel="stylesheet" href="/css/layout.css">
</head>
<body>

    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

        <main class="content">
            <div class="page-header">
                <h1>공지사항</h1>

                <div style="margin-left:auto;">
				        <c:if test="${not empty sessionScope.loginUser 
				                     and sessionScope.loginUser.role == 'ADMIN'}">
				            <a href="/notice/add" class="btn btn-primary">공지 등록</a>
				        </c:if>
				    </div>
				</div>

            <!-- 🔍 검색 폼 -->
            <form method="get" action="/notice/list" style="margin-bottom: 16px;">
                <select name="searchType">
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
                       placeholder="검색어 입력"
                       value="${searchWord}">
                <button type="submit">검색</button>
            </form>

            <div class="card">
                <table class="table">
                    <thead>
                        <tr>
                            <th style="width: 80px; text-align:center;">번호</th>
                            <th>제목</th>
                            <th style="width: 120px; text-align:center;">작성자</th>
                            <th style="width: 100px; text-align:center;">조회수</th>
                            <th style="width: 160px; text-align:center;">등록일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty noticeList}">
                            <tr>
                                <td colspan="5" style="text-align:center;">등록된 공지가 없습니다.</td>
                            </tr>
                        </c:if>

                        <c:forEach var="n" items="${noticeList}">
                            <tr>
                                <td style="text-align:center;">
                                    ${n.noticeId}
                                </td>
                                <td>
                                    <c:if test="${n.pinnedYn == 'Y'}">
                                        <span style="font-weight:bold; color:#d9534f;">[필독]</span>
                                    </c:if>
                                    <a href="/notice/detail?noticeId=${n.noticeId}
									    &page=${currentPage}
									    &searchType=${searchType}
									    &searchWord=${searchWord}">
									    ${n.title}
									</a>
                                </td>
                                <td style="text-align:center;">
                                     ${n.writerName}
								</td>
                                <td style="text-align:center;">
                                    ${n.hitCount}
                                </td>
                                <td style="text-align:center;">
                                    ${fn:substring(n.createdate, 0, 16)}
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- 페이징 영역 -->
			<div class="pagination" style="margin-top:16px; text-align:center;">
			    <c:if test="${currentPage > 1}">
			        <a href="/notice/list?page=1&searchType=${searchType}&searchWord=${searchWord}">&laquo; 처음</a>
			        <a href="/notice/list?page=${currentPage - 1}&searchType=${searchType}&searchWord=${searchWord}">&lt; 이전</a>
			    </c:if>
			
			    <c:forEach begin="${startPage}" end="${endPage}" var="p">
			        <c:choose>
			            <c:when test="${p == currentPage}">
			                <span style="font-weight:bold; margin:0 4px;">${p}</span>
			            </c:when>
			            <c:otherwise>
			                <a href="/notice/list?page=${p}&searchType=${searchType}&searchWord=${searchWord}"
			                   style="margin:0 4px;">${p}</a>
			            </c:otherwise>
			        </c:choose>
			    </c:forEach>
			
			    <c:if test="${currentPage < lastPage}">
			        <a href="/notice/list?page=${currentPage + 1}&searchType=${searchType}&searchWord=${searchWord}">다음 &gt;</a>
			        <a href="/notice/list?page=${lastPage}&searchType=${searchType}&searchWord=${searchWord}">마지막 &raquo;</a>
			    </c:if>
			</div>

        </main>
    </div>

</body>
</html>
