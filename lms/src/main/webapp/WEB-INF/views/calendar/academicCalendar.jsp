<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>학사 일정 캘린더</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/calendar.css">

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.css" />
  <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js"></script>
</head>

<body class="calendar-page">
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
  <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

  <main class="main-content">
    <div class="page-header">
      <div>
        <h1 class="page-title">학사 일정 캘린더</h1>
        <p class="page-subtitle">개강, 종강, 시험기간, 휴강, 공휴일, 등록기간 등의 학사 일정을 한 눈에 확인할 수 있어.</p>
      </div>
    </div>

    <div class="box calendar-card">
      <div id="calendar"></div>
    </div>
  </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
document.addEventListener('DOMContentLoaded', function () {
  const calendarEl = document.getElementById('calendar');

  const calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: 'dayGridMonth',
    locale: 'ko',
    height: 'auto',
    headerToolbar: {
      left: 'prev,next today',
      center: 'title',
      right: 'dayGridMonth,timeGridWeek,timeGridDay'
    },
    events: '${pageContext.request.contextPath}/api/calendar/events',

    eventClick: function (info) {
      const eventId = info.event.id;
      if (eventId) {
        window.location.href = '${pageContext.request.contextPath}/calendar/academic/' + eventId;
      }
    }
  });

  calendar.render();
});
</script>

</body>
</html>
