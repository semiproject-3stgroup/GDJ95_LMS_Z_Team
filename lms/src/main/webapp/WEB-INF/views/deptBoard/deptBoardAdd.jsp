<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>학과 게시판 글쓰기</title>

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
                <h1 class="page-title">학과 게시판 글쓰기</h1>
                <p class="board-subtitle" style="margin:4px 0 0; font-size:13px; color:#6b7280;">
                    학과 공지 및 안내 글을 작성합니다.
                </p>
            </div>

            <div class="page-header-actions">
                <a href="${pageContext.request.contextPath}/deptBoard"
                   class="btn btn-secondary">
                    목록으로
                </a>
            </div>
        </div>

        <!-- 글쓰기 폼 -->
        <div class="card">
            <form method="post"
                  enctype="multipart/form-data"
                  action="${pageContext.request.contextPath}/deptBoardAdd">

                <!-- 제목 -->
                <div class="board-form-row" style="margin-bottom:14px;">
                    <label for="title" class="board-form-label">제목</label>
                    <input name="title"
                           id="title"
                           type="text"
                           class="board-form-input"
                           placeholder="제목을 입력하세요."
                           required>
                </div>

                <!-- 카테고리 -->
                <div class="board-form-row" style="margin-bottom:14px;">
                    <label for="category" class="board-form-label">카테고리</label>
                    <select name="category"
                            id="category"
                            class="board-form-input"
                            required>
                        <option value="" selected disabled hidden>선택하세요</option>
                        <option value="공지">공지</option>
                        <option value="질문">질문</option>
                        <option value="기타">기타</option>
                    </select>
                </div>

                <!-- 내용 -->
                <div class="board-form-row" style="margin-bottom:14px;">
                    <label for="content" class="board-form-label">내용</label>
                    <textarea name="content"
                              id="content"
                              rows="10"
                              class="board-form-textarea"
                              placeholder="게시글 내용을 입력하세요."
                              required></textarea>
                </div>

                <!-- 첨부파일 -->
                <div class="board-form-row" style="margin-bottom:18px;">
                    <label class="board-form-label">첨부파일</label>
                    <input type="file"
                           name="boardDeptFile"
                           multiple
                           class="board-form-input">
                </div>

                <!-- 버튼 -->
                <div class="board-detail-footer">
                    <button type="button"
                            id="submitBtn"
                            class="btn btn-primary">
                        등록
                    </button>
                    <a href="${pageContext.request.contextPath}/deptBoard"
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
    $('#submitBtn').on('click', function() {
        if (confirm('등록하시겠습니까?')) {
            $('form').submit();
        }
    });
</script>

</body>
</html>
