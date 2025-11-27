<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>LMS &gt; 질문 게시판 &gt; 상세</title>
    <style>
        /* CSS는 HTML 파일과 동일하게 유지됩니다. */
        *{margin:0;padding:0;box-sizing:border-box;}
        body{
            font-family:system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;
            background:#f3f4f6;color:#111827;
        }
        .app{min-height:100vh;display:flex;flex-direction:column;}
        .topbar{
            height:60px;background:#111827;color:#f9fafb;
            display:flex;align-items:center;justify-content:space-between;
            padding:0 24px;box-shadow:0 2px 4px rgba(0,0,0,0.12);
        }
        .topbar-left{display:flex;align-items:center;gap:12px;}
        .logo{width:32px;height:32px;border-radius:8px;background:linear-gradient(135deg,#22c55e,#0ea5e9);}
        .topbar-title{font-size:18px;font-weight:600;}
        .topbar-right{display:flex;align-items:center;gap:16px;font-size:13px;}
        .avatar{width:32px;height:32px;border-radius:999px;background:#4b5563;}
        .logout-btn{padding:6px 12px;border-radius:6px;background:#dc2626;color:#fff;border:none;font-size:13px;cursor:pointer;}
        .logout-btn:hover{background:#b91c1c;}

        .layout{display:flex;flex:1;}
        .sidebar{
            width:220px;background:#111827;color:#9ca3af;
            padding:16px 12px;border-right:1px solid #1f2937;
            display:flex;flex-direction:column;gap:4px;
        }
        .sidebar-section-title{font-size:12px;text-transform:uppercase;color:#6b7280;margin:12px 8px 6px;letter-spacing:0.08em;}
        .nav-item{padding:8px 10px;border-radius:8px;font-size:14px;color:#fff;display:flex;align-items:center;gap:8px;cursor:pointer;}
        .nav-item.active{background:#16a34a;color:#e5e7eb;}
        .nav-dot{width:6px;height:6px;border-radius:999px;background:#4b5563;}
        .nav-item.active .nav-dot{background:#bbf7d0;}
        .content{flex:1;padding:24px 32px 32px;display:flex;flex-direction:column;gap:16px;}

        /* 페이지 전용 */
        .breadcrumb{font-size:13px;color:#9ca3af;}
        .page-title-lg{font-size:20px;font-weight:600;margin-top:4px;}
        .page-subtitle{font-size:14px;margin-top:2px;color:#6b7280;}

        .card{
            margin-top:20px;
            background:#fff;
            border-radius:12px;
            padding:24px 28px;
            box-shadow:0 1px 3px rgba(15,23,42,0.06);
        }
        
        /* 상세 페이지 스타일 추가 */
        .detail-header{
            padding-bottom:15px;
            border-bottom:1px solid #e5e7eb;
            margin-bottom:20px;
        }
        .detail-title{
            font-size:24px;
            font-weight:700;
            color:#111827;
            margin-bottom:8px;
        }
        .detail-meta{
            display:flex;
            gap:20px;
            font-size:13px;
            color:#6b7280;
        }
        .detail-content{
            min-height: 200px;
            padding: 20px 0;
            font-size:16px;
            line-height:1.6;
            white-space: pre-wrap; /* 줄바꿈 유지 */
        }
        
        .btn-row{
            display:flex;
            justify-content:flex-end;
            gap:8px;
            margin-top:24px;
            padding-top: 15px;
            border-top: 1px solid #f3f4f6;
        }
        .btn-sm{
            padding:8px 16px;
            border-radius:6px;
            font-size:14px;
            border:1px solid #d1d5db;
            background:#fff;
            cursor:pointer;
            text-decoration: none;
            color: inherit;
            display: inline-flex;
            align-items: center;
        }
        .btn-primary{
            border-color:#22c55e;
            background:#22c55e;
            color:#fff;
        }
        .btn-sm:hover{background:#f3f4f6;}
        .btn-primary:hover{background:#16a34a;}

        .footer{margin-top:24px;background:#111827;color:#e5e7eb;padding:18px 0;font-size:13px;}
        .footer-inner{max-width:1200px;margin:0 auto;display:flex;justify-content:space-around;flex-wrap:wrap;gap:10px;}
        .footer-item strong{color:#f9fafb;}
    </style>
</head>
<body>
    <div class="app">
        <header class="topbar">
            <div class="topbar-left">
                <div class="logo"></div>
                <div class="topbar-title">LMS 학사관리 시스템</div>
            </div>
            <div class="topbar-right">
                <div class="avatar"></div>
                <c:if test="${not empty sessionScope.loginUser}">
                    <div>
                        <div style="font-size:13px;">${sessionScope.loginUser.userName}님 반갑습니다</div>
                        <div style="font-size:11px;color:#9ca3af;">${sessionScope.loginUser.role}</div>
                    </div>
                </c:if>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn" style="text-decoration:none;">로그아웃</a>
            </div>
        </header>

        <div class="layout">

            <aside class="sidebar">
                <div class="sidebar-section-title">내 강의</div>
                <c:forEach var="course" items="${myCourses}">
                    <a href="${pageContext.request.contextPath}/qna/list/${course.courseId}"
                       class="nav-item <c:if test="${course.courseId == courseId}">active</c:if>" style="text-decoration:none;">
                        <div class="nav-dot"></div>
                        <span>${course.courseName}</span>
                    </a>
                </c:forEach>
                <c:if test="${empty myCourses}">
                    <div class="nav-item" style="cursor: default;">
                        <div class="nav-dot"></div>수강 중인 강의가 없습니다.
                    </div>
                </c:if>

                <div class="sidebar-section-title">강의 메뉴</div>
                <a href="${pageContext.request.contextPath}/assignment/list/${courseId}" class="nav-item" style="text-decoration:none;">
                    <div class="nav-dot"></div>과제
                </a>
                <a href="${pageContext.request.contextPath}/exam/list/${courseId}" class="nav-item" style="text-decoration:none;">
                    <div class="nav-dot"></div>시험/성적
                </a>
                <a href="${pageContext.request.contextPath}/qna/list/${courseId}" class="nav-item active" style="text-decoration:none;">
                    <div class="nav-dot"></div>질문 게시판
                </a>

                <a
                href="${pageContext.request.contextPath}/logout"
                    style="margin-top:auto;padding:10px;font-size:12px;color:#9ca3af;text-decoration:none;">
                    ◀ Log Out
                </a>
            </aside>

            <main class="content">
                <div class="breadcrumb">
                    ${currentCourseName} &gt; 질문 게시판 &gt; 상세 보기
                </div>
                <h1 class="page-title-lg">질문 게시글 상세</h1>
                <p class="page-subtitle">작성된 게시글의 내용을 확인하고 답변을 남길 수 있습니다.</p>

                <c:if test="${empty qnaPost}">
                    <section class="card" style="text-align: center;">
                        <p style="color: #ef4444; font-weight: 600;">요청한 게시글을 찾을 수 없습니다.</p>
                        <div class="btn-row" style="border-top: none;">
                            <a href="${pageContext.request.contextPath}/qna/list/${courseId}" class="btn-sm">목록으로</a>
                        </div>
                    </section>
                </c:if>

                <c:if test="${not empty qnaPost}">
                    <section class="card">
                        <div class="detail-header">
                            <h2 class="detail-title">${qnaPost.title}</h2>
                            <div class="detail-meta">
                                <span>작성자: ${qnaPost.userName}</span>
                                <span>작성일: ${qnaPost.formattedCreatedate}</span>
                                <c:if test="${qnaPost.updatedate != null}">
                                    <span>(수정일: ${qnaPost.formattedUpdatedate})</span>
                                </c:if>
                                <span>조회수: ${qnaPost.hitCount}</span>
                            </div>
                        </div>
                        
                        <div class="detail-content">
                            <p>${qnaPost.content}</p>
                        </div>
                        
                        <div class="btn-row">
                            <a href="${pageContext.request.contextPath}/qna/list/${courseId}" class="btn-sm">
                                목록
                            </a>

                            <%-- qnaPost.userId: DB에서 가져온 게시글 작성자 ID --%>
                            <%-- currentUserId: Controller에서 Model에 담아준 현재 로그인 사용자 ID --%>
                            <c:if test="${qnaPost.userId == currentUserId}">
                                <a href="${pageContext.request.contextPath}/qna/modifyForm/${courseId}/${qnaPost.postId}" class="btn-sm btn-primary">수정</a>
                                
                                <form action="${pageContext.request.contextPath}/qna/delete/${courseId}/${qnaPost.postId}" method="post" onsubmit="return confirm('정말로 게시글을 삭제하시겠습니까?');" style="display:inline;">
                                    <button type="submit" class="btn-sm" style="background: #ef4444; color: #fff; border: none;">삭제</button>
                                </form>
                            </c:if>
                        </div>
                    </section>

                    <%-- TODO: 댓글 목록 및 작성 영역 구현 --%>
                </c:if>
            </main>
        </div>

        <footer class="footer">
            <div class="footer-inner">
                <div class="footer-item"><strong>문의:</strong> 학사관리운영팀</div>
                <div class="footer-item"><strong>전화:</strong> 02-1234-5678</div>
                <div class="footer-item"><strong>Email:</strong> lms@university.ac.kr</div>
                <div class="footer-item"><strong>주소:</strong> 서울특별시 OO구 OO</div>
            </div>
        </footer>
    </div>
</body>
</html>