<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>학과 게시판 글 수정</title>

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body class="board-page dept-page">

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">

    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header">
            <div>
                <h1 class="page-title">학과 게시글 수정</h1>
            </div>

            <div class="page-header-actions">
                <a href="${pageContext.request.contextPath}/deptBoardOne?postId=${one.bo.postId}"
                   class="btn btn-secondary">
                    상세보기
                </a>
            </div>
        </div>

        <div class="card">
            <form id="boardForm"
                  method="post"
                  action="${pageContext.request.contextPath}/deptBoardModify">

                <input type="hidden" name="postId" value="${one.bo.postId}">

                <!-- 카테고리 -->
                <div class="board-form-row" style="margin-bottom:14px;">
                    <label class="board-form-label">카테고리</label>
                    <select name="category" class="board-form-input">
                        <option ${one.bo.category=='공지'  ? 'selected' : ''}>공지</option>
                        <option ${one.bo.category=='질문' ? 'selected' : ''}>질문</option>
                        <option ${one.bo.category=='기타' ? 'selected' : ''}>기타</option>
                    </select>
                </div>

                <!-- 제목 -->
                <div class="board-form-row" style="margin-bottom:14px;">
                    <label class="board-form-label">제목</label>
                    <input type="text"
                           name="title"
                           value="${one.bo.title}"
                           class="board-form-input"
                           required>
                </div>

                <!-- 작성/수정일 -->
                <div class="board-form-row" style="margin-bottom:14px; font-size:13px; color:#6b7280;">
                    <c:if test="${empty one.bo.updatedate}">
                        <div>작성날짜 : ${one.bo.createdate}</div>
                    </c:if>
                    <c:if test="${not empty one.bo.updatedate}">
                        <div>수정날짜 : ${one.bo.updatedate}</div>
                    </c:if>
                </div>

                <!-- 내용 -->
                <div class="board-form-row" style="margin-bottom:14px;">
                    <label class="board-form-label">내용</label>
                    <textarea name="content"
                              rows="10"
                              class="board-form-textarea"
                              required>${one.bo.content}</textarea>
                </div>

                <!-- 첨부파일 목록/추가 -->
                <div class="board-form-row" style="margin-bottom:18px;">
                    <label class="board-form-label">첨부파일</label>

                    <!-- 기존 파일 목록 -->
                    <ul id="fileList" class="board-files-old-list" style="margin:0 0 10px 0; padding-left:0; list-style:none;">
                        <c:forEach var="fl" items="${one.fl}">
                            <li class="board-file-item">
                                <span class="board-file-icon">📎</span>
                                <span class="board-file-link">${fl.originName}</span>
                                <span class="board-file-delete">
                                    <button type="button"
                                            class="deleteBtn"
                                            data-file-id="${fl.fileId}"
                                            style="border:none; background:none; font-size:12px; cursor:pointer;">
                                        삭제
                                    </button>
                                </span>
                            </li>
                        </c:forEach>
                    </ul>

                    <!-- 드래그&드롭 영역 -->
                    <div id="dropZone"
                         class="file-dropzone"
                         style="max-width: 420px; margin-top:8px;">
                        파일을 드래그하거나 클릭하여 업로드하세요.
                    </div>
                    <input type="file" id="uploadFile" multiple style="display:none;">
                </div>

                <!-- 버튼 -->
                <div class="board-detail-footer">
                    <button type="button" id="saveBtn" class="btn btn-primary">
                        저장
                    </button>
                    <a href="${pageContext.request.contextPath}/deptBoardOne?postId=${one.bo.postId}"
                       class="btn btn-secondary">
                        취소
                    </a>
                </div>

            </form>
        </div>

    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    let deletedFileIds = [];

    // 기존/임시 파일 삭제 버튼
    $('#fileList').on('click', '.deleteBtn', function(e) {
        const btn = $(e.target);
        const li  = btn.closest('li');

        // 업로드 후 아직 저장되지 않은 임시 파일 삭제
        if (btn.data('temp-file-id')) {
            const tempFileId = btn.data('temp-file-id');
            $.ajax({
                url: "/rest/deleteFile",
                type: "post",
                data: { tempFileId: tempFileId },
                success: function() {
                    console.log("임시파일 삭제 완료:", tempFileId);
                },
                error: function() {
                    console.warn("임시파일 삭제 실패:", tempFileId);
                }
            });
            $("#uploadedFile" + tempFileId).remove();
            $("#uploadedFileName" + tempFileId).remove();
        }

        // DB에 이미 있는 파일 삭제 예정 목록에 추가
        if (btn.data('file-id')) {
            const fileId = btn.data('file-id');
            deletedFileIds.push(fileId);
        }

        li.remove();
    });

    // 드래그&드롭 업로드
    $('#dropZone').on('dragover', function(e) {
        e.preventDefault();
        $('#dropZone').addClass('dragover');
    });

    $('#dropZone').on('dragleave', function() {
        $('#dropZone').removeClass('dragover');
    });

    $('#dropZone').on('drop', function(e) {
        e.preventDefault();
        $('#dropZone').removeClass('dragover');

        const files = e.originalEvent.dataTransfer.files;
        for (let i = 0; i < files.length; i++) {
            uploadFile(files[i]);
        }
    });

    // 클릭해서 파일 선택
    $('#dropZone').on('click', function() {
        $('#uploadFile').click();
    });

    $('#uploadFile').on('change', function(e) {
        const files = e.target.files;
        for (let i = 0; i < files.length; i++) {
            uploadFile(files[i]);
        }
    });

    function uploadFile(file) {
        const formData = new FormData();
        formData.append("uploadFile", file);

        $.ajax({
            url: "/rest/uploadFile",
            type: "post",
            data: formData,
            contentType: false,
            processData: false,
            success: function(data) {
                if (data.success) {
                    const li = $('<li class="board-file-item">')
                        .append('<span class="board-file-icon">📎</span>')
                        .append('<span class="board-file-link">' + file.name + '</span>');

                    const btn = $('<button>')
                        .text('삭제')
                        .attr('type', 'button')
                        .addClass('deleteBtn')
                        .data('temp-file-id', data.tempFileId)
                        .css({ border: 'none', background: 'none', fontSize: '12px', cursor: 'pointer' });

                    li.append($('<span class="board-file-delete">').append(btn));
                    $('#fileList').append(li);

                    // hidden input(임시파일 id/이름)
                    const inputId = $('<input>', {
                        type: 'hidden',
                        name: 'uploadedFileIds',
                        id: 'uploadedFile' + data.tempFileId,
                        value: data.tempFileId
                    });

                    const inputName = $('<input>', {
                        type: 'hidden',
                        name: 'uploadedFileNames',
                        id: 'uploadedFileName' + data.tempFileId,
                        value: file.name
                    });

                    $('#boardForm').append(inputId, inputName);
                } else {
                    alert('업로드 실패');
                }
            },
            error: function() {
                alert('업로드 중 오류가 발생했습니다.');
            }
        });
    }

    // 저장 버튼
    $('#saveBtn').on('click', function() {
        // 삭제 예정 파일 hidden input 추가
        deletedFileIds.forEach(function(fileId) {
            $('#boardForm').append($('<input>', {
                type: 'hidden',
                name: 'deletedFileIds',
                value: fileId
            }));
        });

        $('#boardForm').submit();
    });
</script>

</body>
</html>
