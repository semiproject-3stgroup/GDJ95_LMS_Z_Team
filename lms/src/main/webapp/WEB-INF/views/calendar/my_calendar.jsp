<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>내 강의 / 과제 일정</title>

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
        <h1 class="page-title">내 강의 / 과제 일정</h1>
        <p class="page-subtitle">수업/시험/과제 + 학사 일정을 한 번에 확인할 수 있습니다.</p>
      </div>
    </div>

    <div class="box calendar-card">
      <div class="calendar-filters">
        <select id="courseFilter">
          <option value="ALL">전체 과목</option>
        </select>

        <select id="typeFilter">
          <option value="ALL">전체 일정</option>
          <option value="CLASS">수업</option>
          <option value="EXAM">시험</option>
          <option value="ASSIGNMENT">과제</option>
          <option value="SCHOOL">학사 일정</option>
        </select>

        <label>
          <input type="checkbox" id="onlyTodayDue">
          오늘 마감 과제만 보기
        </label>

        <span class="legend legend-class">수업</span>
        <span class="legend legend-exam">시험</span>
        <span class="legend legend-assignment">과제</span>
        <span class="legend legend-school">학사</span>
      </div>

      <div id="calendar"></div>
    </div>
  </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const calendarEl = document.getElementById('calendar');

  function slotLabelWithPeriod(arg) {
    const date = arg.date;
    const hour = date.getHours();
    const baseText = arg.text;

    let period = null;
    if (hour === 9) period = '1교시';
    else if (hour === 10) period = '2교시';
    else if (hour === 11) period = '3교시';
    else if (hour === 13) period = '4교시';
    else if (hour === 14) period = '5교시';
    else if (hour === 15) period = '6교시';
    else if (hour === 16) period = '7교시';
    else if (hour === 17) period = '8교시';

    if (!period) return { text: baseText };
    return { html: baseText + '<br/><span class="fc-period">(' + period + ')</span>' };
  }

  let selectedCourseId = 'ALL';
  let selectedType = 'ALL';
  let onlyTodayDue = false;

  const todayStr = new Date().toISOString().slice(0, 10);

  const courseFilterEl = document.getElementById('courseFilter');
  const typeFilterEl = document.getElementById('typeFilter');
  const onlyTodayEl = document.getElementById('onlyTodayDue');

  const calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: 'dayGridMonth',
    locale: 'ko',
    height: 'auto',
    nowIndicator: true,

    headerToolbar: {
      left: 'prev,next today',
      center: 'title',
      right: 'dayGridMonth,timeGridWeek,timeGridDay'
    },

    // week/day 보기 깔끔하게 
    slotMinTime: '08:00:00',
    slotMaxTime: '20:00:00',
    slotDuration: '00:30:00',
    allDaySlot: true,

    // timeGrid 라벨 (교시)
    slotLabelContent: slotLabelWithPeriod,

    // month에서 이벤트 너무 많으면 “+n개” 처리
    dayMaxEventRows: 4,

    events: function(info, successCallback, failureCallback) {
      const params = new URLSearchParams({
        start: info.startStr || info.start.toISOString(),
        end: info.endStr || info.end.toISOString()
      });

      fetch('${pageContext.request.contextPath}/api/calendar/my-events?' + params.toString())
        .then(res => res.json())
        .then(data => {
          const filtered = data.filter(e => {
            if (selectedCourseId !== 'ALL') {
              if (!e.courseId || String(e.courseId) !== selectedCourseId) return false;
            }
            if (selectedType !== 'ALL') {
              if (e.type !== selectedType) return false;
            }
            if (onlyTodayDue) {
              if (e.type !== 'ASSIGNMENT') return false;
              const endDateStr = (e.end || e.start).slice(0, 10);
              if (endDateStr !== todayStr) return false;
            }
            return true;
          });

          const events = filtered.map(e => {
            // ✅ 학사(SCHOOL) / 날짜-only 이벤트는 allDay로 올려버리기
            const startStr = (e.start || '');
            const endStr = (e.end || '');
            const hasTime = startStr.includes('T'); // "2025-12-12T10:00:00" 형태면 true
            const isAllDay = (e.type === 'SCHOOL') || !hasTime;

            return {
              id: e.eventId,
              title: (e.courseName ? e.courseName + ' | ' : '') + e.title,
              start: e.start,
              end: e.end,
              allDay: isAllDay, // ✅ 여기 핵심 (기존 allDay:false 삭제)
              backgroundColor: e.backgroundColor,
              borderColor: e.backgroundColor,
              extendedProps: {
                type: e.type,
                courseId: e.courseId,
                courseName: e.courseName
              }
            };
          });

          successCallback(events);
        })
        .catch(err => {
          console.error('캘린더 이벤트 조회 실패', err);
          if (failureCallback) failureCallback(err);
        });
    },

    eventClick: function(info) {
      const type = info.event.extendedProps.type;
      const eventId = info.event.id;

      if (type === 'SCHOOL') {
        window.location.href = '${pageContext.request.contextPath}/calendar/academic/' + eventId;
      }
    }
  });

  calendar.render();

  courseFilterEl.addEventListener('change', function() {
    selectedCourseId = this.value;
    calendar.refetchEvents();
  });

  typeFilterEl.addEventListener('change', function() {
    selectedType = this.value;
    calendar.refetchEvents();
  });

  onlyTodayEl.addEventListener('change', function() {
    onlyTodayDue = this.checked;
    calendar.refetchEvents();
  });
});
</script>

</body>
</html>
