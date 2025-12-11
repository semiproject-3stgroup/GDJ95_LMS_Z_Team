<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- JSTL fmt 태그 라이브러리를 사용하지 않으므로 제거하거나, 사용하더라도 날짜 출력에는 사용하지 않습니다. --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>LMS &gt; 질문 게시판</title>
  
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
      <%-- 로그인한 사용자 정보 표시 --%>
      <c:if test="${not empty sessionScope.loginUser}">
        <div>
          <div style="font-size:13px;">${sessionScope.loginUser.userName}님 반갑습니다</div>
          <div style="font-size:11px;color:#9ca3af;">${sessionScope.loginUser.role}</div>
        </div>
      </c:if>
      <a href="${pageContext.request.contextPath}/logout" class="logout-btn" style="text-decoration:none;">로그아웃</a>
    </div>
  </header>

  <div class="layout">

    <aside class="sidebar">
    	<div class="sidebar-section-title">대시보드</div>
	      <a href="${pageContext.request.contextPath}/home" class="nav-item" style="text-decoration:none; color:inherit;">
	        <div class="nav-dot"></div>대시보드
	      </a>
    
      <div class="sidebar-section-title">내 강의</div>
      <%-- 수강 중인 강의 목록 동적 표시 --%>
      <c:forEach var="course" items="${myCourses}">
        <a href="${pageContext.request.contextPath}/qna/list/${course.courseId}"
           class="nav-item <c:if test="${course.courseId == courseId}">active</c:if>" style="text-decoration:none; color:inherit;">
          <div class="nav-dot"></div>
          <span>${course.courseName}</span>
        </a>
      </c:forEach>
      <c:if test="${empty myCourses}">
        <div class="nav-item" style="cursor: default;">
           <div class="nav-dot"></div>수강 중인 강의가 없습니다.
        </div>
      </c:if>

      <div class="sidebar-section-title">강의 메뉴</div>
      <a href="${pageContext.request.contextPath}/assignment/list/${courseId}" class="nav-item" style="text-decoration:none; color:inherit;">
        <div class="nav-dot"></div>과제
      </a>
      <a href="${pageContext.request.contextPath}/exam/list/${courseId}" class="nav-item" style="text-decoration:none; color:inherit;">
        <div class="nav-dot"></div>시험/성적
      </a>
      <a href="${pageContext.request.contextPath}/qna/list/${courseId}" class="nav-item active" style="text-decoration:none; color:inherit;">
        <div class="nav-dot"></div>질문 게시판
      </a>

      <a
      href="${pageContext.request.contextPath}/logout"
         style="margin-top:auto;padding:10px;font-size:12px;color:#9ca3af;text-decoration:none;">
        ◀ Log Out
      </a>
    </aside>

    <main class="content">
      <div class="breadcrumb">
        ${currentCourseName} &gt; 질문 게시판
      </div>
      <h1 class="page-title-lg">질문 게시판</h1>
      <p class="page-subtitle">강의와 관련된 질문 게시글을 확인하고 작성할 수 있습니다.</p>

      <section class="list-card">
        <div class="list-header">
          <%-- 검색 폼 구현: GET 요청으로 searchKeyword를 Controller로 전달 --%>
          <form class="search-form" action="${pageContext.request.contextPath}/qna/list/${courseId}" method="get" style="display:flex; gap:8px;">
            <input type="text" name="searchKeyword" class="search-input"
                   placeholder="검색어를 입력하세요" value="${searchKeyword}"
                   style="padding:6px 10px;border-radius:4px;border:1px solid #d1d5db;font-size:12px;">
            <button type="submit" class="btn-sm">검색</button>
          </form>
          <div class="btn-row">
			   <a href="${pageContext.request.contextPath}/qna/writeForm/${courseId}" class="btn-sm btn-primary">글쓰기</a>
		</div>
        </div>

        <table class="board-table">
          <thead>
            <tr>
              <th style="width: 8%;">번호</th>
              <th style="width: auto;">제목</th>
              <th style="width: 15%;">작성자</th>
              <th style="width: 15%;">작성일</th>
              <th style="width: 10%;">조회수</th>
            </tr>
          </thead>
          <tbody>
          <c:forEach var="qna" items="${qnaList}">
			    <tr>
			        <td>${qna.postId}</td>
			        <td>
			            <a href="${pageContext.request.contextPath}/qna/one/${courseId}/${qna.postId}" style="text-decoration: none; color: inherit;">
			                ${qna.title}
			            </a>
			            <c:if test="${qna.commentCount > 0}">
			                [${qna.commentCount}]
			            </c:if>
			        </td>
			        <td>${qna.userName}</td>
			        <td>${qna.formattedCreatedate}</td>
			        <td>${qna.hitCount}</td>
			    </tr>
			</c:forEach>
          <%-- 게시글이 없는 경우 --%>
          <c:if test="${empty qnaList}">
            <tr>
              <td colspan="5" style="text-align: center;">등록된 게시글이 없습니다.</td>
            </tr>
          </c:if>
          </tbody>
        </table>

        <div class="pagination">
          <c:set var="basePath" value="${pageContext.request.contextPath}/qna/list/${currentCourseId}" />
          <c:set var="searchQuery" value="${not empty searchKeyword ? '&searchKeyword=' : ''}" />
          <c:set var="searchQuery" value="${searchQuery}${searchKeyword}" />

          <c:choose>
              <c:when test="${currentPage > 1}">
                  <a href="${basePath}?page=1${searchQuery}" class="page-btn">&laquo;</a>
              </c:when>
              <c:otherwise>
                  <button class="page-btn" disabled>&laquo;</button>
              </c:otherwise>
          </c:choose>

          <c:choose>
              <c:when test="${startPage > 1}">
                  <a href="${basePath}?page=${startPage - 1}${searchQuery}" class="page-btn">&lsaquo;</a>
              </c:when>
              <c:otherwise>
                  <button class="page-btn" disabled>&lsaquo;</button>
              </c:otherwise>
          </c:choose>

          <c:forEach begin="${startPage}" end="${endPage}" var="p">
              <c:choose>
                  <c:when test="${p eq currentPage}">
                      <button class="page-btn active">${p}</button>
                  </c:when>
                  <c:otherwise>
                      <a href="${basePath}?page=${p}${searchQuery}" class="page-btn">${p}</a>
                  </c:otherwise>
              </c:choose>
          </c:forEach>

          <c:choose>
              <c:when test="${endPage < totalPages}">
                  <a href="${basePath}?page=${endPage + 1}${searchQuery}" class="page-btn">&rsaquo;</a>
              </c:when>
              <c:otherwise>
                  <button class="page-btn" disabled>&rsaquo;</button>
              </c:otherwise>
          </c:choose>

          <c:choose>
              <c:when test="${currentPage < totalPages}">
                  <a href="${basePath}?page=${totalPages}${searchQuery}" class="page-btn">&raquo;</a>
              </c:when>
              <c:otherwise>
                  <button class="page-btn" disabled>&raquo;</button>
              </c:otherwise>
          </c:choose>
        </div>
        </section>
    </main>
  </div>

  <footer class="footer">
    <div class="footer-inner">
      <div class="footer-item"><strong>문의:</strong> 학사관리운영팀</div>
      <div class="footer-item"><strong>이메일:</strong> lms@university.ac.kr</div>
      <div class="footer-item"><strong>전화:</strong> 02-1234-5678</div>
    </div>
  </footer>
</div>
</body>
</html>
