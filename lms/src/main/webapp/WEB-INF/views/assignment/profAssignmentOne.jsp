<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>과제 상세</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">

    <style>
        .assignment-detail-wrap {
            max-width: 960px;
        }
        .assignment-meta {
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 14px;
        }
        .assignment-meta div + div {
            margin-top: 2px;
        }
        .assignment-content {
            border-top: 1px solid #e5e7eb;
            padding-top: 12px;
            font-size: 14px;
            line-height: 1.6;
            white-space: pre-wrap;
        }
        .assignment-actions {
            margin-top: 18px;
            display: flex;
            gap: 8px;
            align-items: center;
        }
        .assignment-actions .right {
            margin-left: auto;
        }

        /* ===== 제출 현황 전용 스타일 ===== */
        .submission-box-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 8px;
        }
        .submission-empty {
            font-size: 13px;
            color: #6b7280;
        }
        .submission-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        .submission-table th,
        .submission-table td {
            padding: 8px 10px;
            border-bottom: 1px solid #e5e7eb;
        }
        .submission-table th {
            text-align: left;
            background-color: #f9fafb;
            font-weight: 600;
            color: #374151;
        }
        .submission-table td {
            vertical-align: middle;
            color: #374151;
        }
        .submission-student {
            white-space: nowrap;
        }
        .submission-file a {
            color: #2563eb;
            text-decoration: none;
        }
        .submission-file a:hover {
            text-decoration: underline;
        }
        .badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 2px 8px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 600;
            border: 1px solid transparent;
            white-space: nowrap;
        }
        .badge-success {
            color: #15803d;
            background-color: #dcfce7;
            border-color: #bbf7d0;
        }
        .badge-muted {
            color: #6b7280;
            background-color: #f3f4f6;
            border-color: #e5e7eb;
        }
        .badge-late {
            color: #b91c1c;
            background-color: #fee2e2;
            border-color: #fecaca;
            margin-left: 4px;
        }

        .scoreInput {
            width: 70px;
            padding: 4px 6px;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            font-size: 13px;
        }
        .score-state {
            margin-left: 6px;
            font-size: 12px;
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">

        <!-- 과목명 기준 타이틀 -->
        <h1 class="page-title">
            ${course.courseName}
        </h1>

        <!-- 과제 기본 정보 카드 -->
        <section class="box assignment-detail-wrap">
            <div class="box-header">
                <h2 class="box-title">${assignment.assignmentName}</h2>
            </div>

            <div class="assignment-meta">
                <div>
                    작성일 :
                    <c:choose>
                        <c:when test="${not empty assignment.updatedate}">
                            ${assignment.updatedate}
                        </c:when>
                        <c:otherwise>
                            ${assignment.createdate}
                        </c:otherwise>
                    </c:choose>
                </div>
                <div>기간 : ${assignment.startdate} ~ ${assignment.enddate}</div>
            </div>

            <div class="assignment-content">
                ${assignment.assignmentContent}
            </div>

            <div class="assignment-actions">
                <a href="${pageContext.request.contextPath}/profAssignmentModify?assignmentId=${assignment.assignmentId}"
                   class="btn btn-secondary">
                    수정
                </a>

                <form action="${pageContext.request.contextPath}/profAssignmentRemove"
                      method="post"
                      class="inline-form"
                      onsubmit="return confirm('정말 이 과제를 삭제하시겠습니까?');">
                    <input type="hidden" name="assignmentId" value="${assignment.assignmentId}">
                    <button type="submit" class="btn btn-danger">
                        삭제
                    </button>
                </form>

                <a href="${pageContext.request.contextPath}/profAssignment"
                   class="btn btn-secondary right">
                    목록
                </a>
            </div>
        </section>

        <!-- 과제 제출 현황 + 바로 채점 -->
        <section class="box assignment-detail-wrap" style="margin-top: 18px;">
            <div class="submission-box-header">
                <h2 class="box-title">과제 제출 현황</h2>

                <!-- 마감 이후에만 채점 버튼 노출 -->
                <c:if test="${isDateOver}">
                    <button type="button" id="scoringBtn" class="btn btn-secondary">
                        채점
                    </button>
                </c:if>
            </div>

            <input type="hidden" id="assignmentId" value="${assignment.assignmentId}"/>

            <c:choose>
                <c:when test="${empty students}">
                    <p class="submission-empty">이 강의를 수강 중인 학생이 없거나, 제출 내역이 없습니다.</p>
                </c:when>
                <c:otherwise>
                    <table class="submission-table">
                        <thead>
                        <tr>
                            <th style="width: 160px;">학생</th>
                            <th>제출 파일</th>
                            <th style="width: 230px;">제출일</th>
                            <th style="width: 180px;">점수 입력</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="stu" items="${students}">
                            <tr>
                                <!-- 학번 + 이름 -->
                                <td class="submission-student">
                                    ${stu.studentNo} ${stu.userName}
                                </td>

                                <!-- 제출 파일 / 미제출 -->
                                <td class="submission-file">
                                    <c:choose>
                                        <c:when test="${not empty stu.file}">
                                            <a href="${pageContext.request.contextPath}/upload/${assignment.assignmentId}/${stu.file}"
                                               download="${stu.file}">
                                                ${stu.file}
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-muted">미제출</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- 제출일 + 지각 여부 -->
                                <td class="submission-date">
                                    <c:if test="${not empty stu.file}">
                                        ${not empty stu.updatedate ? stu.updatedate : stu.createdate}
                                        <c:if test="${stu.isLate}">
                                            <span class="badge badge-late">지각</span>
                                        </c:if>
                                    </c:if>
                                </td>

                                <!-- 점수 입력 / 저장 버튼 (제출한 학생만) -->
                                <td>
                                    <c:if test="${not empty stu.file}">
                                        <input type="number"
                                               min="0" max="100"
                                               value="${stu.assignmentScore}"
                                               class="scoreInput"
                                               data-user-id="${stu.userId}"
                                               style="display:none" />
                                        <button type="button"
                                                class="btn btn-primary saveBtn"
                                                data-user-id="${stu.userId}"
                                                style="display:none">
                                            저장
                                        </button>
                                        <span id="scoreState-${stu.userId}" class="score-state"></span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </section>

    </main>
</div>

<!-- jQuery가 layout 쪽에서 이미 포함되어 있다고 가정 -->
<script>
    // 저장 버튼 클릭 → 점수 저장 AJAX
    $('.saveBtn').on('click', function (e) {
        const userId = $(this).data('userId');
        const assignmentId = $('#assignmentId').val();
        const $scoreInput = $('.scoreInput[data-user-id="' + userId + '"]');
        const score = $scoreInput.val();

        if (score === '') {
            alert('점수를 입력하세요.');
            return;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/rest/assignmentScore',
            type: 'post',
            data: {
                assignmentId: assignmentId,
                userId: userId,
                assignmentScore: score
            },
            success: function () {
                $('#scoreState-' + userId)
                    .text('저장완료')
                    .css('color', 'green');
            },
            error: function () {
                $('#scoreState-' + userId)
                    .text('저장실패')
                    .css('color', 'red');
            }
        });
    });

    // 채점 버튼 클릭 → 점수 input / 저장 버튼 토글
    $('#scoringBtn').on('click', function () {
        const $inputs = $('.scoreInput');
        const $buttons = $('.saveBtn');
        const isHidden = $inputs.first().css('display') === 'none';

        if (isHidden) {
            $inputs.show();
            $buttons.show();
            $('.score-state').text('');
            $('#scoringBtn').text('닫기');
        } else {
            $inputs.hide();
            $buttons.hide();
            $('.score-state').text('');
            $('#scoringBtn').text('채점');
        }
    });
</script>

</body>
</html>
