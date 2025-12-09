<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내 강의 / 과제 일정</title>

    <!-- 공통 CSS -->
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/calendar.css">

    <!-- FullCalendar: global 빌드 -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">

    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="content">
        <h2>내 강의 / 과제 일정</h2>

        <!-- 상단 필터 영역 -->
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

            <!-- 색상 범례 -->
            <span class="legend legend-class">수업</span>
            <span class="legend legend-exam">시험</span>
            <span class="legend legend-assignment">과제</span>
            <span class="legend legend-school">학사</span>
        </div>

        <div id="calendar"></div>

        <script>
        document.addEventListener('DOMContentLoaded', function() {
            const calendarEl = document.getElementById('calendar');

            // ===== 시간축 라벨(시간 + 교시) =====
            function slotLabelWithPeriod(arg) {
                const date = arg.date;
                const hour = date.getHours();
                const baseText = arg.text; // 예: "오전 9시"

                let period = null;

                if (hour === 9)  period = '1교시';
                else if (hour === 10) period = '2교시';
                else if (hour === 11) period = '3교시';
                else if (hour === 13) period = '4교시';
                else if (hour === 14) period = '5교시';
                else if (hour === 15) period = '6교시';
                else if (hour === 16) period = '7교시';
                else if (hour === 17) period = '8교시';

                if (!period) {
                    return { text: baseText };
                }

                return {
                    html: baseText + '<br/><span style="font-size:11px; color:#6b7280;">(' + period + ')</span>'
                };
            }

            // ===== 필터 상태 전역 변수 =====
            let selectedCourseId = 'ALL';
            let selectedType = 'ALL';
            let onlyTodayDue = false;

            const todayStr = new Date().toISOString().slice(0, 10);

            // 필터 DOM 요소
            const courseFilterEl = document.getElementById('courseFilter');
            const typeFilterEl   = document.getElementById('typeFilter');
            const onlyTodayEl    = document.getElementById('onlyTodayDue');

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

            // ===== FullCalendar 초기화 =====
            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                locale: 'ko',
                height: 'auto',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },

                // 시간축 커스터마이징 (timeGrid* 뷰에서 사용됨)
                slotLabelContent: slotLabelWithPeriod,

                // 서버에서 내 일정 + 학사일정 한 번에 받아오기
                events: function(info, successCallback, failureCallback) {

                    const params = new URLSearchParams({
                        start: info.startStr || info.start.toISOString(),
                        end:   info.endStr   || info.end.toISOString()
                    });

                    const url = '/api/calendar/my-events?' + params.toString();
                    console.log('load events url = ', url);

                    fetch(url)
                        .then(res => res.json())
                        .then(data => {

                            // MyCalendarEvent DTO:
                            // eventId, courseId, courseName, title, start, end, type, backgroundColor

                            const filtered = data.filter(e => {

                                // 1) 과목 필터
                                if (selectedCourseId !== 'ALL') {
                                    if (!e.courseId || String(e.courseId) !== selectedCourseId) {
                                        return false;
                                    }
                                }

                                // 2) 일정 유형 필터
                                if (selectedType !== 'ALL') {
                                    if (e.type !== selectedType) {
                                        return false;
                                    }
                                }

                                // 3) 오늘 마감 과제만 보기
                                if (onlyTodayDue) {
                                    if (e.type !== 'ASSIGNMENT') return false;

                                    const endDateStr = (e.end || e.start).slice(0, 10); // yyyy-MM-dd
                                    if (endDateStr !== todayStr) return false;
                                }

                                return true;
                            });

                            const events = filtered.map(e => ({
                                id: e.eventId,
                                title: (e.courseName ? e.courseName + ' | ' : '') + e.title,
                                start: e.start,
                                end:   e.end,
                                backgroundColor: e.backgroundColor,
                                borderColor: e.backgroundColor,
                                allDay: false,
                                extendedProps: {
                                    type: e.type,
                                    courseId: e.courseId
                                }
                            }));

                            successCallback(events);
                        })
                        .catch(err => {
                            console.error('캘린더 이벤트 조회 실패', err);
                            if (failureCallback) failureCallback(err);
                        });
                },

                // 클릭 시 동작 (학사 일정이면 학사 상세 페이지로 이동)
                eventClick: function(info) {
                    const type = info.event.extendedProps.type;
                    const eventId = info.event.id;

                    if (type === 'SCHOOL') {
                        window.location.href = `/calendar/academic/${eventId}`;
                        return;
                    }

                    // 나머지 타입은 필요하면 모달 등으로 처리
                    // openMyEventModal(info.event);
                }
            });

            calendar.render();
        });
        </script>

    </main>
</div>

</body>
</html>
