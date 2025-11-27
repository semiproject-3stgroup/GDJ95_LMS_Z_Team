<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>LMS &gt; 질문 게시판 &gt; 글쓰기</title>
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
    /* a 태그를 위한 스타일 추가 */
    .nav-item{padding:8px 10px;border-radius:8px;font-size:14px;display:flex;align-items:center;gap:8px;cursor:pointer; text-decoration: none; color: inherit;}
    .nav-item.active{background:#16a34a;color:#fff !important;}
    .nav-dot{width:6px;height:6px;border-radius:999px;background:#4b5563;}
    .nav-item.active .nav-dot{background:#bbf7d0;}
    .content{flex:1;padding:24px 32px 32px;display:flex;flex-direction:column;gap:16px;}

    .footer{margin-top:24px;background:#111827;color:#e5e7eb;padding:18px 0;font-size:13px;}
    .footer-inner{max-width:1200px;margin:0 auto;display:flex;justify-content:space-around;flex-wrap:wrap;gap:10px;}
    .footer-item strong{color:#f9fafb;}

    @media(max-width:1024px){
      .layout{flex-direction:column;}
      .sidebar{display:none;}
      .content{padding:16px;}
    }
    /* 페이지 전용 */
    .breadcrumb{font-size:13px;color:#9ca3af;}
    .page-title-lg{font-size:20px;font-weight:600;margin-top:4px;}

    .form-card{      
        margin-top:20px;      
        background:#fff;      
        border-radius:12px;      
        padding:20px 22px;      
        box-shadow:0 1px 3px rgba(15,23,42,0.06);      
        max-width:800px;    
    }
    .field-row{      
        margin-bottom:12px;      
        font-size:13px;    
    }
    .field-label{      
        display:block;      
        margin-bottom:4px;      
        font-weight:500;      
        color:#4b5563;    
    }
    .input,.select,textarea{      
        width:100%;      
        padding:8px 10px;      
        border-radius:8px;      
        border:1px solid #e5e7eb;      
        font-size:13px;      
        font-family:inherit;      
        resize:vertical;    
    }
    .input:focus,.select:focus,textarea:focus{      
        outline:none;      
        border-color:#22c55e;      
        box-shadow:0 0 0 1px rgba(34,197,94,0.2);    
    }

    .btn-row{      
        margin-top:18px;      
        display:flex;      
        justify-content:flex-end;      
        gap:8px;    
    }
    /* a 태그에 버튼 스타일 적용을 위해 display: inline-block 추가 */
    .btn-sm{      
        min-width:70px;      
        padding:7px 16px;      
        border-radius:4px;      
        border:1px solid #d1d5db;      
        background:#fff;      
        font-size:13px;      
        cursor:pointer;    
        text-decoration: none; 
        text-align: center;
        display: inline-block;
    }
    .btn-primary{      
        border-color:#22c55e;      
        background:#22c55e;      
        color:#fff;    
    }
    .btn-sm:hover{background:#f3f4f6;}
    .btn-primary:hover{background:#16a34a;}
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
      <%-- 로그인한 사용자 정보 표시 --%>
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
	      <%-- 수강 중인 강의 목록 동적 표시 --%>
	      <c:forEach var="course" items="${myCourses}">
	        <a href="${pageContext.request.contextPath}/qna/list/${course.courseId}"
	           class="nav-item <c:if test="${course.courseId == courseId}">active</c:if>" style="text-decoration:none; color:inherit;">
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
	      <a href="${pageContext.request.contextPath}/assignment/list/${courseId}" class="nav-item" style="text-decoration:none; color:inherit;">
	        <div class="nav-dot"></div>과제
	      </a>
	      <a href="${pageContext.request.contextPath}/exam/list/${courseId}" class="nav-item" style="text-decoration:none; color:inherit;">
	        <div class="nav-dot"></div>시험/성적
	      </a>
	      <a href="${pageContext.request.contextPath}/qna/list/${courseId}" class="nav-item active" style="text-decoration:none; color:inherit;">
	        <div class="nav-dot"></div>질문 게시판
	      </a>
	
	      <a
	      href="${pageContext.request.contextPath}/logout"
	         style="margin-top:auto;padding:10px;font-size:12px;color:#9ca3af;text-decoration:none;">
	        ◀ Log Out
	      </a>
	    </aside>

        <main class="content">
            <div class="breadcrumb">${currentCourseName} &gt; 질문 게시판 &gt; 글쓰기</div>
            <h1 class="page-title-lg">게시글 작성</h1>

            <section class="form-card">
                <form action="${pageContext.request.contextPath}/qna/write/${courseId}" method="post">

                    <input type="hidden" name="userId" value="${currentUserId}" />
                    <input type="hidden" name="courseId" value="${courseId}" />

                    <div class="field-row">
                      <label class="field-label">분류</label>
                      <select class="select">
                        <option>강의 질문</option>
                        <option>과제 질문</option>
                        <option>기타</option>
                      </select>
                    </div>

                    <div class="field-row">
                        <label for="title" class="field-label">제목</label>
                        <input type="text" id="title" name="title" class="input" placeholder="제목을 입력하세요." required>
                    </div>

                    <div class="field-row">
                        <label class="field-label">작성자</label>
                        <input type="text" class="input" value="학생 (ID: ${currentUserId})" readonly>
                    </div>

                    <div class="field-row">
                        <label for="content" class="field-label">내용</label>
                        <textarea id="content" name="content" rows="10" placeholder="내용을 입력하세요." required></textarea>
                    </div>

                    <div class="field-row">
                      <label class="field-label">첨부파일</label>
                      <input type="file" class="input">
                    </div>

                    <div class="btn-row">
                        <a href="${pageContext.request.contextPath}/qna/list/${courseId}" class="btn-sm">취소</a>
                        <button type="submit" class="btn-sm btn-primary">등록</button>
                    </div>
                </form>
            </section>
        </main>
    </div>

    <footer class="footer">
        <div class="footer-inner">
            <div class="footer-item"><strong>문의:</strong> 학사관리운영팀</div>
            <div class="footer-item"><strong>전화:</strong> 02-1234-5678</div>
            <div class="footer-item"><strong>Email:</strong> lms@university.ac.kr</div>
            <div class="footer-item"><strong>주소:</strong> 서울특별시 OO구 OO로 123, OO대학교</div>
        </div>
    </footer>
</div>
</body>
</html>