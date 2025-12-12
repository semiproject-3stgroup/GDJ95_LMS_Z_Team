<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>학과 게시판</title>

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
                <h1 class="page-title">학과 게시판</h1>
                <p class="board-subtitle" style="margin:4px 0 0; font-size:13px; color:#6b7280;">
                    000 학과 게시판입니다.
                </p>
            </div>

            <div class="page-header-actions">
                <a href="${pageContext.request.contextPath}/deptBoardAdd" class="btn btn-primary">
                    글쓰기
                </a>
            </div>
        </div>

        <!-- 한 페이지 줄수 선택 -->
        <div class="board-search-bar">
            <span style="font-size:13px; color:#6b7280;">한 페이지에</span>
            <select class="board-search-select rows-select">
                <option value="10">10</option>
                <option value="20">20</option>
                <option value="50">50</option>
            </select>
            <span style="font-size:13px; color:#6b7280;">줄 표시</span>
        </div>

        <!-- 목록 카드 -->
        <div class="card board-list-card">
            <table class="table board-table">
                <thead>
                <tr>
                    <th>번호</th>
                    <th>카테고리</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>댓글</th>
                </tr>
                </thead>
                <tbody>
                <%-- AJAX 로 채워짐 --%>
                </tbody>
            </table>
        </div>

        <!-- 페이징 -->
        <div class="pagination"><!-- AJAX 로 채움 --></div>

    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    window.onload = function() {
        const rowPerPage = document.querySelector('.rows-select').value;
        boardTable(1, rowPerPage);
    };

    function boardTable(page, rowPerPage) {
        $.ajax({
            url: '/rest/deptBoard',
            method: 'get',
            data: {
                currentPage: page,
                rowPerPage: rowPerPage
            },
            success: function(data) {
                updateTable(data.list);
                updatePagination(data);
            },
            error: function() {
                console.log('error');
            }
        });
    }

    function updateTable(list) {
        const tbody = document.querySelector('.board-table tbody');
        tbody.innerHTML = '';

        if (!list || list.length === 0) {
            tbody.innerHTML =
                '<tr><td colspan="6" class="table-empty">등록된 게시글이 없습니다.</td></tr>';
            return;
        }

        list.forEach(function(item) {
            let row = '';
            row += '<tr>';
            row += '<td class="table-cell-center">' + item.postId + '</td>';
            row += '<td class="table-cell-center">' + (item.category || '') + '</td>';
            row += '<td class="table-cell-title">';
            row += '  <a class="board-title-link" href="' +
                '${pageContext.request.contextPath}/deptBoardOne?postId=' + item.postId + '">';
            row +=      (item.title || '');
            row += '  </a>';
            row += '</td>';
            row += '<td class="table-cell-center">' + (item.userId || '') + '</td>';
            row += '<td class="table-cell-center">' + (item.createdate || '') + '</td>';
            row += '<td class="table-cell-center">' + (item.commentCount || 0) + '</td>';
            row += '</tr>';

            tbody.innerHTML += row;
        });
    }

    function updatePagination(data) {
        const pageArea   = document.querySelector('.pagination');
        const rowPerPage = data.rowPerPage;
        let html = '';

        // 이전
        if (data.beginPage > 1) {
            html += '<a href="#" class="page-link" ' +
                    'onclick="boardTable(' + (data.beginPage - 1) + ',' + rowPerPage + '); return false;">이전</a>';
        }

        // 페이지 번호
        for (let i = data.beginPage; i <= data.endPage; i++) {
            if (i === data.currentPage) {
                html += '<span class="page-link current">' + i + '</span>';
            } else {
                html += '<a href="#" class="page-link" ' +
                        'onclick="boardTable(' + i + ',' + rowPerPage + '); return false;">' + i + '</a>';
            }
        }

        // 다음
        if (data.currentPage < data.lastPage) {
            html += '<a href="#" class="page-link" ' +
                    'onclick="boardTable(' + (data.endPage + 1) + ',' + rowPerPage + '); return false;">다음</a>';
        }

        pageArea.innerHTML = html;
    }

    document.querySelector('.rows-select').addEventListener('change', function(e) {
        boardTable(1, e.target.value);
    });
</script>

</body>
</html>
