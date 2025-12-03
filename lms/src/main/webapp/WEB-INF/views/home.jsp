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
        <main class="main-content">
            <h2>메인 페이지</h2>

            <!-- 로그인/환영 박스 -->
            <div class="box">
                <c:choose>
                    <c:when test="${not empty loginUser}">
                        <p style="font-size: 16px; margin-bottom: 10px;">
                            <strong>${loginUser.userName}</strong> 님 환영합니다 😊
                        </p>
                        <p style="color: #555;">
                            학사 일정, 내 강의, 알림, 과제 제출 등<br>
                            앞으로 이 영역에 카드형 컴포넌트들이 배치될 예정입니다.
                        </p>
                    </c:when>

                    <c:otherwise>
                        <p style="font-size: 16px; margin-bottom: 10px;">
                            LMS 학사관리 시스템에 오신 것을 환영합니다.
                        </p>
                        <p style="color: #555; margin-bottom: 20px;">
                            로그인 후 다양한 학사 기능을 이용할 수 있습니다.
                        </p>

                        <a href="${pageContext.request.contextPath}/login"
                           style="font-size: 16px; padding: 10px 18px; background: #4a8fff; color: white; text-decoration: none; border-radius: 4px;">
                            로그인하기
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!--  공지사항 카드 -->
			<div class="box notice-box" style="margin-bottom: 24px;">
			    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
			        <h3 style="font-size: 18px; font-weight: 600; margin: 0;">공지사항</h3>
			        <a href="${pageContext.request.contextPath}/notice/list"
			           style="font-size: 14px; color: #4a8fff; text-decoration: none; font-weight: 500;">
			            더보기
			        </a>
			    </div>
			
			    <c:choose>
			        <c:when test="${empty recentNotices}">
			            <p style="color: #666; font-size: 14px; margin: 0;">등록된 공지사항이 없습니다.</p>
			        </c:when>
			
			        <c:otherwise>
			            <ul style="list-style: none; padding: 0; margin: 0;">
			                <c:forEach var="n" items="${recentNotices}">
			                    <li style="padding: 10px 0; border-bottom: 1px solid #eee;">
			
			                        <a href="${pageContext.request.contextPath}/notice/detail?noticeId=${n.noticeId}"
			                           style="text-decoration: none; display: flex; justify-content: space-between; align-items: center;">
			
			                            <span style="font-size: 15px; color: #111; font-weight: 500;">
			                                <c:if test="${n.pinnedYn == 'Y'}">
			                                    <span style="color:#d14; font-weight:700; margin-right:6px;">[중요]</span>
			                                </c:if>
			                                ${n.title}
			                            </span>
			
			                            <span style="font-size: 13px; color: #888;">
			                                ${fn:substring(n.createdate, 0, 10)}
			                            </span>
			                        </a>
			
			                    </li>
			                </c:forEach>
			            </ul>
			        </c:otherwise>
			    </c:choose>
			</div>
			
			
			<!-- 수강 중인 강의 카드 -->
            <c:if test="${not empty enrolledCourses}">
                <div class="home-card">
                    <div class="home-card-header">
                        <h3 class="home-card-title">수강 중인 강의</h3>
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
			

            <!-- 다가오는 학사 일정 박스 -->
            <div class="box upcoming-box">
                <h3 class="box-title">다가오는 학사 일정</h3>

                <c:choose>
                    <c:when test="${empty upcoming}">
                        <p class="empty-text">등록된 다가오는 일정이 없습니다.</p>
                    </c:when>
                    <c:otherwise>
                        <ul class="event-list">
                            <c:forEach var="e" items="${upcoming}">
                                <li class="event-item">
                                    <div class="event-title">
                                        ${e.eventName}
                                    </div>
                                    <div class="event-date">
                                        ${e.eventFromdate}
                                        <c:if test="${e.eventTodate != null}">
                                            ~ ${e.eventTodate}
                                        </c:if>
                                    </div>
                                    <c:if test="${not empty e.eventContext}">
                                        <div class="event-context">
                                            ${e.eventContext}
                                        </div>
                                    </c:if>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:otherwise>
                </c:choose>
            </div>

        </main>

    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
