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
                <option value="SCHOOL">학사 일정</option> <!-- ✅ 추가 -->
            </select>

            <label>
                <input type="checkbox" id="onlyTodayDue">
                오늘 마감 과제만 보기
            </label>

            <!-- 색상 범례 -->
            <span class="legend legend-class">수업</span>
            <span class="legend legend-exam">시험</span>
            <span class="legend legend-assignment">과제</span>
            <span class="legend legend-school">학사</span> <!-- ✅ 추가 -->
        </div>

        <div id="calendar"></div>

        <script>
        document.addEventListener('DOMContentLoaded', function() {
            const calendarEl = document.getElementById('calendar');

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

                // 서버에서 내 일정 + 학사일정 한 번에 받아오기
                events: function(info, successCallback, failureCallback) {

                    // start / end 파라미터를 확실하게 붙여서 보냄
                    const params = new URLSearchParams({
                        start: info.startStr || info.start.toISOString(),
                        end:   info.endStr   || info.end.toISOString()
                    });

                    const url = '/api/calendar/my-events?' + params.toString();
                    console.log('load events url = ', url); // 디버깅용

                    fetch(url)
                        .then(res => res.json())
                        .then(data => {

                            // 백엔드 MyCalendarEvent DTO 기준:
                            // eventId, courseId, courseName, title, start, end, type, backgroundColor

                            const filtered = data.filter(e => {

                                // 1) 과목 필터 (courseId 기준)
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

                            // FullCalendar 이벤트 객체로 변환
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
                        // 학사 일정 상세 페이지로 이동
                        window.location.href = `/calendar/academic/${eventId}`;
                        return;
                    }

                    // 그 외(수업/시험/과제)는 기존 로직 유지
                    // openMyEventModal(info.event);  // 있으면 여기 호출
                }
            });

            calendar.render();
        });
        </script>

    </main>
</div>

</body>
</html>
