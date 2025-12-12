<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>내 강의 / 과제 일정 (교수)</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/calendar.css">

  <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.css" rel="stylesheet" />
  <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
</head>

<body class="calendar-page">
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
  <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

  <main class="main-content">
    <div class="page-header">
      <div>
        <h1 class="page-title">내 강의 / 과제 일정 (교수)</h1>
        <p class="page-subtitle">과목/유형 필터로 일정을 볼 수 있습니다.</p>
      </div>
    </div>

    <div class="box calendar-card">
      <div class="mycal-toolbar">
        <label>
          과목
          <select id="filterCourse">
            <option value="">전체 과목</option>
            <c:forEach var="c" items="${courseList}">
              <option value="${c.courseId}">${c.courseName}</option>
            </c:forEach>
          </select>
        </label>

        <label>
          유형
          <select id="filterType">
            <option value="">전체 일정</option>
            <option value="CLASS">수업</option>
            <option value="EXAM">시험</option>
            <option value="ASSIGNMENT">과제</option>
            <option value="ETC">기타</option>
          </select>
        </label>

        <label style="margin-left: 6px;">
          <input type="checkbox" id="filterOnlyTodayAssignment">
          오늘 마감 과제만 보기
        </label>

        <span class="mycal-legend">
          <span><span class="legend-dot legend-class"></span>수업</span>
          <span><span class="legend-dot legend-exam"></span>시험</span>
          <span><span class="legend-dot legend-assignment"></span>과제</span>
          <span><span class="legend-dot legend-etc"></span>기타</span>
        </span>
      </div>

      <div id="myCalendar"></div>
    </div>
  </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const calendarEl = document.getElementById('myCalendar');
  const courseSelect = document.getElementById('filterCourse');
  const typeSelect = document.getElementById('filterType');
  const onlyTodayCheckbox = document.getElementById('filterOnlyTodayAssignment');

  const calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: 'dayGridMonth',
    locale: 'ko',
    height: 'auto',
    headerToolbar: {
      left: 'prev,next today',
      center: 'title',
      right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
    },
    navLinks: true,
    nowIndicator: true,

    eventSources: [{
      url: '${pageContext.request.contextPath}/api/calendar/prof-events',
      method: 'GET',
      extraParams: function() {
        return {
          courseId: courseSelect.value || '',
          type: typeSelect.value || '',
          onlyTodayAssignment: onlyTodayCheckbox.checked
        };
      },
      failure: function() {
        alert('일정을 불러오지 못했습니다.');
      }
    }],

    eventDidMount: function(info) {
      const courseName = info.event.extendedProps.courseName;
      const type = info.event.extendedProps.type;
      info.el.title = '[' + courseName + '] ' + info.event.title + ' (' + type + ')';
    }
  });

  calendar.render();

  [courseSelect, typeSelect, onlyTodayCheckbox].forEach(function(el) {
    el.addEventListener('change', function() {
      calendar.refetchEvents();
    });
  });
});
</script>

</body>
</html>
