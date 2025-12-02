<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>학사 일정 캘린더</title>

    <!-- CSS -->
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/calendar.css">

    <!-- FullCalendar CSS & JS (CDN) -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js"></script>

    <style>
        .calendar-wrapper {
            padding: 24px 32px;
        }
        #calendar {
            max-width: 1100px;
            margin: 20px auto;
            background: #fff;
            border-radius: 8px;
            padding: 16px;
            box-sizing: border-box;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <!-- 왼쪽 사이드바 -->
    <nav class="sidebar">
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
    </nav>

    <!-- 메인 영역 -->
    <main class="content">
        <div class="calendar-wrapper">
            <h2>학사 일정 캘린더</h2>
            <p style="margin-top: 8px; color:#ccc;">
                개강, 종강, 시험기간, 휴강, 공휴일, 등록기간 등의 학사 일정을 한 눈에 확인할 수 있습니다.
            </p>

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
            locale: 'ko',    // 한국어
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,timeGridDay'
            },
            // 학사일정 JSON 가져오기
            events: '/api/calendar/events',
            
            // 디버깅
            eventDidMount: function(info) {
              console.log('event loaded:', info.event);
            },

            // 일정 클릭 시 상세 페이지로 이동
            eventClick: function (info) {
                // 백엔드에서 JSON에 id로 eventId를 내려준다고 가정
                const eventId = info.event.id;
                if (eventId) {
                    window.location.href = '/calendar/academic/' + eventId;
                }
            },

            height: 'auto'
        });

        calendar.render();
    });
</script>

</body>
</html>
