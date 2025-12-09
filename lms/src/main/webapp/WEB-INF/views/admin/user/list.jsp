<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>관리자 &gt; 사용자 관리</title>
  <style>
    * { margin:0; padding:0; box-sizing:border-box; }
    body {
      font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      background:#f3f4f6;
      color:#111827;
    }
    .app { min-height:100vh; display:flex; flex-direction:column; }

    /* 상단바 */
    .topbar {
      height:60px;
      background:#111827;
      color:#f9fafb;
      display:flex;
      align-items:center;
      justify-content:space-between;
      padding:0 24px;
      box-shadow:0 2px 4px rgba(0,0,0,0.12);
    }
    .topbar-left { display:flex; align-items:center; gap:12px; }
    .logo {
      width:32px; height:32px;
      border-radius:8px;
      background:linear-gradient(135deg,#22c55e,#0ea5e9);
    }
    .topbar-title { font-size:18px; font-weight:600; }
    .topbar-right { display:flex; align-items:center; gap:16px; font-size:13px; }
    .avatar { width:32px; height:32px; border-radius:999px; background:#4b5563; }
    .logout-btn {
      padding:6px 12px;
      border-radius:6px;
      background:#dc2626;
      color:#fff;
      border:none;
      font-size:13px;
      cursor:pointer;
    }
    .logout-btn:hover { background:#b91c1c; }

    /* 레이아웃 */
    .layout { display:flex; flex:1; }

    .sidebar {
      width:220px;
      background:#111827;
      color:#9ca3af;
      padding:16px 12px;
      border-right:1px solid #1f2937;
      display:flex;
      flex-direction:column;
      gap:4px;
    }
    .sidebar-section-title{
      font-size:12px; text-transform:uppercase;
      color:#6b7280;
      margin:12px 8px 6px;
      letter-spacing:0.08em;
    }
    .nav-item{
      padding:8px 10px;
      border-radius:8px;
      font-size:14px;
      display:flex;
      align-items:center;
      gap:8px;
      cursor:pointer;
    }
    .nav-item.active{ 
      background:#16a34a; 
      color:#fff;
    }
    .nav-dot{
      width:6px; height:6px;
      border-radius:999px;
      background:#4b5563;
    }
    .nav-item.active .nav-dot{ background:#bbf7d0; }

    .content{
      flex:1;
      padding:24px 32px 32px;
      display:flex;
      flex-direction:column;
      gap:16px;
    }

    .footer{
      margin-top:24px;
      background:#111827;
      color:#e5e7eb;
      padding:18px 0;
      font-size:13px;
    }
    .footer-inner{
      max-width:1200px;
      margin:0 auto;
      display:flex;
      justify-content:space-around;
      flex-wrap:wrap;
      gap:10px;
    }
    .footer-item strong{ color:#f9fafb; }

    @media (max-width:1024px){
      .layout{ flex-direction:column; }
      .sidebar{ display:none; }
      .content{ padding:16px; }
    }

    /* 페이지 전용 */
    .breadcrumb{
      font-size:13px;
      color:#9ca3af;
    }
    .page-title-lg{
      font-size:20px;
      font-weight:600;
      margin-top:4px;
    }
    .page-subtitle{
      font-size:14px;
      margin-top:2px;
      color:#6b7280;
      margin-bottom: 10px; /* 검색 폼과의 간격 확보 */
    }
    .list-card{
      margin-top:5px;
      background:#fff;
      border-radius:12px;
      padding:16px 18px;
      box-shadow:0 1px 3px rgba(15,23,42,0.06);
    }
    .list-header{
      display:flex;
      justify-content:space-between;
      align-items:center;
      margin-bottom:10px;
      font-size:13px;
    }
    .filter-text{ color:#6b7280; }
    .filter-link{
      color:#16a34a;
      cursor:pointer;
      margin-left:4px;
    }
    .user-table{
      width:100%;
      border-collapse:collapse;
      font-size:12px;
    }
    .user-table th,
    .user-table td{
      border:1px solid #e5e7eb;
      padding:7px 8px;
      text-align:center;
      white-space:nowrap;
    }
    .user-table th{
      background:#f9fafb;
      font-weight:500;
    }
    .status-chip{
      display:inline-block;
      padding:3px 8px;
      border-radius:999px;
      font-size:11px;
      background:#dcfce7;
      color:#166534;
    }
    .status-chip.inactive{
      background:#fee2e2;
      color:#b91c1c;
    }
    .btn-xs{
      padding:4px 8px;
      font-size:11px;
      border-radius:4px;
      border:1px solid #d1d5db;
      background:#fff;
      cursor:pointer;
    }
    .btn-xs:hover{ background:#f3f4f6; }

    .table-footer{
      display:flex;
      justify-content: space-between;
      align-items:center;
      margin-top:20px;
      font-size:12px;
      color:#6b7280;
    }
    .pagination{
      display: inline-flex;
      gap:4px;
      align-items:center;
    }
    .page-btn{
      min-width:22px;
      height:22px;
      border-radius:4px;
      border:1px solid #e5e7eb;
      font-size:11px;
      background:#fff;
      cursor:pointer;
    }
    .page-btn.active{
      background:#f97316;
      border-color:#f97316;
      color:#fff;
    }
  </style>
</head>
<body>
<div class="app">
  <header class="topbar">
    <div class="topbar-left">
      <div class="logo"></div>
      <div class="topbar-title">LMS 학사관리 시스템</div>
    </div>
    <div class="topbar-right">
      <div class="avatar"></div>
      <%-- 사용자 정보를 세션 등에서 가져와서 표시 --%>
      <div>
        <div style="font-size:13px;">관리자 홍길동님 반갑습니다</div>
        <div style="font-size:11px; color:#9ca3af;">시스템 관리자</div>
      </div>
      <button class="logout-btn" onclick="location.href='/logout'">로그아웃</button>
    </div>
  </header>

  <div class="layout">
    <aside class="sidebar">
      <div class="sidebar-section-title">대시보드</div>
      <a href="${pageContext.request.contextPath}/home" class="nav-item" style="text-decoration:none; color:inherit;">
	        <div class="nav-dot"></div>대시보드
	  </a>
    
      <div class="sidebar-section-title">관리자</div>
      <a href="${pageContext.request.contextPath}/admin/user/list" class="nav-item active" style="text-decoration:none; color:inherit;">
	        <div class="nav-dot"></div>사용자 관리
	  </a>
      <div class="nav-item"><div class="nav-dot"></div>게시판 관리</div>
      <div class="nav-item"><div class="nav-dot"></div>강의 관리</div>
      <div class="nav-item"><div class="nav-dot"></div>통계</div>
      <div style="margin-top:auto; padding:10px; font-size:12px; color:#9ca3af;">◀ Log Out</div>
    </aside>

    <main class="content">
      <div class="breadcrumb">관리자 &gt; 사용자 관리</div>
      <h1 class="page-title-lg">사용자 관리</h1>
      <p class="page-subtitle">학사시스템에 등록된 사용자 계정을 조회·관리합니다.</p>
      
      <%-- totalCount가 null 또는 0일 때, EL 오류를 방지하기 위해 0으로 기본값 설정 --%>
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

      <form action="/admin/user/list" method="get" class="search-form" style="display: flex; gap: 8px; align-items: center;">
          <input type="hidden" name="page" value="1"> 
          <input type="hidden" name="pageSize" value="${pageSizeValue}">

          <select name="searchType" style="padding: 6px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 13px;">
              <option value="userName" <c:if test="${param.searchType == 'userName'}">selected</c:if>>이름</option>
              <option value="loginId" <c:if test="${param.searchType == 'loginId'}">selected</c:if>>ID</option>
              <option value="role" <c:if test="${param.searchType == 'role'}">selected</c:if>>역할</option>
              <option value="departmentName" <c:if test="${param.searchType == 'departmentName'}">selected</c:if>>학과</option>
          </select>

          <input type="text" name="searchKeyword" 
                 value="${param.searchKeyword}" 
                 placeholder="검색어를 입력하세요" 
                 style="padding: 6px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 13px; flex-grow: 1; max-width: 300px;">

          <button type="submit" style="padding: 6px 12px; border: none; border-radius: 6px; background: #16a34a; color: #fff; font-size: 13px; cursor: pointer;">검색</button>
          
          <c:if test="${not empty param.searchKeyword}">
            <button type="button" onclick="location.href='/admin/user/list?pageSize=${pageSizeValue}'" style="padding: 6px 12px; border: 1px solid #d1d5db; border-radius: 6px; background: #fff; font-size: 13px; cursor: pointer;">초기화</button>
          </c:if>
      </form>

      <section class="list-card">
        <div class="list-header">
          <%-- 수정된 변수 사용 --%>
          <div style="font-weight:500;">사용자 목록 (${userTotalCount}건)</div>
          <div class="filter-text">
            Filter by
            <span class="filter-link">Role</span> |
            <span class="filter-link">Status</span>
          </div>
        </div>

        <table class="user-table">
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
          <%-- userList 반복 처리 --%>
          <c:forEach var="user" items="${userList}" varStatus="status">
          <tr>
            <%-- No 계산: 전체 수 - ((현재 페이지 - 1) * 페이지 크기 + 현재 인덱스) --%>
            <td>${userTotalCount - ((currentPage - 1) * pageSizeValue + status.index)}</td>
            <td>${user.userName}</td>
            <td>${user.loginId}</td>
            <td>${user.role}</td>
            <%-- departmentName이 없는 경우 '-' 표시 --%>
            <td>${user.departmentName != null ? user.departmentName : '-'}</td>
            <td>${user.email}</td>
            <td>
              <c:choose>
                <%-- users 테이블의 status 컬럼에 'ACTIVE' 값이 저장되어 있다고 가정 --%>
                <c:when test="${user.status eq 'ACTIVE'}">
                  <span class="status-chip">활성</span>
                </c:when>
                <c:otherwise>
                  <span class="status-chip inactive">비활성</span>
                </c:otherwise>
              </c:choose>
            </td>
            <%-- createdate는 DB에서 java.util.Date로 넘어옴 --%>
            <td><fmt:formatDate value="${user.createdate}" pattern="yyyy-MM-dd"/></td>
          </tr>
          </c:forEach>
          <%-- 사용자 목록이 비어있는 경우 --%>
          <c:if test="${empty userList}">
            <tr>
              <td colspan="9">등록된 사용자 정보가 없습니다.</td>
            </tr>
          </c:if>
          </tbody>
        </table>

        <div class="table-footer">
          <%-- 1. 좌측 정렬 요소: 'Show X rows' --%>
          <div style="min-width: 130px;">
            Show
            <select style="font-size:12px; padding:2px 4px; border-radius:4px; border:1px solid #d1d5db;"
                    onchange="location.href='?page=1&pageSize='+this.value + '${searchQuery}'">
              <option value="10" <c:if test="${pageSizeValue == 10}">selected</c:if>>10</option>
              <option value="20" <c:if test="${pageSizeValue == 20}">selected</c:if>>20</option>
              <option value="50" <c:if test="${pageSizeValue == 50}">selected</c:if>>50</option>
            </select> rows
          </div>
          
          <%-- 2. 중앙 정렬 래퍼: flex-grow로 남은 공간을 채우고 text-align: center로 자식 요소를 중앙에 배치 --%>
          <div style="flex-grow: 1; text-align: center;">
            <div class="pagination">
              <%-- << (맨 처음 페이지) --%>
              <c:if test="${pageStartPage > 1}">
                <button class="page-btn" onclick="location.href='?page=1&pageSize=${pageSizeValue}${searchQuery}'">&laquo;</button>
              </c:if>
              <%-- < (이전 블록) --%>
              <c:if test="${currentPage > 1}">
                <button class="page-btn" onclick="location.href='?page=${currentPage - 1}&pageSize=${pageSizeValue}${searchQuery}'">&lsaquo;</button>
              </c:if>

              <%-- 페이지 번호 목록 --%>
              <c:forEach var="pageNum" begin="${pageStartPage}" end="${pageEndPage}">
                <button class="page-btn <c:if test="${pageNum == currentPage}">active</c:if>"
                        onclick="location.href='?page=${pageNum}&pageSize=${pageSizeValue}${searchQuery}'">${pageNum}</button>
              </c:forEach>

              <%-- > (다음 블록) --%>
              <c:if test="${currentPage < pageTotalPages}">
                <button class="page-btn" onclick="location.href='?page=${currentPage + 1}&pageSize=${pageSizeValue}${searchQuery}'">&rsaquo;</button>
              </c:if>
              <%-- >> (맨 끝 페이지) --%>
              <c:if test="${pageEndPage < pageTotalPages}">
                <button class="page-btn" onclick="location.href='?page=${pageTotalPages}&pageSize=${pageSizeValue}${searchQuery}'">&raquo;</button>
              </c:if>
            </div>
          </div>
          
          <%-- 3. 우측 빈 요소: 좌측 요소의 공간을 상쇄하여 중앙 정렬의 균형을 맞춤 --%>
          <div style="min-width: 130px;"></div>
        </div>
      </section>
    </main>
  </div>

  <footer class="footer">
    <div class="footer-inner">
      <div class="footer-item"><strong>문의:</strong> 학사관리운영팀</div>
      <div class="footer-item"><strong>전화:</strong> 02-1234-5678</div>
      <div class="footer-item"><strong>Email:</strong> lms@university.ac.kr</div>
      <div class="footer-item"><strong>주소:</strong> 서울특별시 OO구 OO로 123, OO대학교</div>
    </div>
  </footer>
</div>
</body>
</html>