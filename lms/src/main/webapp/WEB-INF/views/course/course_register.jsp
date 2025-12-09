<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>수강신청</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">

    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">

        <h2 class="page-title">수강신청</h2>

        <!-- 수강신청 기간 / 수동 상태 안내 배너 -->
        <c:if test="${not empty registerBannerText}">
            <div class="alert
                <c:choose>
                    <c:when test="${registerBannerType == 'error'}">alert-error</c:when>
                    <c:when test="${registerBannerType == 'success'}">alert-success</c:when>
                    <c:otherwise>alert-info</c:otherwise>
                </c:choose>
            ">
                ${registerBannerText}
            </div>
        </c:if>

        <!-- 메시지 영역 -->
        <c:if test="${not empty message}">
            <div class="alert
                <c:choose>
                    <c:when test="${messageType == 'error'}">alert-error</c:when>
                    <c:when test="${messageType == 'success'}">alert-success</c:when>
                    <c:otherwise>alert-info</c:otherwise>
                </c:choose>
            ">
                ${message}
            </div>
        </c:if>

        <!-- 연도/학기 필터 -->
        <form method="get"
              action="${pageContext.request.contextPath}/course/register"
              class="course-filter-form">
            <label>
                학년도
                <select name="year">
                    <option value="">전체</option>
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
                    <option value="">전체</option>
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

        <!-- 좌측: 강의 목록 / 우측: 주간 예상 시간표 -->
        <div class="course-page-grid">

            <!-- 왼쪽: 강의 목록 -->
            <div class="course-page-left">
                <div class="box">
                    <div class="box-header">
                        <h3 class="box-title">신청 가능한 강의 목록</h3>
                    </div>

                    <c:choose>
                        <c:when test="${empty openCourses}">
                            <p class="empty-text">현재 신청 가능한 강의가 없습니다.</p>
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
                                    <th>수업시간</th>
                                    <th>상태</th>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="c" items="${openCourses}">
                                    <!-- 행 클릭 시 미리보기 -->
                                    <tr class="course-row"
                                        data-course-id="${c.courseId}">
                                        <td>${c.courseName}</td>
                                        <td>${c.profName}</td>
                                        <td>${c.courseYear}</td>
                                        <td>${c.courseSemester}</td>
                                        <td>${c.credit}</td>
                                        <td>${c.scheduleSummary}</td>
                                        <td>${c.status}</td>
                                        <td>
                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/course/register">
                                                <input type="hidden" name="courseId" value="${c.courseId}">
                                                <button type="submit" class="home-btn primary">
                                                    신청
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

            <!-- 오른쪽: 주간 예상 시간표 -->
            <div class="course-page-right">
                <div class="box">
                    <div class="box-header">
                        <h3 class="box-title">주간 예상 시간표</h3>
                    </div>

                    <!-- JS로 채울 테이블 -->
                    <table class="timetable-table" id="timetable">
                        <thead>
                        <tr>
                            <th></th>
                            <th>월</th>
                            <th>화</th>
                            <th>수</th>
                            <th>목</th>
                            <th>금</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="p" begin="1" end="9">
                            <tr>
                                <th class="timetable-period">${p}교시</th>
                                <c:forEach var="d" begin="1" end="5">
                                    <td class="timetable-cell"
                                        data-day="${d}"
                                        data-period="${p}"></td>
                                </c:forEach>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                    <p class="timetable-hint">
                        왼쪽에서 강의 행을 클릭하면 해당 강의를 포함한 예상 시간표를 미리 볼 수 있습니다.
                        (신청 버튼은 실제 수강신청)
                    </p>
                </div>
            </div>

        </div> <!-- /course-page-grid -->

        <!-- 주간 시간표 렌더링 스크립트 -->
        <script>
            function clearTimetable() {
                const cells = document.querySelectorAll('#timetable td[data-day]');
                cells.forEach(cell => cell.innerHTML = '');
            }

            function renderTimetable(slots) {
                clearTimetable();

                slots.forEach(slot => {
                    const selector =
                        '#timetable td[data-day="' + slot.dayOfWeek +
                        '"][data-period="' + slot.period + '"]';

                    const cell = document.querySelector(selector);
                    if (!cell) return;

                    const box = document.createElement('div');
                    box.className = 'tt-slot';
                    box.innerHTML =
                        '<div class="tt-title">' + slot.courseName + '</div>' +
                        '<div class="tt-prof">' + (slot.professorName || '') + '</div>';

                    cell.appendChild(box);
                });
            }

            function loadTimetable(previewCourseId) {
                const baseUrl = '${pageContext.request.contextPath}/api/course/weekly-timetable';
                const params = new URLSearchParams();

                if (previewCourseId) {
                    params.append('previewCourseId', previewCourseId);
                }

                const url = params.toString() ? baseUrl + '?' + params.toString() : baseUrl;

                fetch(url)
                    .then(res => res.json())
                    .then(data => {
                        renderTimetable(data);
                    })
                    .catch(err => {
                        console.error('주간 시간표 로딩 실패', err);
                    });
            }

            document.addEventListener('DOMContentLoaded', function () {
                loadTimetable();

                document.querySelectorAll('.course-row').forEach(function (row) {
                    row.addEventListener('click', function (e) {
                        if (e.target.tagName === 'BUTTON') {
                            return;
                        }
                        const courseId = this.getAttribute('data-course-id');
                        if (courseId) {
                            loadTimetable(courseId);
                        }
                    });
                });
            });
        </script>

    </main>

</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
