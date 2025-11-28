<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>LMS &gt; 질문 게시판 &gt; 수정</title>
  <style>
    /* CSS는 qnaOne.jsp와 동일하게 유지됩니다. (생략) */
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
    .topbar-right{display:flex;align-items:center;gap:16px;}
    .user-menu{cursor:pointer;color:#9ca3af;font-size:14px;transition:color 0.2s;text-decoration:none;}
    .user-menu:hover{color:#ffffff;}
    .main-content{flex-grow:1;display:flex;}
    .sidebar{width:250px;background:#ffffff;padding:24px;box-shadow:2px 0 4px rgba(0,0,0,0.05);}
    .course-nav h3{font-size:16px;font-weight:700;margin-bottom:12px;color:#1d4ed8;}
    .course-nav ul{list-style:none;padding-left:0;margin-bottom:24px;}
    .course-nav li a{display:block;padding:8px 12px;font-size:14px;color:#374151;text-decoration:none;border-radius:6px;transition:background 0.2s;}
    .course-nav li a:hover, .course-nav li a.active{background:#eff6ff;color:#1d4ed8;}
    .main{flex-grow:1;padding:24px;background:#f9fafb;}
    .page-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:24px;}
    .page-title{font-size:24px;font-weight:700;color:#111827;}
    .page-actions a, .page-actions button{padding:8px 16px;font-size:14px;font-weight:600;border-radius:6px;text-decoration:none;cursor:pointer;transition:all 0.2s;border:1px solid transparent;}
    .btn-primary{background:#1d4ed8;color:#ffffff;border-color:#1d4ed8;}
    .btn-primary:hover{background:#1e40af;}
    .btn-sm{padding:6px 12px;font-size:12px;font-weight:600;border-radius:4px;text-decoration:none;cursor:pointer;transition:all 0.2s;border:1px solid transparent;}
    .btn-outline{background:#ffffff;color:#4b5563;border-color:#d1d5db;}
    .btn-outline:hover{background:#f3f4f6;}
    .btn-outline-primary{background:#ffffff;color:#1d4ed8;border-color:#1d4ed8;}
    .btn-outline-primary:hover{background:#eff6ff;}
    .qna-form-container{background:#ffffff;padding:24px;border-radius:8px;box-shadow:0 1px 3px rgba(0,0,0,0.1);}
    .field-row{margin-bottom:16px;}
    .field-label{display:block;font-size:14px;font-weight:600;color:#374151;margin-bottom:6px;}
    .input, textarea{width:100%;padding:10px 12px;border:1px solid #d1d5db;border-radius:6px;font-size:16px;color:#111827;}
    textarea{resize:vertical;}
    .input[readonly]{background-color:#f3f4f6;}
    .btn-row{display:flex;justify-content:flex-end;gap:12px;margin-top:24px;}
    .footer{background:#374151;color:#d1d5db;padding:24px 0;font-size:12px;}
    .footer-inner{max-width:1200px;margin:0 auto;display:flex;justify-content:space-around;}
    .footer-item{margin:0 10px;}
    .error-message{color: #ef4444; font-weight: 600; margin-bottom: 12px;}
  </style>
</head>
<body>
  <div class="app">
    <header class="topbar">
        <div class="topbar-left">
            <div class="logo"></div>
            <span class="topbar-title">LMS 학사관리 시스템</span>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/logout" class="user-menu">로그아웃 (${sessionScope.loginUser.userName})</a>
        </div>
    </header>

    <div class="main-content">
      <aside class="sidebar">
          <nav class="course-nav">
              <h3>내 강의 목록</h3>
              <ul>
                  <c:forEach var="course" items="${myCourses}">
                      <li><a href="${pageContext.request.contextPath}/qna/list/${course.courseId}" class="${course.courseId == courseId ? 'active' : ''}">${course.courseName}</a></li>
                  </c:forEach>
              </ul>
          </nav>
      </aside>

      <main class="main">
          <div class="page-header">
              <h2 class="page-title">질문 게시판 수정</h2>
          </div>

          <c:if test="${param.error == 'unauthorized'}">
              <div class="error-message">권한이 없습니다. 해당 게시글의 작성자만 수정할 수 있습니다.</div>
          </c:if>

          <section class="qna-form-container">
              <form action="${pageContext.request.contextPath}/qna/modify/${courseId}/${qnaPost.postId}" method="post">
                  <%-- Hidden 필드: postId는 URL에 있으나, ModelAttribute 바인딩을 위해 DTO에 필요할 수 있음 (Controller에서 처리할 예정) --%>
                  <input type="hidden" name="courseId" value="${courseId}">
                  <input type="hidden" name="postId" value="${qnaPost.postId}">
                  <input type="hidden" name="userId" value="${currentUserId}">

                  <div class="field-row">
                      <label class="field-label">게시글 번호</label>
                      <input type="text" class="input" value="${qnaPost.postId}" readonly>
                  </div>

                  <div class="field-row">
                      <label class="field-label">작성자</label>
                      <input type="text" class="input" value="${qnaPost.userName} (ID: ${qnaPost.userId})" readonly>
                  </div>

                  <div class="field-row">
                      <label for="title" class="field-label">제목</label>
                      <input type="text" id="title" name="title" class="input" placeholder="제목을 입력하세요." value="${qnaPost.title}" required>
                  </div>

                  <div class="field-row">
                      <label for="content" class="field-label">내용</label>
                      <textarea id="content" name="content" rows="10" placeholder="내용을 입력하세요." required>${qnaPost.content}</textarea>
                  </div>

                  <div class="field-row">
                      <label class="field-label">첨부파일</label>
                      <%-- TODO: 파일 수정 로직 추가 필요 --%>
                      <input type="file" class="input">
                  </div>

                  <div class="btn-row">
                      <a href="${pageContext.request.contextPath}/qna/one/${courseId}/${qnaPost.postId}" class="btn-sm">취소</a>
                      <button type="submit" class="btn-sm btn-primary">수정 완료</button>
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