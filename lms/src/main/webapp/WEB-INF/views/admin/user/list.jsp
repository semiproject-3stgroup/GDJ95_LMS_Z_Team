<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>관리자 > 사용자 관리</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>

<body class="admin-page">
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
  <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

  <main class="main-content">

    <div class="page-header">
      <div>
        <h1 class="page-title">사용자 관리</h1>
        <p class="page-subtitle">학사시스템에 등록된 사용자 계정을 조회·관리합니다.</p>
      </div>
    </div>

    <c:set var="userTotalCount" value="${totalCount != null ? totalCount : 0}" />
    <c:set var="currentPage" value="${page != null ? page : 1}" />
    <c:set var="pageSizeValue" value="${pageSize != null ? pageSize : 10}" />
    <c:set var="pageTotalPages" value="${totalPages != null ? totalPages : 0}" />
    <c:set var="pageStartPage" value="${startPage != null ? startPage : 1}" />
    <c:set var="pageEndPage" value="${endPage != null ? endPage : 1}" />

    <c:set var="searchQuery" value="" />
    <c:if test="${not empty param.searchType and not empty param.searchKeyword}">
      <c:set var="searchQuery" value="&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}" />
    </c:if>

    <!-- 검색바: 우리 게시판 스타일 재사용 -->
    <form action="${pageContext.request.contextPath}/admin/user/list" method="get" class="board-search-bar">
      <input type="hidden" name="page" value="1">
      <input type="hidden" name="pageSize" value="${pageSizeValue}">

      <select name="searchType" class="board-search-select">
        <option value="userName" <c:if test="${param.searchType == 'userName'}">selected</c:if>>이름</option>
        <option value="loginId" <c:if test="${param.searchType == 'loginId'}">selected</c:if>>ID</option>
        <option value="role" <c:if test="${param.searchType == 'role'}">selected</c:if>>역할</option>
        <option value="departmentName" <c:if test="${param.searchType == 'departmentName'}">selected</c:if>>학과</option>
      </select>

      <input type="text" name="searchKeyword" value="${param.searchKeyword}"
             placeholder="검색어를 입력하세요" class="board-search-input">

      <button type="submit" class="btn btn-primary board-search-btn">검색</button>

      <c:if test="${not empty param.searchKeyword}">
        <a class="btn" href="${pageContext.request.contextPath}/admin/user/list?pageSize=${pageSizeValue}">초기화</a>
      </c:if>
    </form>

    <!-- 카드 + 테이블 -->
    <div class="box board-list-card">
      <div class="box-header" style="margin-bottom:10px;">
        <h3 class="box-title">사용자 목록 (${userTotalCount}건)</h3>

        <div style="display:flex; align-items:center; gap:10px;">
          <span style="font-size:12px; color:#6b7280;">표시</span>
          <select class="board-search-select" style="padding:6px 12px;"
                  onchange="location.href='?page=1&pageSize='+this.value+'${searchQuery}'">
            <option value="10" <c:if test="${pageSizeValue == 10}">selected</c:if>>10</option>
            <option value="20" <c:if test="${pageSizeValue == 20}">selected</c:if>>20</option>
            <option value="50" <c:if test="${pageSizeValue == 50}">selected</c:if>>50</option>
          </select>
        </div>
      </div>

      <table class="table board-table admin-user-table">
        <thead>
          <tr>
            <th>No</th>
            <th>이름</th>
            <th>ID</th>
            <th>역할</th>
            <th>학과</th>
            <th>이메일</th>
            <th>상태</th>
            <th>가입일</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="user" items="${userList}" varStatus="st">
            <tr>
              <td class="board-cell-center">${userTotalCount - ((currentPage - 1) * pageSizeValue + st.index)}</td>
              <td class="board-cell-center">${user.userName}</td>
              <td class="board-cell-center">${user.loginId}</td>
              <td class="board-cell-center">${user.role}</td>
              <td class="board-cell-center">${user.departmentName != null ? user.departmentName : '-'}</td>
              <td>${user.email}</td>
              <td class="board-cell-center">
				  <c:set var="stVal" value="${fn:toUpperCase(fn:trim(user.status))}" />
				
				  <c:choose>
				    <c:when test="${stVal eq 'ACTIVE'}">
				      <form class="inline-form"
				            action="${pageContext.request.contextPath}/admin/user/status"
				            method="post"
				            onsubmit="return confirm('비활성으로 전환하시겠습니다? 해당 유저의 로그인이 제한됩니다.?');">
				        <input type="hidden" name="userId" value="${user.userId}">
				        <input type="hidden" name="status" value="INACTIVE">
				
				        <input type="hidden" name="page" value="${currentPage}">
				        <input type="hidden" name="pageSize" value="${pageSizeValue}">
				        <input type="hidden" name="searchType" value="${param.searchType}">
				        <input type="hidden" name="searchKeyword" value="${param.searchKeyword}">
				
				        <button type="submit" class="admin-status-pill">활성</button>
				      </form>
				    </c:when>
				
				    <c:otherwise>
				      <form class="inline-form"
				            action="${pageContext.request.contextPath}/admin/user/status"
				            method="post"
				            onsubmit="return confirm('활성으로 전환하시겠습니다? 해다 유저의 로그인 권한이 부여됩니다.');">
				        <input type="hidden" name="userId" value="${user.userId}">
				        <input type="hidden" name="status" value="ACTIVE">
				
				        <input type="hidden" name="page" value="${currentPage}">
				        <input type="hidden" name="pageSize" value="${pageSizeValue}">
				        <input type="hidden" name="searchType" value="${param.searchType}">
				        <input type="hidden" name="searchKeyword" value="${param.searchKeyword}">
				
				        <button type="submit" class="admin-status-pill inactive">비활성</button>
				      </form>
				    </c:otherwise>
				  </c:choose>
				</td>
              <td class="board-cell-center"><fmt:formatDate value="${user.createdate}" pattern="yyyy-MM-dd"/></td>
            </tr>
          </c:forEach>

          <c:if test="${empty userList}">
            <tr><td class="table-empty" colspan="8">등록된 사용자 정보가 없습니다.</td></tr>
          </c:if>
        </tbody>
      </table>

      <!-- 페이징: 우리 pagination 재사용 -->
      <div class="pagination">
        <c:if test="${currentPage > 1}">
          <a class="page-link" href="?page=${currentPage-1}&pageSize=${pageSizeValue}${searchQuery}">이전</a>
        </c:if>

        <c:forEach var="p" begin="${pageStartPage}" end="${pageEndPage}">
          <a class="page-link <c:if test='${p==currentPage}'>current</c:if>"
             href="?page=${p}&pageSize=${pageSizeValue}${searchQuery}">${p}</a>
        </c:forEach>

        <c:if test="${currentPage < pageTotalPages}">
          <a class="page-link" href="?page=${currentPage+1}&pageSize=${pageSizeValue}${searchQuery}">다음</a>
        </c:if>
      </div>
    </div>

  </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
