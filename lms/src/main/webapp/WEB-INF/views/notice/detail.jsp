<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지 상세</title>
    <link rel="stylesheet" href="/css/layout.css">
</head>
<body>

    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">
        <main class="content">
            <div class="page-header">
			    <h1>공지사항 상세</h1>
			
			    <div style="margin-left:auto;">
			
			        <c:if test="${not empty sessionScope.loginUser 
			                     and sessionScope.loginUser.userId == notice.userId}">
			            <a href="/notice/edit?noticeId=${notice.noticeId}" class="btn btn-secondary">수정</a>
			
			            <form action="/notice/delete" method="post" style="display:inline;"
			                  onsubmit="return confirm('정말 삭제할까요? 복구할 수 없습니다.');">
			                <input type="hidden" name="noticeId" value="${notice.noticeId}">
			                <input type="hidden" name="page" value="${currentPage}">
			                <button type="submit" class="btn btn-danger">삭제</button>
			            </form>
			        </c:if>
			
			    </div>
			</div>

            <div class="card" style="padding: 16px;">
                <h2 style="margin-top:0;">${notice.title}</h2>

                <div style="font-size: 14px; color:#555; margin-bottom:12px;">
                    <span>작성자: ${notice.writerName}</span>
                    <span style="margin-left:16px;">조회수: ${notice.hitCount}</span>
                    <span style="margin-left:16px;">작성일: ${notice.createdate}</span>
                </div>

                <hr/>

                <div style="min-height:150px; white-space:pre-wrap;">
                    ${notice.content}
                </div>
            </div>

            <div style="margin-top:16px;">
                <a href="/notice/list?page=${currentPage}
   					     &searchType=${searchType}
   					     &searchWord=${searchWord}" class="btn btn-light">
                    목록으로
                </a>
            </div>
        </main>
    </div>

</body>
</html>
