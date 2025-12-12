<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>관리자 > 수강신청 설정</title>

  <!-- 공통 CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css" />
</head>

<body class="admin-events-page admin-course-setting-page">

  <%@ include file="/WEB-INF/views/common/header.jsp" %>

  <div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="main-content">

      <!-- 플래시 메시지 -->
      <c:if test="${not empty message}">
        <div class="alert
          <c:choose>
            <c:when test='${messageType eq "error"}'>alert-error</c:when>
            <c:otherwise>alert-success</c:otherwise>
          </c:choose>">
          ${message}
        </div>
      </c:if>

      <!-- 타이틀 -->
      <div class="page-header">
        <div>
          <h1 class="page-title">수강신청 기간 / 수동 열기 설정</h1>
          <c:if test="${not empty year && not empty semester}">
            <div style="font-size:13px; color:#6b7280; margin-top:4px;">
              현재 조회 중인 학기 :
              <strong style="color:#111827;">${year}년 ${semester}</strong>
            </div>
          </c:if>
        </div>
      </div>

      <!-- 1) 학기 선택 -->
      <div class="box" style="margin-bottom:20px;">
        <div class="page-header" style="margin-bottom:12px;">
          <h2 style="margin:0; font-size:16px; font-weight:950;">학기 선택</h2>
          <div class="page-header-actions">
            <span style="font-size:12px; color:#9ca3af;">변경할 학기를 먼저 선택해</span>
          </div>
        </div>

        <form method="get"
              action="${pageContext.request.contextPath}/admin/course-register-setting"
              class="form-grid">

          <div class="form-row two-col">
            <div class="form-row">
              <label class="form-label" for="searchYear">학년도</label>
              <input class="form-input" id="searchYear" type="number" name="year" value="${year}" required />
            </div>

            <div class="form-row">
              <label class="form-label" for="searchSemester">학기</label>
              <select class="form-input" id="searchSemester" name="semester" required>
                <option value="">선택</option>
                <option value="1학기" <c:if test="${semester == '1학기'}">selected</c:if>>1학기</option>
                <option value="2학기" <c:if test="${semester == '2학기'}">selected</c:if>>2학기</option>
              </select>
            </div>
          </div>

          <div class="form-actions">
            <button type="submit" class="btn btn-primary">조회</button>
          </div>
        </form>

        <p class="help-text" style="margin-top:10px; font-size:13px; color:#6b7280;">
          * 설정이 없으면 저장 시 새로운 설정이 생성됩니다.
        </p>
      </div>

      <!-- 2) 기간 설정 -->
      <div class="box" style="margin-bottom:20px;">
        <div class="page-header" style="margin-bottom:12px;">
          <h2 style="margin:0; font-size:16px; font-weight:950;">수강신청 기간 설정</h2>

          <c:if test="${not empty setting}">
            <div class="page-header-actions">
              <span style="font-size:12px; background:#f3f4f6; padding:6px 10px; border-radius:999px; color:#374151;">
                <strong>${setting.year}년 ${setting.semester}</strong> 설정 로드됨
              </span>
            </div>
          </c:if>
        </div>

        <form method="post"
              action="${pageContext.request.contextPath}/admin/course-register-setting/save"
              class="form-grid">

          <input type="hidden" name="settingId" value="${setting.settingId}" />

          <div class="form-row two-col">
            <div class="form-row">
              <label class="form-label">학년도</label>
              <input class="form-input" type="number" name="year" value="${year}" required />
            </div>

            <div class="form-row">
              <label class="form-label">학기</label>
              <select class="form-input" name="semester" required>
                <option value="">선택</option>
                <option value="1학기" <c:if test="${semester == '1학기'}">selected</c:if>>1학기</option>
                <option value="2학기" <c:if test="${semester == '2학기'}">selected</c:if>>2학기</option>
              </select>
            </div>
          </div>

          <div class="form-row two-col">
            <div class="form-row">
              <label class="form-label">수강신청 시작</label>
              <input class="form-input" type="datetime-local" name="registerStart" value="${setting.registerStart}" />
            </div>

            <div class="form-row">
              <label class="form-label">수강신청 종료</label>
              <input class="form-input" type="datetime-local" name="registerEnd" value="${setting.registerEnd}" />
            </div>
          </div>

          <div class="form-row">
            <label class="form-label">수강취소 가능 종료일</label>
            <input class="form-input" style="max-width:320px;" type="datetime-local" name="cancelEnd" value="${setting.cancelEnd}" />
            <div style="margin-top:6px; font-size:12px; color:#6b7280;">
              * 비워두면 수강취소는 기간 제한 없이 가능합니다.
            </div>
          </div>

          <div class="form-row">
            <label class="form-label">수동 열기 방식</label>
            <div style="background:#f9fafb; border-radius:12px; padding:12px; border:1px solid #eef2f7;">
              <label style="margin-right:18px; font-size:13px; font-weight:800; color:#111827;">
                <input type="radio" name="manualOpenYn" value="N"
                  <c:if test="${empty setting || setting.manualOpenYn ne 'Y'}">checked</c:if> />
                기간 기준으로만 열기
              </label>

              <label style="font-size:13px; font-weight:800; color:#111827;">
                <input type="radio" name="manualOpenYn" value="Y"
                  <c:if test="${not empty setting && setting.manualOpenYn eq 'Y'}">checked</c:if> />
                수동 항상 열기(기간 무시)
              </label>

              <div style="margin-top:8px; font-size:12px; color:#6b7280;">
                * <strong>수동 항상 열기</strong> 선택 시 신청/취소 기간과 상관없이 수강신청이 가능합니다.
              </div>
            </div>
          </div>

          <div class="form-actions" style="justify-content:flex-end;">
            <button type="submit" class="btn btn-primary" style="min-width:140px;">설정 저장</button>
          </div>
        </form>
      </div>

      <!-- 3) 수동 열기 빠른 전환 -->
      <c:if test="${not empty setting}">
        <div class="box">
          <div class="page-header" style="margin-bottom:12px;">
            <h2 style="margin:0; font-size:16px; font-weight:950;">수동 열기 빠른 전환</h2>
            <div class="page-header-actions" style="font-size:13px; color:#374151;">
              대상 학기 : <strong>${setting.year}년 ${setting.semester}</strong>
            </div>
          </div>

          <p style="margin:0 0 12px; font-size:13px; color:#374151;">
            현재 수동 열기 상태 :
            <strong style="padding:2px 10px; border-radius:999px;
              <c:if test='${setting.manualOpenYn == "Y"}'>background:#dbeafe; color:#1d4ed8;</c:if>
              <c:if test='${setting.manualOpenYn != "Y"}'>background:#e5e7eb; color:#374151;</c:if>">
              <c:choose>
                <c:when test="${setting.manualOpenYn == 'Y'}">수동 항상 열기 (ON)</c:when>
                <c:otherwise>기간 기준 (OFF)</c:otherwise>
              </c:choose>
            </strong>
          </p>

          <div style="display:flex; flex-wrap:wrap; gap:10px;">
            <form method="post" action="${pageContext.request.contextPath}/admin/course-register-setting/manual-open" class="inline-form">
              <input type="hidden" name="settingId" value="${setting.settingId}" />
              <input type="hidden" name="year" value="${year}" />
              <input type="hidden" name="semester" value="${semester}" />
              <input type="hidden" name="manualOpenYn" value="Y" />
              <button type="submit" class="btn btn-primary">
                수동 항상 열기 ON
              </button>
            </form>

            <form method="post" action="${pageContext.request.contextPath}/admin/course-register-setting/manual-open" class="inline-form">
              <input type="hidden" name="settingId" value="${setting.settingId}" />
              <input type="hidden" name="year" value="${year}" />
              <input type="hidden" name="semester" value="${semester}" />
              <input type="hidden" name="manualOpenYn" value="N" />
              <button type="submit" class="btn btn-secondary">
                기간 기준으로 전환 (수동 OFF)
              </button>
            </form>
          </div>

          <p style="margin-top:10px; font-size:12px; color:#6b7280;">
            * 이 버튼은 기간은 그대로 두고, <strong>수동 열기 상태만</strong> 빠르게 ON/OFF 합니다.
          </p>
        </div>
      </c:if>

    </main>
  </div>

  <%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>
