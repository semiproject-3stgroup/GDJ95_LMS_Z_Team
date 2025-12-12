<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>학사 일정 등록</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content admin-events-page">
	  <div class="page-header">
	    <h1 class="page-title">학사 일정 등록</h1>
	    <div class="page-header-actions">
	      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/events">목록으로</a>
	    </div>
	  </div>
	
	  <div class="box admin-form-card">
	    <form method="post" action="${pageContext.request.contextPath}/admin/events/add" class="form-grid">
	      <div class="form-row">
	        <label class="form-label">행사명</label>
	        <input class="form-input" type="text" name="eventName" required>
	      </div>
	
	      <div class="form-row two-col">
	        <div>
	          <label class="form-label">시작일시</label>
	          <input class="form-input" type="datetime-local" name="eventFromdate" required>
	        </div>
	        <div>
	          <label class="form-label">종료일시</label>
	          <input class="form-input" type="datetime-local" name="eventTodate" required>
	        </div>
	      </div>
	
	      <div class="form-row">
	        <label class="form-label">내용</label>
	        <textarea class="form-textarea" name="eventContext" rows="5" required></textarea>
	      </div>
	
	      <div class="form-actions">
	        <button class="btn btn-primary" type="submit">등록</button>
	        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/events">취소</a>
	      </div>
	    </form>
	  </div>
	</main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
