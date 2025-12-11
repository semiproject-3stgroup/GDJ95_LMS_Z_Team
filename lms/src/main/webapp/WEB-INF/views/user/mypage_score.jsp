<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"  %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>학점 조회</title>
    <link rel="stylesheet" href="/css/layout.css">
</head>
<body class="score-page">

    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">

        <%-- 좌측 사이드바 --%>
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

        <main class="main-content">

            <!-- 페이지 헤더 -->
            <div class="page-header">
                <h1 class="page-title">학점 조회</h1>
            </div>

            <!-- 상단 요약 카드 영역 -->
            <section class="score-summary-grid">

                <!-- 왼쪽: 전체 평점 카드 -->
                <div class="card score-summary-main">
                    <div class="score-summary-header">전체 평점 (GPA)</div>

                    <div class="score-gpa-row">
                        <span class="score-gpa-value">
                            <fmt:formatNumber value="${gpa}" minFractionDigits="3" maxFractionDigits="3" />
                        </span>
                        <span class="score-gpa-scale">/ 4.500</span>
                    </div>

                    <p class="score-summary-sub">
                        현재까지 입력된 성적을 기준으로 계산된 평점입니다.
                    </p>

                    <p class="score-summary-meta">
                        성적 정정 기간 이후에는 담당 교수 확인 후에만 변경될 수 있습니다.
                    </p>
                </div>

                <!-- 오른쪽: 안내 카드 -->
                <div class="card score-summary-side">
                    <div class="score-summary-side-title">성적/평점 안내</div>
                    <ul class="score-summary-side-list">
                        <li>평점은 과목별 평점 × 학점의 합을 기준으로 계산됩니다.</li>
                        <li>F 과목은 평점 계산에 포함되며, 재수강 시 최근 성적이 반영됩니다.</li>
                        <li>일부 과목은 Pass/Fail 과목으로 평점에 포함되지 않을 수 있습니다.</li>
                    </ul>
                </div>

            </section>

            <!-- 하단: 상세 성적 테이블 -->
            <section class="card score-table-card">

                <h2 class="score-section-title">상세 성적</h2>

                <table class="table score-table">
                    <thead>
                        <tr>
                            <th class="table-cell-center">년도</th>
                            <th class="table-cell-center">학기</th>
                            <th>과목명</th>
                            <th class="table-cell-center">학점</th>
                            <th class="table-cell-center">시험1</th>
                            <th class="table-cell-center">시험2</th>
                            <th class="table-cell-center">과제</th>
                            <th class="table-cell-center">출석</th>
                            <th class="table-cell-center">총점</th>
                            <th class="table-cell-center">등급</th>
                            <th class="table-cell-center">평점</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${scoreList}">
                            <tr>
                                <td class="table-cell-center"><c:out value="${s.courseYear}" /></td>
                                <td class="table-cell-center"><c:out value="${s.courseSemester}" /></td>
                                <td><c:out value="${s.courseName}" /></td>
                                <td class="table-cell-center"><c:out value="${s.credit}" /></td>
                                <td class="table-cell-center"><c:out value="${s.exam1Score}" /></td>
                                <td class="table-cell-center"><c:out value="${s.exam2Score}" /></td>
                                <td class="table-cell-center"><c:out value="${s.assignmentScore}" /></td>
                                <td class="table-cell-center"><c:out value="${s.attendanceScore}" /></td>
                                <td class="table-cell-center"><c:out value="${s.scoreTotal}" /></td>
                                <td class="table-cell-center"><c:out value="${s.letterGrade}" /></td>
                                <td class="table-cell-center"><c:out value="${s.gradePoint}" /></td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty scoreList}">
                            <tr>
                                <td colspan="11" class="table-empty">
                                    성적 정보가 없습니다.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

            </section>

        </main>

    </div>

</body>
</html>
