<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>과제 상세 / 제출</title>

    <!-- 공통 레이아웃 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body class="assignment-page">

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">

    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header">
            <h1 class="page-title">과제 제출</h1>

            <div class="page-header-actions">
                <a href="${pageContext.request.contextPath}/stuAssignment"
                   class="btn btn-secondary">목록으로</a>
            </div>
        </div>

        <!-- 과제 정보 카드 -->
        <div class="box" style="margin-bottom: 20px;">

            <!-- 과목 / 제목 -->
            <div style="margin-bottom: 12px;">
                <div style="font-size: 14px; color:#6b7280; margin-bottom: 4px;">
                    ${course.courseName}
                </div>
                <div style="font-size: 18px; font-weight: 700; color:#111827;">
                    ${assignment.assignmentName}
                </div>
            </div>

            <!-- 작성일 / 기간 -->
            <div style="display:flex; flex-wrap:wrap; gap:16px; font-size:13px; color:#6b7280; margin-bottom: 14px;">
                <span>
                    작성일 :
                    <c:choose>
                        <c:when test="${not empty assignment.updatedate}">
                            ${assignment.updatedate}
                        </c:when>
                        <c:otherwise>
                            ${assignment.createdate}
                        </c:otherwise>
                    </c:choose>
                </span>
                <span>
                    제출 기간 : ${assignment.startdate} ~ ${assignment.enddate}
                </span>
            </div>

            <!-- 과제 내용 -->
            <div>
                <div class="board-form-label">과제 내용</div>
                <div style="font-size:14px; color:#111827; line-height:1.6; white-space:pre-wrap; border-radius:8px; background:#f9fafb; padding:12px 14px; border:1px solid #e5e7eb;">
                    ${assignment.assignmentContent}
                </div>
            </div>
        </div>

        <!-- 제출 정보 + 업로드 폼 -->
        <div class="box">

            <!-- 제출 여부 / 기존 제출 파일 -->
            <div style="margin-bottom: 18px;">
                <div class="board-form-label">제출 현황</div>

                <c:choose>
                    <c:when test="${empty assignmentSubmit.file}">
                        <p class="empty-text" style="margin:0;">
                            아직 제출하지 않은 과제입니다. 아래에서 파일을 업로드해 주세요.
                        </p>
                    </c:when>
                    <c:otherwise>
                        <div class="board-file-item">
                            <span class="board-file-icon">📎</span>
                            <a class="board-file-link"
                               href="${pageContext.request.contextPath}/upload/${assignment.courseId}/${assignmentSubmit.file}"
                               download="${assignmentSubmit.file}">
                                ${assignmentSubmit.file}
                            </a>
                            <span class="board-file-size">
                                (${not empty assignmentSubmit.updatedate ? assignmentSubmit.updatedate : assignmentSubmit.createdate})
                            </span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 업로드 폼 -->
            <form id="submitForm" method="post" enctype="multipart/form-data">

                <input type="hidden" name="assignmentId" value="${assignment.assignmentId}">
                <input type="hidden" name="userId" value="${userId}">
                <input type="hidden" name="file" value="${assignmentSubmit.file}">

                <!-- 업로드 영역 (버튼 누르면 펼쳐짐) -->
                <div id="uploadArea" hidden>
                    <div id="dropZone" class="file-dropzone">
                        <div id="filename">선택된 파일 없음</div>
                        <div class="file-dropzone-click">클릭해서 파일 선택 또는 드래그 앤 드롭</div>
                    </div>

                    <input type="file" id="uploadFile" name="uploadFile" hidden>

                    <div style="text-align:right; margin-top:12px;">
                        <button type="button" id="uploadBtn" class="btn btn-primary">
                            업로드
                        </button>
                    </div>
                </div>
            </form>

            <!-- 하단 버튼들 -->
            <div style="display:flex; justify-content:space-between; align-items:center; margin-top:18px;">
                <a href="${pageContext.request.contextPath}/stuAssignment"
                   class="btn btn-secondary">
                    목록
                </a>

                <div style="display:flex; gap:8px;">
                    <c:if test="${empty assignmentSubmit.file}">
                        <button type="button" id="addBtn" class="btn btn-primary">
                            제출하기
                        </button>
                    </c:if>
                    <c:if test="${not empty assignmentSubmit.file}">
                        <button type="button" id="modifyBtn" class="btn btn-primary">
                            수정하기
                        </button>
                    </c:if>
                </div>
            </div>

        </div>

    </main>
</div>

<script>
    $(function () {

        // 제출하기 / 수정하기 버튼 공통
        $('#addBtn, #modifyBtn').on('click', function (e) {
            const btn = $(e.target);
            const form = $('#submitForm');

            if (btn.attr('id') === 'addBtn') {
                form.attr('action', '${pageContext.request.contextPath}/stuAssignmentSubmit');
                form.data('mode', 'add');
            } else {
                form.attr('action', '${pageContext.request.contextPath}/stuAssignmentModify');
                form.data('mode', 'modify');
            }

            if ($('#uploadArea').prop('hidden')) {
                $('#uploadArea').prop('hidden', false);
                btn.data('ori', btn.text());
                btn.text('취소');
            } else {
                $('#uploadArea').prop('hidden', true);
                btn.text(btn.data('ori'));
                $('#uploadFile').val('');
                $('#filename').text('선택된 파일 없음');
            }
        });

        // 드래그 앤 드롭
        $('#dropZone').on('dragover', function (e) {
            e.preventDefault();
            $(this).addClass('dragover');
        });

        $('#dropZone').on('dragleave', function () {
            $(this).removeClass('dragover');
        });

        $('#dropZone').on('drop', function (e) {
            e.preventDefault();
            $(this).removeClass('dragover');

            const files = e.originalEvent.dataTransfer.files;
            if (!files || files.length === 0) return;
            if (files.length > 1) {
                alert('파일은 한 개만 업로드할 수 있습니다.');
                return;
            }

            $('#uploadFile')[0].files = files;
            $('#filename').text(files[0].name);
        });

        // 클릭해서 파일 선택
        $('#dropZone').on('click', function () {
            $('#uploadFile').click();
        });

        $('#uploadFile').on('change', function (e) {
            const files = e.target.files;
            if (files && files.length > 0) {
                $('#filename').text(files[0].name);
            } else {
                $('#filename').text('선택된 파일 없음');
            }
        });

        // 업로드 버튼
        $('#uploadBtn').on('click', function () {
            const fileInput = $('#uploadFile')[0];

            if (!fileInput.files || fileInput.files.length === 0) {
                alert('업로드할 파일을 선택해 주세요.');
                return;
            }

            if ($('#submitForm').data('mode') === 'modify') {
                if (!confirm('기존 제출 파일을 덮어쓸까요?')) {
                    return;
                }
            }

            $('#submitForm').submit();
        });
    });
</script>

</body>
</html>
