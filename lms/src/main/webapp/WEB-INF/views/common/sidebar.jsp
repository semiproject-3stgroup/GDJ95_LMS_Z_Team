<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="role" value="${loginUser.role}" />

<nav class="sidebar">

    <!-- 공통: 메인 -->
    <div class="sidebar-section">
        <div class="sidebar-title">메인</div>
        <ul class="sidebar-menu">
            <li class="${menu eq 'home' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/home">
                    <span class="sidebar-icon">🏠</span>
                    <span>메인페이지</span>
                </a>
            </li>
        </ul>
    </div>

    <!-- =========================
         학생(STUDENT) 메뉴
       ========================= -->
    <c:if test="${role == 'STUDENT'}">

        <!-- 수업 -->
        <div class="sidebar-section">
            <div class="sidebar-title">수업</div>
            <ul class="sidebar-menu">
                <li class="${menu eq 'notice' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/notice/list">
                        <span class="sidebar-icon">📢</span>
                        <span>공지사항</span>
                    </a>
                </li>
                <!-- 학과별 게시판 (학생) -->
                <li class="${menu eq 'deptBoard' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/deptBoard">
                        <span class="sidebar-icon">💬</span>
                        <span>학과별 게시판</span>
                    </a>
                </li>
                <li class="${menu eq 'courseRegister' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/course/register">
                        <span class="sidebar-icon">📝</span>
                        <span>수강신청</span>
                    </a>
                </li>
                <li class="${menu eq 'assignment' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/stuAssignment">
                        <span class="sidebar-icon">✅</span>
                        <span>진행 중인 과제</span>
                    </a>
                </li>
                <li class="${menu eq 'myCourse' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/course/my">
                        <span class="sidebar-icon">📚</span>
                        <span>이번 학기 수강 과목</span>
                    </a>
                </li>
                <li class="${menu eq 'score' ? 'active' : ''}">
                    <!-- 학점 조회는 기존 경로 유지 -->
                    <a href="${pageContext.request.contextPath}/mypage/score">
                        <span class="sidebar-icon">🎓</span>
                        <span>학점 조회</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- 캘린더 -->
        <div class="sidebar-section">
            <div class="sidebar-title">캘린더</div>
            <ul class="sidebar-menu">
                <li class="${menu eq 'calendarMy' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/calendar/my">
                        <span class="sidebar-icon">📅</span>
                        <span>내 일정 캘린더</span>
                    </a>
                </li>
                <li class="${menu eq 'calendarAcademic' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/calendar/academic">
                        <span class="sidebar-icon">🏫</span>
                        <span>전체 학사 캘린더</span>
                    </a>
                </li>
            </ul>
        </div>


    </c:if>

    <!-- =========================
         교수(PROF) 메뉴
       ========================= -->
    <c:if test="${role == 'PROF'}">

        <!-- 수업 -->
        <div class="sidebar-section">
            <div class="sidebar-title">수업</div>
            <ul class="sidebar-menu">
                <li class="${menu eq 'notice' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/notice/list">
                        <span class="sidebar-icon">📢</span>
                        <span>공지사항</span>
                    </a>
                </li>
                <!-- 학과별 게시판 (교수) -->
                <li class="${menu eq 'deptBoard' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/deptBoard">
                        <span class="sidebar-icon">💬</span>
                        <span>학과별 게시판</span>
                    </a>
                </li>
                <li class="${menu eq 'calendarProf' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/calendar/prof">
                        <span class="sidebar-icon">📅</span>
                        <span>강의/과제 캘린더</span>
                    </a>
                </li>
                <li class="${menu eq 'scoreProf' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/course/prof">
                        <span class="sidebar-icon">🧮</span>
                        <span>내 강의 목록</span>
                    </a>
                </li>
            </ul>
        </div>



    </c:if>

    <!-- =========================
         관리자(ADMIN) 메뉴
       ========================= -->
    <c:if test="${role == 'ADMIN'}">

        <!-- 학사/사용자/학과 관리 -->
        <div class="sidebar-section">
            <div class="sidebar-title">관리</div>
            <ul class="sidebar-menu">
                <li class="${menu eq 'adminEvent' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/events">
                        <span class="sidebar-icon">📅</span>
                        <span>학사일정 관리</span>
                    </a>
                </li>
                <li class="${menu eq 'adminUser' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/user/list">
                        <span class="sidebar-icon">👥</span>
                        <span>사용자 관리</span>
                    </a>
                </li>
                <li class="${menu eq 'adminNotice' ? 'active' : ''}">
                    <!-- 공지 관리도 공지 컨트롤러 재사용 -->
                    <a href="${pageContext.request.contextPath}/notice/list">
                        <span class="sidebar-icon">📢</span>
                        <span>공지 관리</span>
                    </a>
                </li>
                <%-- 필요하면 여기 학과별 게시판 관리 메뉴도 추가 가능
                <li class="${menu eq 'adminDeptBoard' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/dept/board">
                        <span class="sidebar-icon">💬</span>
                        <span>학과 게시판 관리</span>
                    </a>
                </li>
                --%>
            </ul>
        </div>

        <!-- 관리자 마이페이지 (있다면) -->
        <div class="sidebar-section">
            <div class="sidebar-title">마이페이지</div>
            <ul class="sidebar-menu">
                <li class="${menu eq 'mypage' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/mypage">
                        <span class="sidebar-icon">👤</span>
                        <span>마이페이지</span>
                    </a>
                </li>
            </ul>
        </div>

    </c:if>

</nav>
