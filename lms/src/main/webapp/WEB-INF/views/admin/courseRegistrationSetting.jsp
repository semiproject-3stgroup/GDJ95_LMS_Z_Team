<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="layout-container">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

    <main class="layout-content">

        <!-- 플래시 메시지 박스 + 테스트용 팝업(alert) -->
        <c:if test="${not empty message}">
            <div class="alert 
                 <c:choose>
                    <c:when test='${messageType eq "error"}'>alert-error</c:when>
                    <c:otherwise>alert-success</c:otherwise>
                 </c:choose>">
                ${message}
            </div>

            <!-- alert 팝업: 테스트할 때 바로 눈에 띄도록 -->
            <script>
                alert('${fn:escapeXml(message)}');
            </script>
        </c:if>

        <!-- 상단 제목 + 현재 조회 중인 학기 표시 -->
        <div style="display:flex; align-items:flex-end; justify-content:space-between; margin-bottom:16px;">
            <div>
                <h1 class="page-title" style="margin-bottom:4px;">수강신청 기간 / 수동 열기 설정</h1>
                <c:if test="${not empty year && not empty semester}">
                    <div style="font-size:14px; color:#4b5563;">
                        현재 조회 중인 학기 :
                        <span style="font-weight:600; color:#111827;">
                            ${year}년 ${semester}
                        </span>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- 조회용 학년도 / 학기 선택 -->
        <div class="box" style="margin-bottom: 20px;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
                <h2 class="section-title" style="margin:0;">학기 선택</h2>
                <span style="font-size:12px; color:#9ca3af;">
                    수강신청 기간 / 수동 열기를 변경할 학기를 먼저 선택하세요.
                </span>
            </div>

            <form method="get"
                  action="${pageContext.request.contextPath}/admin/course-register-setting"
                  class="form-inline"
                  style="display:flex; flex-wrap:wrap; gap:12px; align-items:flex-end;">

                <div class="form-row" style="min-width:160px;">
                    <label for="searchYear">학년도</label>
                    <input id="searchYear"
                           type="number"
                           name="year"
                           value="${year}"
                           placeholder="2025"
                           required />
                </div>

                <div class="form-row" style="min-width:160px;">
                    <label for="searchSemester">학기</label>
                    <select id="searchSemester" name="semester" required>
                        <option value="">선택</option>
                        <option value="1학기"
                            <c:if test="${semester == '1학기'}">selected</c:if>>1학기</option>
                        <option value="2학기"
                            <c:if test="${semester == '2학기'}">selected</c:if>>2학기</option>
                    </select>
                </div>

                <button type="submit"
                        class="btn btn-primary"
                        style="height:40px; padding:0 18px;">
                    조회
                </button>
            </form>

            <p class="help-text" style="margin-top:10px; font-size:13px; color:#6b7280;">
                * 설정이 없으면 저장 시 새로운 설정이 생성됩니다.
            </p>
        </div>

        <!-- 설정 등록 / 수정 폼 -->
        <div class="box" style="margin-bottom: 20px;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
                <h2 class="section-title" style="margin:0;">수강신청 기간 설정</h2>

                <c:if test="${not empty setting}">
                    <!-- 현재 설정 요약 뱃지 -->
                    <div style="font-size:12px; color:#4b5563; background:#f3f4f6; padding:6px 10px; border-radius:999px;">
                        <strong>${setting.year}년 ${setting.semester}</strong> 설정이 로드되었습니다.
                    </div>
                </c:if>
            </div>

            <form method="post"
                  action="${pageContext.request.contextPath}/admin/course-register-setting/save"
                  style="display:grid; grid-template-columns:repeat(auto-fit,minmax(260px,1fr)); gap:16px 24px;">

                <!-- 기존 setting 수정 시 필요 -->
                <input type="hidden" name="settingId"
                       value="${setting.settingId}" />

                <div class="form-row">
                    <label>학년도</label>
                    <input type="number"
                           name="year"
                           value="${year}"
                           placeholder="2025"
                           required />
                </div>

                <div class="form-row">
                    <label>학기</label>
                    <select name="semester" required>
                        <option value="">선택</option>
                        <option value="1학기"
                            <c:if test="${semester == '1학기'}">selected</c:if>>1학기</option>
                        <option value="2학기"
                            <c:if test="${semester == '2학기'}">selected</c:if>>2학기</option>
                    </select>
                </div>

                <div class="form-row">
                    <label>수강신청 시작</label>
                    <input type="datetime-local"
                           name="registerStart"
                           value="${setting.registerStart}"
                           placeholder="2025-12-01T09:00" />
                </div>

                <div class="form-row">
                    <label>수강신청 종료</label>
                    <input type="datetime-local"
                           name="registerEnd"
                           value="${setting.registerEnd}"
                           placeholder="2025-12-05T18:00" />
                </div>

                <div class="form-row" style="grid-column:1 / -1;">
                    <label>수강취소 가능 종료일</label>
                    <div style="display:flex; flex-wrap:wrap; gap:8px; align-items:center;">
                        <input type="datetime-local"
                               name="cancelEnd"
                               value="${setting.cancelEnd}"
                               placeholder="2025-12-10T18:00"
                               style="max-width:260px;" />
                        <span class="help-text" style="font-size:13px; color:#6b7280;">
                            * 비워두면 수강취소는 기간 제한 없이 가능합니다.
                        </span>
                    </div>
                </div>

                <!-- 수동 항상 열기 라디오 (Y / N만 서버로 보냄) -->
                <div class="form-row" style="grid-column:1 / -1;">
                    <label>수동 열기 방식</label>
                    <div style="background:#f9fafb; border-radius:8px; padding:10px 12px;">
                        <label class="radio-inline" style="margin-right:20px;">
                            <input type="radio" name="manualOpenYn" value="N"
                                   <c:if test="${empty setting || setting.manualOpenYn ne 'Y'}">checked</c:if> />
                            기간 기준으로만 열기
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="manualOpenYn" value="Y"
                                   <c:if test="${not empty setting && setting.manualOpenYn eq 'Y'}">checked</c:if> />
                            수동 항상 열기(기간 무시)
                        </label>

                        <div class="help-text" style="margin-top:6px; font-size:13px; color:#6b7280;">
                            * <strong>수동 항상 열기</strong> 선택 시 신청/취소 기간과 상관없이 수강신청이 가능합니다.
                        </div>
                    </div>
                </div>

                <div class="form-actions" style="grid-column:1 / -1; margin-top: 4px; text-align:right;">
                    <button type="submit" class="btn btn-primary" style="min-width:120px;">
                        설정 저장
                    </button>
                </div>
            </form>
        </div>

        <!-- 수동 열기 ON/OFF 전용 버튼 -->
        <c:if test="${not empty setting}">
            <div class="box" style="margin-top:8px;">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                    <h2 class="section-title" style="margin:0;">수동 열기 빠른 전환</h2>

                    <!-- 어떤 학기 설정인지 명확히 -->
                    <div style="font-size:13px; color:#374151;">
                        대상 학기 :
                        <span style="font-weight:600;">
                            ${setting.year}년 ${setting.semester}
                        </span>
                    </div>
                </div>

                <!-- 현재 상태 뱃지 -->
                <p style="margin-bottom:12px;">
                    현재 수동 열기 상태 :
                    <strong style="padding:2px 8px; border-radius:999px;
                                   <c:if test='${setting.manualOpenYn == "Y"}'>
                                       background:#dbeafe; color:#1d4ed8;
                                   </c:if>
                                   <c:if test='${setting.manualOpenYn != "Y"}'>
                                       background:#e5e7eb; color:#374151;
                                   </c:if>">
                        <c:choose>
                            <c:when test="${setting.manualOpenYn == 'Y'}">수동 항상 열기 (ON)</c:when>
                            <c:otherwise>기간 기준 (OFF)</c:otherwise>
                        </c:choose>
                    </strong>
                </p>

                <!-- 버튼 영역 -->
                <div style="display:flex; flex-wrap:wrap; gap:10px; align-items:center;">

                    <!-- 항상 열기 ON 으로 -->
                    <form method="post"
                          action="${pageContext.request.contextPath}/admin/course-register-setting/manual-open"
                          style="display:inline-block;">
                        <input type="hidden" name="settingId" value="${setting.settingId}" />
                        <input type="hidden" name="year" value="${year}" />
                        <input type="hidden" name="semester" value="${semester}" />
                        <input type="hidden" name="manualOpenYn" value="Y" />
                        <button type="submit" class="btn btn-primary">
                            ${setting.year}년 ${setting.semester} 수동 항상 열기 ON
                        </button>
                    </form>

                    <!-- 기간 기준으로 -->
                    <form method="post"
                          action="${pageContext.request.contextPath}/admin/course-register-setting/manual-open"
                          style="display:inline-block;">
                        <input type="hidden" name="settingId" value="${setting.settingId}" />
                        <input type="hidden" name="year" value="${year}" />
                        <input type="hidden" name="semester" value="${semester}" />
                        <input type="hidden" name="manualOpenYn" value="N" />
                        <button type="submit" class="btn btn-secondary">
                            ${setting.year}년 ${setting.semester} 기간 기준으로 전환 (수동 OFF)
                        </button>
                    </form>
                </div>

                <p class="help-text" style="margin-top:10px; font-size:13px; color:#6b7280;">
                    * 위 버튼은 <strong>${setting.year}년 ${setting.semester}</strong>의 수강신청 기간은 그대로 두고,
                    <strong>수동 열기 상태만</strong> 빠르게 ON/OFF 하는 용도입니다.
                </p>
            </div>
        </c:if>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </main>
</div>
