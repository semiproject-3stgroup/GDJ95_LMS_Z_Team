<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내 강의 일정 (교수)</title>

    <!-- 공통 CSS -->
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/calendar.css">

    <!-- FullCalendar: global 빌드 사용 -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
</head>

<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">

    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="content">
        <h2>내 강의 / 과제 일정 (교수)</h2>

        <!-- 필터 영역 -->
        <div class="mycal-toolbar">
            <label>
                과목
                <select id="filterCourse">
                    <option value="">전체 과목</option>
                    <c:forEach var="c" items="${courseList}">
                        <option value="${c.courseId}">
                            ${c.courseName}
                        </option>
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

            <label style="margin-left:16px;">
                <input type="checkbox" id="filterOnlyTodayAssignment">
                오늘 마감 과제만 보기
            </label>

            <!-- 색상 범례 -->
            <span class="mycal-legend">
                <span class="legend-dot legend-class"></span> 수업
                <span class="legend-dot legend-exam"></span> 시험
                <span class="legend-dot legend-assignment"></span> 과제
                <span class="legend-dot legend-etc"></span> 기타
            </span>
        </div>

        <!-- 캘린더 영역 -->
        <div id="myCalendar" style="margin-top:16px;"></div>
    </main>

</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log('### my_calendar_prof.jsp DOMContentLoaded');

    var calendarEl = document.getElementById('myCalendar');
    if (!calendarEl) {
        console.error('myCalendar element not found!');
        return;
    }

    var courseSelect = document.getElementById('filterCourse');
    var typeSelect = document.getElementById('filterType');
    var onlyTodayCheckbox = document.getElementById('filterOnlyTodayAssignment');

    var calendar = new FullCalendar.Calendar(calendarEl, {
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
            url: '/api/calendar/prof-events',
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

        eventClick: function(info) {
            var type = info.event.extendedProps.type;
            var eventId = info.event.id;
            var courseId = info.event.extendedProps.courseId;
            console.log('[prof] eventClick:', type, eventId, courseId);

            // 나중에 과제/수업/시험 상세 페이지 연결하고 싶으면 여기서 location.href로 분기하면 됨.
        },

        eventDidMount: function(info) {
            var courseName = info.event.extendedProps.courseName;
            var type = info.event.extendedProps.type;
            info.el.title = '[' + courseName + '] ' + info.event.title + ' (' + type + ')';
        }
    });

    calendar.render();

    // 필터 변경 시 이벤트 다시 로드
    [courseSelect, typeSelect, onlyTodayCheckbox].forEach(function(el) {
        el.addEventListener('change', function() {
            calendar.refetchEvents();
        });
    });
});
</script>

</body>
</html>
