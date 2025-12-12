<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>학사 일정 관리</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content admin-events-page">
	  <div class="page-header">
	    <h1 class="page-title">학사 일정 관리</h1>
	
	    <div class="page-header-actions">
	      <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/events/add">+ 새 일정 등록</a>
	    </div>
	  </div>
	
	  <div class="box">
	    <table class="table admin-events-table">
	      <thead>
	        <tr>
	          <th>행사명</th>
	          <th>시작일시</th>
	          <th>종료일시</th>
	          <th class="table-cell-center">관리</th>
	        </tr>
	      </thead>
	      <tbody>
	        <c:forEach var="e" items="${eventList}">
	          <tr>
	            <td class="admin-event-name">${e.eventName}</td>
	            <td class="admin-event-dt">${e.eventFromdate}</td>
	            <td class="admin-event-dt">${e.eventTodate}</td>
	            <td class="table-cell-center">
	              <div class="admin-row-actions">
	                <a class="btn btn-secondary btn-sm"
	                   href="${pageContext.request.contextPath}/admin/events/edit?eventId=${e.eventId}">수정</a>
	
	                <form action="${pageContext.request.contextPath}/admin/events/delete"
	                      method="post" class="inline-form">
	                  <input type="hidden" name="eventId" value="${e.eventId}">
	                  <button type="submit" class="btn btn-danger btn-sm"
	                          onclick="return confirm('삭제할까요?');">삭제</button>
	                </form>
	              </div>
	            </td>
	          </tr>
	        </c:forEach>
	
	        <c:if test="${empty eventList}">
	          <tr>
	            <td colspan="4" class="table-empty">등록된 일정이 없습니다.</td>
	          </tr>
	        </c:if>
	      </tbody>
	    </table>
	  </div>
	</main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
