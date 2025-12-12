<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>학사 일정 상세</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/calendar.css">
</head>

<body class="calendar-page">
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
  <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

  <main class="main-content">
    <div class="page-header">
      <div>
        <h1 class="page-title">학사 일정 상세</h1>
        <p class="page-subtitle">선택한 학사 일정의 상세 정보를 확인해.</p>
      </div>
    </div>

    <div class="box">
      <table class="table" style="margin-top: 6px;">
        <tr>
          <th style="width:140px;">행사명</th>
          <td>${event.eventName}</td>
        </tr>
        <tr>
          <th>시작일시</th>
          <td>${event.eventFromdate}</td>
        </tr>
        <tr>
          <th>종료일시</th>
          <td>${event.eventTodate}</td>
        </tr>
        <tr>
          <th>내용</th>
          <td style="white-space:pre-line;">${event.eventContext}</td>
        </tr>
      </table>

      <div style="margin-top:14px;">
        <a class="btn" href="${pageContext.request.contextPath}/calendar/academic">목록으로</a>
      </div>
    </div>
  </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
