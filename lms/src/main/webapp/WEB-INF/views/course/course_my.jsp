<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내 수강목록</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/calendar.css">

    <!-- FullCalendar: global 빌드 -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>

    <!-- 이 페이지용 간단 레이아웃 -->
    <style>
        .mycourse-layout {
            display: flex;
            gap: 24px;
            align-items: flex-start;
        }
        .mycourse-left {
            flex: 1 1 auto;
            min-width: 0;
        }
        .mycourse-right {
            flex: 0 0 520px;
        }
        #myCourseWeeklyCalendar {
            margin-top: 8px;
            background-color: #ffffff;
            border-radius: 10px;
            padding: 12px;
            box-shadow: 0 2px 4px rgba(15, 23, 42, 0.08);
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">

    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">
        <h2 class="page-title">내 수강목록</h2>

        <!-- 수강취소 기간 / 수동 상태 안내 배너 -->
        <c:if test="${not empty cancelBannerText}">
            <div class="alert
                <c:choose>
                    <c:when test="${cancelBannerType == 'error'}"> alert-error</c:when>
                    <c:when test="${cancelBannerType == 'success'}"> alert-success</c:when>
                    <c:otherwise> alert-info</c:otherwise>
                </c:choose>
            ">
                ${cancelBannerText}
            </div>
        </c:if>

        <!-- 메시지 영역 -->
        <c:if test="${not empty message}">
            <div class="alert
                <c:choose>
                    <c:when test="${messageType == 'error'}"> alert-error</c:when>
                    <c:when test="${messageType == 'success'}"> alert-success</c:when>
                    <c:otherwise> alert-info</c:otherwise>
                </c:choose>
            ">
                ${message}
            </div>
        </c:if>

        <!-- 왼쪽: 수강목록, 오른쪽: 주간 시간표 -->
        <div class="mycourse-layout">

            <!-- LEFT: 수강목록 -->
            <div class="mycourse-left">

                <!-- 연도/학기 필터 -->
                <form method="get"
                      action="${pageContext.request.contextPath}/course/my"
                      class="course-filter-form">
                    <label>
                        학년도
                        <select name="year">
                            <c:forEach var="y" items="${yearList}">
                                <option value="${y}"
                                    <c:if test="${year == y}">selected</c:if>>
                                    ${y}
                                </option>
                            </c:forEach>
                        </select>
                    </label>

                    <label>
                        학기
                        <select name="semester">
                            <c:forEach var="sem" items="${semesterList}">
                                <option value="${sem}"
                                    <c:if test="${semester == sem}">selected</c:if>>
                                    ${sem}
                                </option>
                            </c:forEach>
                        </select>
                    </label>

                    <button type="submit" class="home-btn secondary">
                        필터 적용
                    </button>
                </form>

                <!-- 수강 중인 강의 목록 -->
                <div class="box" style="margin-top: 16px;">
                    <div class="box-header">
                        <h3 class="box-title">수강 중인 강의</h3>
                    </div>

                    <c:choose>
                        <c:when test="${empty myCourses}">
                            <p class="empty-text">현재 수강 중인 강의가 없습니다.</p>
                        </c:when>

                        <c:otherwise>
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>강의명</th>
                                    <th>담당 교수</th>
                                    <th>학년도</th>
                                    <th>학기</th>
                                    <th>학점</th>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="c" items="${myCourses}">
                                    <tr>
                                        <td>${c.courseName}</td>
                                        <td>${c.profName}</td>
                                        <td>${c.courseYear}</td>
                                        <td>${c.courseSemester}</td>
                                        <td>${c.credit}</td>
                                        <td>
                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/course/cancel"
                                                  onsubmit="return confirm('정말 수강을 취소하시겠습니까?');">
                                                <input type="hidden" name="courseId" value="${c.courseId}">
                                                <!-- 현재 필터 유지용 -->
                                                <input type="hidden" name="year" value="${year}">
                                                <input type="hidden" name="semester" value="${semester}">
                                                <button type="submit" class="home-btn secondary">
                                                    취소
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- RIGHT: 주간 수업 시간표 (FullCalendar) -->
            <div class="mycourse-right">
                <div class="box">
                    <div class="box-header">
                        <h3 class="box-title">주간 수업 시간표</h3>
                    </div>
                    <div id="myCourseWeeklyCalendar"></div>
                </div>
            </div>

        </div>
    </main>

</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
document.addEventListener('DOMContentLoaded', function () {

    const calendarEl = document.getElementById('myCourseWeeklyCalendar');
    if (!calendarEl) return;

    // ===== 시간 + 교시 라벨 =====
    function slotLabelWithPeriod(arg) {
        const date = arg.date;
        const hour = date.getHours();
        const baseText = arg.text; // "오전 9시" 같은 텍스트

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

    // 교시 → 시간 매핑
    const PERIOD_TIME = {
        1: { start: '09:00:00', end: '09:50:00' },
        2: { start: '10:00:00', end: '10:50:00' },
        3: { start: '11:00:00', end: '11:50:00' },
        4: { start: '13:00:00', end: '13:50:00' },
        5: { start: '14:00:00', end: '14:50:00' },
        6: { start: '15:00:00', end: '15:50:00' },
        7: { start: '16:00:00', end: '16:50:00' },
        8: { start: '17:00:00', end: '17:50:00' }
    };

    // ===== 캘린더 생성 (events 옵션은 비워둔다) =====
    const calendar = new FullCalendar.Calendar(calendarEl, {
        timeZone: 'local',
        initialView: 'timeGridWeek',
        initialDate: new Date(),   // 오늘 기준 주간
        locale: 'ko',
        firstDay: 0,               // 일요일 시작
        allDaySlot: false,
        slotMinTime: '09:00:00',
        slotMaxTime: '18:00:00',
        expandRows: true,
        height: 650,
        headerToolbar: false,
        slotLabelContent: slotLabelWithPeriod,
        events: []                 // 나중에 addEvent 로 채울거라 비워둠
    });

    calendar.render();

    // ===== 주간 시간표 로딩 함수 =====
    function loadWeeklyTimetable() {
        const url = '${pageContext.request.contextPath}/api/course/weekly-timetable';

        fetch(url)
            .then(res => res.json())
            .then(raw => {
                console.log('[my-course] weekly-timetable raw = ', raw);

                const data = Array.isArray(raw)
                    ? raw
                    : (raw.data && Array.isArray(raw.data) ? raw.data : []);

                // ----- 이번 주 일요일을 기준 날짜로 계산 -----
                const baseDate = calendar.getDate();   // 캘린더가 보고 있는 기준 날짜
                const weekStart = new Date(
                    baseDate.getFullYear(),
                    baseDate.getMonth(),
                    baseDate.getDate()
                );
                const dow = weekStart.getDay();        // 0=일, 1=월, ...
                weekStart.setDate(weekStart.getDate() - dow); // 이번 주 일요일로 이동
                weekStart.setHours(0, 0, 0, 0);

                console.log('[my-course] baseDate = ', baseDate, 'weekStart = ', weekStart);

                const events = data.map(e => {
                    const dayOffset = e.dayOfWeek;

                    const date = new Date(weekStart);
                    date.setDate(weekStart.getDate() + dayOffset);

                    const y = date.getFullYear();
                    const m = String(date.getMonth() + 1).padStart(2, '0');
                    const d = String(date.getDate()).padStart(2, '0');

                    const times = PERIOD_TIME[e.period] || PERIOD_TIME[1];
   
                    const start = y + '-' + m + '-' + d + 'T' + times.start;
                    const end   = y + '-' + m + '-' + d + 'T' + times.end;

                    return {
                        
                        title: e.courseName + ' | ' + e.professorName,
                        start: start,
                        end: end,
                        backgroundColor: '#0ea5e9',
                        borderColor: '#0ea5e9',
                        allDay: false
                    };
                });

                console.log('[my-course] built events = ', events);

                // 기존 이벤트 제거 후 새로 추가 (개별 addEvent 사용)
                calendar.removeAllEvents();
                events.forEach(function (evt) {
                    calendar.addEvent(evt);
                });

                console.log('[my-course] calendar.getEvents() after add = ', calendar.getEvents());
            })
            .catch(err => {
                console.error('주간 시간표 이벤트 조회 실패', err);
            });
    }

    // 최초 1회 로딩
    loadWeeklyTimetable();
});
</script>



</body>
</html>
