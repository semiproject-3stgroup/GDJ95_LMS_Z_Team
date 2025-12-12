<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>학과별 게시판</title>

    <!-- CSS 로딩 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <style>
        /* 학과 게시판 상세 전용 살짝 보완 */

        .board-detail-card {
            margin-top: 8px;
        }

        .board-detail-header {
            margin-bottom: 14px;
        }

        .board-category-pill {
            display: inline-flex;
            align-items: center;
            padding: 3px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
            background-color: #eef2ff;
            color: #4338ca;
            margin-bottom: 8px;
        }

        .board-detail-title {
            margin: 0 0 6px;
            font-size: 22px;
            font-weight: 700;
            color: #111827;
        }

        .board-detail-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            font-size: 13px;
            color: #6b7280;
        }

        .board-detail-body {
            padding-top: 14px;
            border-top: 1px solid #e5e7eb;
            font-size: 14px;
            color: #111827;
            white-space: pre-wrap;
            min-height: 180px;
        }

        .board-detail-files {
            margin-top: 16px;
            font-size: 13px;
        }

        .board-detail-files ul {
            margin: 6px 0 0 18px;
            padding: 0;
        }

        .board-detail-files li + li {
            margin-top: 3px;
        }

        .board-detail-actions {
            margin-top: 16px;
            display: flex;
            justify-content: flex-end;
            gap: 8px;
        }

        /* 댓글 카드 */
        .board-comment-card {
            margin-top: 18px;
        }

        .board-comment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }

        .board-comment-title {
            margin: 0;
            font-size: 16px;
            font-weight: 600;
            color: #111827;
        }

        .board-comment-input {
            margin-top: 10px;
            display: flex;
            gap: 8px;
            align-items: flex-start;
        }

        .board-comment-input textarea {
            flex: 1;
            min-height: 80px;
        }

        .board-comment-table td {
            padding: 6px 4px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 13px;
        }

        .board-comment-meta {
            font-size: 12px;
            color: #6b7280;
            margin-bottom: 4px;
        }

        .board-comment-content {
            font-size: 13px;
            color: #111827;
        }

        .board-comment-empty {
            font-size: 13px;
            color: #9ca3af;
            padding: 10px 0;
        }

    </style>
</head>
<body class="board-page dept-page">

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">

    <!-- 왼쪽 사이드바 -->
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">

        <!-- 페이지 헤더 -->
        <div class="page-header">
            <h1 class="page-title">학과별 게시판</h1>

            <div class="page-header-actions">
                <a href="${pageContext.request.contextPath}/deptBoard" class="btn btn-secondary">
                    목록
                </a>
            </div>
        </div>

        <!-- 글 상세 카드 -->
        <div class="card board-detail-card">

            <div class="board-detail-header">
                <span class="board-category-pill">
                    ${one.bo.category}
                </span>

                <h2 class="board-detail-title">
                    ${one.bo.title}
                </h2>

                <div class="board-detail-meta">
                    <span>작성자
                        <strong>
                            <c:out value="${one.bo.userName}" />
                        </strong>
                    </span>

                    <c:choose>
                        <c:when test="${empty one.bo.updatedate}">
                            <span>작성일 ${one.bo.createdate}</span>
                        </c:when>
                        <c:otherwise>
                            <span>수정일 ${one.bo.updatedate}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- 첨부파일 -->
            <c:if test="${not empty one.fl}">
                <div class="board-detail-files">
                    <strong>첨부 파일</strong>
                    <ul>
                        <c:forEach var="fl" items="${one.fl}">
                            <li>
                                <a href="${pageContext.request.contextPath}/upload/${fl.fileName}.${fl.fileExtension}"
                                   download="${fl.originName}.${fl.fileExtension}">
                                    ${fl.originName}.${fl.fileExtension}
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <!-- 본문 내용 -->
            <div class="board-detail-body">
                ${one.bo.content}
            </div>

            <!-- 수정/삭제 버튼 -->
			<c:if test="${one.bo.userId == userId}">
			    <div class="board-detail-actions">
			        <form id="detailForm">
			            <input type="hidden" name="postId" value="${one.bo.postId}">
			            <button type="button" id="modifyBtn" class="btn btn-secondary">수정</button>
			            <button type="button" id="deleteBtn" class="btn btn-danger">삭제</button>
			        </form>
			    </div>
			</c:if>
			
			<!-- (소유자가 아닌 경우에도 postId는 필요하면 따로 hidden 유지해도 되고) -->
			<c:if test="${one.bo.userId != userId}">
			    <input type="hidden" name="postId" value="${one.bo.postId}">
			</c:if>

            <!-- 글 번호 (댓글 스크립트용, 폼 밖에서도 쓰이게 숨김) -->
            <c:if test="${one.bo.userId != userId}">
                <input type="hidden" name="postId" value="${one.bo.postId}">
            </c:if>
        </div>

        <!-- 댓글 영역 -->
        <div class="card board-comment-card">
            <div class="board-comment-header">
                <h3 class="board-comment-title">댓글</h3>
            </div>

            <div id="commentsArea"></div>

            <div id="addComment" class="board-comment-input">
                <textarea id="commentContent"
                          class="board-form-textarea"
                          placeholder="댓글을 입력하세요."></textarea>
                <button type="button" id="addCommentBtn" class="btn btn-primary">
                    저장
                </button>
            </div>
        </div>

    </main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    $(() => {
        const postId = $('input[name="postId"]').val();
        commentTable(postId);
    });

    $(() => {
        const postId = $('input[name="postId"]').val();
        commentTable(postId);

        // 수정 버튼: 수정 폼으로 이동
        $('#modifyBtn').on('click', () => {
            const postId = $('input[name="postId"]').val();
            location.href = '${pageContext.request.contextPath}/deptBoardModify?postId=' + postId;
        });

        // 삭제 버튼: confirm 후 삭제 요청
        $('#deleteBtn').on('click', () => {
            if (!confirm('삭제하시겠습니까?')) return;

            $('#detailForm')
                .attr('method', 'get') // 컨트롤러가 @GetMapping("/deptBoardRemove") 이니까 GET
                .attr('action', '${pageContext.request.contextPath}/deptBoardRemove')
                .submit();
        });
    });

    $('#addCommentBtn').click(() => {
        const postId = $('input[name="postId"]').val();
        const content = $('#commentContent').val();

        if (!content.trim()) {
            alert('댓글 내용을 입력하세요.');
            return;
        }

        addComment(postId, content);
    });

    $(document).on('click', '.removeCommentBtn', function () {
        const commentId = $(this).data('commentId');
        const postId = $('input[name="postId"]').val();

        if (!confirm('댓글을 삭제하시겠습니까?')) return;

        $.ajax({
            url: '${pageContext.request.contextPath}/rest/removeComment',
            data: { commentId: commentId },
            success: () => {
                commentTable(postId);
            },
            error: () => {
                alert('댓글 삭제 실패');
            }
        });
    });

    function commentTable(postId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/rest/comment',
            data: { postId: postId },
            success: (data) => {
                const cArea = $('#commentsArea');
                const loginUserId = ${userId};
                let html = '';

                if (!data || data.length === 0) {
                    html += '<div class="board-comment-empty">등록된 댓글이 없습니다.</div>';
                } else {
                    html += '<table class="table board-comment-table">';

                    data.forEach(item => {
                        html += `
                            <tr>
                                <td>
                                    <div class="board-comment-meta">
                                        <strong>\${item.userName}</strong>
                                        &nbsp;|&nbsp;
                                        <span>\${item.createdate}</span>
                                    </div>
                                    <div class="board-comment-content">
                                        \${item.content}
                                    </div>
                                </td>
                                <td style="width: 70px; text-align: right; vertical-align: top;">
                        `;

                        if (item.userId === loginUserId) {
                            html += `
                                    <button type="button"
                                            class="btn btn-secondary removeCommentBtn"
                                            data-comment-id="\${item.commentId}">
                                        삭제
                                    </button>
                            `;
                        }

                        html += `
                                </td>
                            </tr>
                        `;
                    });

                    html += '</table>';
                }

                cArea.html(html);
            },
            error: () => {
                alert('댓글 불러오기 실패');
            }
        });
    }

    function addComment(postId, content) {
        $.ajax({
            url: '${pageContext.request.contextPath}/rest/addComment',
            type: 'post',
            data: {
                postId: postId,
                content: content
            },
            success: () => {
                commentTable(postId);
                $('#commentContent').val('');
            },
            error: () => {
                alert('댓글 저장 실패');
            }
        });
    }
</script>
</body>
</html>
