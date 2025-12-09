<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내 수강목록</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
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
                    <c:when test="${cancelBannerType == 'error'}">alert-error</c:when>
                    <c:when test="${cancelBannerType == 'success'}">alert-success</c:when>
                    <c:otherwise>alert-info</c:otherwise>
                </c:choose>
            ">
                ${cancelBannerText}
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

        <!-- 연도/학기 필터 (수강신청 화면과 동일) -->
        <form method="get"
              action="${pageContext.request.contextPath}/course/my"
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

    </main>

</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
