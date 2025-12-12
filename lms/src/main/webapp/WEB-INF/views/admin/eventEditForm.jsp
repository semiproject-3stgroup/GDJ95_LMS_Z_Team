<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>학사 일정 수정</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content admin-events-page">
	  <div class="page-header">
	    <h1 class="page-title">학사 일정 수정</h1>
	    <div class="page-header-actions">
	      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/events">목록으로</a>
	    </div>
	  </div>
	
	  <div class="box admin-form-card">
	    <form method="post" action="${pageContext.request.contextPath}/admin/events/edit" class="form-grid">
	      <input type="hidden" name="eventId" value="${event.eventId}">
	
	      <div class="form-row">
	        <label class="form-label">행사명</label>
	        <input class="form-input" type="text" name="eventName" value="${event.eventName}" required>
	      </div>
	
	      <div class="form-row two-col">
	        <div>
	          <label class="form-label">시작일시</label>
	          <input class="form-input" type="datetime-local" name="eventFromdate" value="${event.eventFromdate}" required>
	        </div>
	        <div>
	          <label class="form-label">종료일시</label>
	          <input class="form-input" type="datetime-local" name="eventTodate" value="${event.eventTodate}" required>
	        </div>
	      </div>
	
	      <div class="form-row">
	        <label class="form-label">내용</label>
	        <textarea class="form-textarea" name="eventContext" rows="5" required>${event.eventContext}</textarea>
	      </div>
	
	      <div class="form-actions">
	        <button class="btn btn-primary" type="submit">저장</button>
	        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/events">취소</a>
	      </div>
	    </form>
	  </div>
	</main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
