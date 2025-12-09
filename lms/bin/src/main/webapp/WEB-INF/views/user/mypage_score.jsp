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
<body>

    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">

        <%-- 좌측 사이드바 --%>
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

        <main class="content">
            <h2>학점 조회</h2>

            <section style="margin-bottom: 16px;">
                <p>
                    전체 평점(GPA):
                    <strong>
					    <fmt:formatNumber value="${gpa}" minFractionDigits="3" maxFractionDigits="3" />
					</strong>
                </p>
            </section>

            <section>
                <table border="1" cellpadding="8" cellspacing="0" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr>
                            <th>년도</th>
                            <th>학기</th>
                            <th>과목명</th>
                            <th>학점</th>
                            <th>시험1</th>
                            <th>시험2</th>
                            <th>과제</th>
                            <th>출석</th>
                            <th>총점</th>
                            <th>등급</th>
                            <th>평점</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${scoreList}">
                            <tr>
                                <td><c:out value="${s.courseYear}" /></td>
                                <td><c:out value="${s.courseSemester}" /></td>
                                <td><c:out value="${s.courseName}" /></td>
                                <td><c:out value="${s.credit}" /></td>
                                <td><c:out value="${s.exam1Score}" /></td>
                                <td><c:out value="${s.exam2Score}" /></td>
                                <td><c:out value="${s.assignmentScore}" /></td>
                                <td><c:out value="${s.attendanceScore}" /></td>
                                <td><c:out value="${s.scoreTotal}" /></td>
                                <td><c:out value="${s.letterGrade}" /></td>
                                <td><c:out value="${s.gradePoint}" /></td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty scoreList}">
                            <tr>
                                <td colspan="11" style="text-align:center;">
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
