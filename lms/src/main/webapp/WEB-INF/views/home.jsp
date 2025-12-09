<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LMS 메인 페이지</title>

    <!-- CSS 로딩 -->
    <link rel="stylesheet" href="/css/layout.css">
</head>

<body>

    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">

        <!-- 왼쪽 사이드바 include -->
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

        <!-- 오른쪽 본문 -->
        <main class="main-content home-main">

            <!-- 상단 인사/요약 영역 -->
            <div class="home-hero">
                <c:choose>
                    <c:when test="${not empty loginUser}">
                        <h2 class="home-hero-title">
                            안녕하세요, ${loginUser.userName} 님 👋
                        </h2>
                        <p class="home-hero-text">
                            오늘도 좋은 하루 보내세요. 이번 학기 수업과 과제, 학사 일정을 한 번에 확인해보세요.
                        </p>

                        <!-- 요약 칩(로그인일 때만) -->
                        <div class="home-hero-chips">
                            <a href="${pageContext.request.contextPath}/calendar/my"
                               class="home-chip">
                                다가오는 일정
                                <strong>
                                    ${fn:length(upcomingEvents)}
                                </strong>건
                            </a>

                            <a href="#"
                               class="home-chip">
                                진행 중 과제
                                <strong>
                                    ${fn:length(homeAssignments)}
                                </strong>개
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/qna/list/1"
                               class="home-chip">
                                수강 중 강의
                                <strong>
                                    ${fn:length(enrolledCourses)}
                                </strong>개
                            </a>
                        </div>

                        <!-- 액션 버튼 -->
                        <div class="home-hero-actions">
                            <a href="${pageContext.request.contextPath}/calendar/my"
                               class="home-btn primary">
                                시간표 보기
                            </a>
                            <a href="#"
                               class="home-btn secondary">
                                과제 바로가기
                            </a>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <h2 class="home-hero-title">
                            LMS 학사관리 시스템에 오신 것을 환영합니다.
                        </h2>
                        <p class="home-hero-text">
                            로그인 후 학사일정, 수업, 과제, 성적 등을 확인할 수 있습니다.
                        </p>

                        <div class="home-hero-actions">
                            <a href="${pageContext.request.contextPath}/login"
                               class="home-btn primary">
                                로그인하기
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 메인 그리드 레이아웃 -->
            <div class="home-grid">

                <!-- 왼쪽 컬럼: 공지 + 과제 -->
                <section class="home-grid-left">

                    <!-- 공지사항 카드 -->
                    <div class="box notice-box">
                        <div class="box-header">
                            <h3 class="box-title">공지사항</h3>
                            <a href="${pageContext.request.contextPath}/notice/list"
							   class="box-link section-more">
							    더보기
							</a>
                        </div>

                        <c:choose>
                            <c:when test="${empty recentNotices}">
                                <p class="empty-text">등록된 공지사항이 없습니다.</p>
                            </c:when>

                            <c:otherwise>
                                <ul class="notice-list">
                                    <c:forEach var="n" items="${recentNotices}">
                                        <li class="notice-item">

                                            <a href="${pageContext.request.contextPath}/notice/detail?noticeId=${n.noticeId}"
                                               class="notice-link">

                                                <span class="notice-title">
                                                    <c:if test="${n.pinnedYn == 'Y'}">
                                                        <span class="notice-badge">중요</span>
                                                    </c:if>
                                                    ${n.title}
                                                </span>

                                                <span class="notice-date">
                                                    ${fn:substring(n.createdate, 0, 10)}
                                                </span>
                                            </a>

                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 과제 요약 카드 -->
                    <c:if test="${not empty homeAssignments}">
                        <div class="home-card">
                            <div class="home-card-header">
                                <h3 class="home-card-title">진행 중인 과제</h3>
                                <%-- 과제 전체보기 주소 확정되면 href 수정 --%>
                                <%-- <a href="/assignment/my" class="home-card-more">전체 과제 보기</a> --%>
                            </div>

                            <ul class="course-list">
                                <c:forEach var="a" items="${homeAssignments}">
                                    <li class="course-item">
                                        <div class="course-main">
										    <span class="course-name">
										        ${a.assignmentName}
										    </span>
										
										    <span>
										        <c:choose>
										            <c:when test="${a.dday lt 0}">
										                <span class="dday-pill dday-over">마감 지남</span>
										            </c:when>
										
										            <c:when test="${a.dday eq 0}">
										                <span class="dday-pill dday-today">D-day</span>
										            </c:when>
										
										            <c:otherwise>
										                <span class="dday-pill dday-soon">D-${a.dday}</span>
										            </c:otherwise>
										        </c:choose>
										    </span>
										</div>

                                        <div class="course-sub">
                                            <span>${a.courseName}</span>
                                            <span>
                                                <c:set var="endStr"
                                                       value="${fn:replace(a.endDate, 'T', ' ')}" />
                                                ${fn:substring(endStr, 0, 16)}
                                            </span>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>

                </section>

                <!-- 오른쪽 컬럼: 일정 + 수강 강의 -->
                <section class="home-grid-right">

                    <!-- 다가오는 일정 카드 -->
                    <div class="box upcoming-box">
                        <div class="box-header">
                            <h3 class="box-title">다가오는 일정</h3>
                            <a href="${pageContext.request.contextPath}/calendar"
							   class="box-link section-more">
							    전체 캘린더 보기
							</a>
                        </div>

                        <c:choose>
                            <%-- 로그인 사용자: 통합 일정 --%>
                            <c:when test="${not empty upcomingEvents}">
                                <ul class="event-list">
                                    <c:forEach var="e" items="${upcomingEvents}">
                                        <li class="event-item">
                                            <div class="event-row">
                                                <span class="event-icon">
                                                    <c:choose>
                                                        <c:when test="${e.type == 'CLASS'}">&#x1F4DA;</c:when>
                                                        <c:when test="${e.type == 'EXAM'}">&#x1F4DD;</c:when>
                                                        <c:when test="${e.type == 'ASSIGNMENT'}">&#x1F4CC;</c:when>
                                                        <c:when test="${e.type == 'SCHOOL'}">&#x1F393;</c:when>
                                                        <c:otherwise>&#x1F514;</c:otherwise>
                                                    </c:choose>
                                                </span>

                                                <div class="event-body">
                                                    <div class="event-meta-row">
                                                        <span class="event-date">
                                                            ${fn:substring(e.start, 0, 10)}
                                                            &nbsp;
                                                            <span class="event-time">
                                                                ${fn:substring(e.start, 11, 16)}
                                                            </span>
                                                        </span>

                                                        <span class="event-type-pill type-${e.type}">
                                                            <c:choose>
                                                                <c:when test="${e.type == 'CLASS'}">수업</c:when>
                                                                <c:when test="${e.type == 'EXAM'}">시험</c:when>
                                                                <c:when test="${e.type == 'ASSIGNMENT'}">과제</c:when>
                                                                <c:when test="${e.type == 'SCHOOL'}">학사</c:when>
                                                                <c:otherwise>기타</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>

                                                    <div class="event-title">
                                                        <c:choose>
                                                            <c:when test="${e.type == 'CLASS' or e.type == 'EXAM' or e.type == 'ASSIGNMENT'}">
                                                                ${e.courseName} - ${e.title}
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${e.title}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>

                            <%-- 비로그인: 학사 일정만 --%>
                            <c:when test="${empty upcomingEvents and not empty upcomingAcademicEvents}">
                                <ul class="event-list">
                                    <c:forEach var="e" items="${upcomingAcademicEvents}">
                                        <li class="event-item">
                                            <div class="event-row">
                                                <span class="event-icon">&#x1F393;</span>

                                                <div class="event-body">
                                                    <div class="event-meta-row">
                                                        <span class="event-date">
                                                            ${fn:substring(e.eventFromdate, 0, 10)}
                                                        </span>
                                                        <span class="event-type-pill type-SCHOOL">학사</span>
                                                    </div>

                                                    <div class="event-title">
                                                        ${e.eventName}
                                                    </div>

                                                    <c:if test="${not empty e.eventContext}">
                                                        <div class="event-context">
                                                            ${e.eventContext}
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>

                            <c:otherwise>
                                <p class="empty-text">등록된 다가오는 일정이 없습니다.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 수강 중인 강의 카드 -->
                    <c:if test="${not empty enrolledCourses}">
                        <div class="home-card">
                            <div class="home-card-header">
                                <h3 class="home-card-title">이번 학기 수강 과목</h3>
                            </div>

                            <ul class="course-list">
                                <c:forEach var="course" items="${enrolledCourses}">
                                    <li class="course-item">
                                        <div class="course-main">
                                            <span class="course-name">${course.courseName}</span>
                                            <span class="course-credit">${course.credit}학점</span>
                                        </div>
                                        <div class="course-sub">
                                            <span>${course.courseYear}년 ${course.courseSemester}</span>
                                            <span>${course.professorName}</span>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>

                </section>

            </div> <!-- /home-grid -->

        </main>

    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
