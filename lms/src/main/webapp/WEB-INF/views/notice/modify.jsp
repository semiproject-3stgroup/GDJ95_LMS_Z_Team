<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 수정</title>

    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/notice.css">
</head>
<body>

    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

        <main class="main-content">

            <h2 style="margin-top: 0; margin-bottom: 16px;">공지사항 수정</h2>

            <div class="box">
                <!-- 파일 업로드를 위해 enctype 추가 -->
                <form action="${pageContext.request.contextPath}/notice/edit"
                      method="post" enctype="multipart/form-data">

                    <!-- noticeId 숨김 -->
                    <input type="hidden" name="noticeId" value="${notice.noticeId}"/>

                    <!-- 제목 -->
                    <div style="margin-bottom: 16px;">
                        <label for="title" style="display:block; font-weight:600; margin-bottom:6px;">제목</label>
                        <input type="text" id="title" name="title" required
                               value="${notice.title}"
                               style="width: 100%; max-width: 600px; padding: 8px 10px; box-sizing: border-box;">
                    </div>

                    <!-- 내용 -->
                    <div style="margin-bottom: 16px;">
                        <label for="content" style="display:block; font-weight:600; margin-bottom:6px;">내용</label>
                        <textarea id="content" name="content" rows="12" required
                                  style="width: 100%; max-width: 600px; padding: 8px 10px; box-sizing: border-box; resize: vertical;">${notice.content}</textarea>
                    </div>

                    <!-- 기존 첨부파일 목록 + 삭제 체크박스 -->
					<c:if test="${not empty fileList}">
					    <div class="board-files-old">
					
					        <div class="board-form-label">기존 첨부파일</div>
					
					        <div class="board-files-old-list">
					            <c:forEach var="file" items="${fileList}">
					                <label class="board-file-item">
					                    <span class="board-file-icon">📎</span>
					
					                    <a href="${pageContext.request.contextPath}/notice/file/download?fileId=${file.fileId}"
					                       class="board-file-link">
					                        ${file.originName}
					                    </a>
					                    <span class="board-file-size">
					                        (${file.fileSize} Byte)
					                    </span>
					
					                    <span class="board-file-delete">
					                        <input type="checkbox" name="deleteFileIds" value="${file.fileId}">
					                        삭제
					                    </span>
					                </label>
					            </c:forEach>
					        </div>
					
					    </div>
					</c:if>

                    <!-- 새 첨부파일 (드래그 & 클릭 선택) -->
                    <div style="margin-bottom: 16px;">
                        <label style="display:block; font-weight:600; margin-bottom:6px;">
                            첨부파일 추가
                        </label>

                        <div class="file-dropzone" id="fileDropzone"
                             style="border:1px dashed #d1d5db; border-radius:8px; padding:24px; text-align:center; background-color:#f9fafb;">
                            <p style="margin:0 0 4px 0; font-size:14px; color:#4b5563;">
                                여기로 파일을 드래그 하거나
                            </p>
                            <button type="button" id="fileSelectBtn"
                                    style="border:none; background:none; color:#2563eb; cursor:pointer; text-decoration:underline; font-size:14px;">
                                클릭해서 선택
                            </button>
                            <input type="file" id="files" name="files" multiple style="display:none;">
                        </div>

                        <div id="fileList" style="margin-top:8px; font-size:13px; color:#4b5563;"></div>

                        <div style="font-size:12px; color:#6b7280; margin-top:4px;">
                            * 여러 개 파일을 한 번에 선택할 수 있어요.
                        </div>
                    </div>

                    <!-- 상단 고정 여부 -->
                    <div style="margin-bottom: 16px;">
                        <span style="display:block; font-weight:600; margin-bottom:6px;">상단 고정</span>
                        <label>
                            <input type="radio" name="pinnedYn" value="Y"
                                <c:if test="${notice.pinnedYn == 'Y'}">checked</c:if>>
                            예
                        </label>
                        <label style="margin-left: 16px;">
                            <input type="radio" name="pinnedYn" value="N"
                                <c:if test="${notice.pinnedYn != 'Y'}">checked</c:if>>
                            아니오
                        </label>
                    </div>

                    <!-- 상단 고정 기간 -->
                    <div class="pin-period" style="margin-bottom: 16px;">
                        <label style="display:block; font-weight:600; margin-bottom:6px;">
                            상단 고정 기간 (선택사항)
                        </label>
                        <input type="datetime-local" id="pinStart" name="pinStart"
                               value="${pinStartStr}"
                               style="padding: 6px 8px; box-sizing: border-box;">
                        ~
                        <input type="datetime-local" id="pinEnd" name="pinEnd"
                               value="${pinEndStr}"
                               style="padding: 6px 8px; box-sizing: border-box;">
                        <div style="margin-top: 4px; font-size:12px; color:#6b7280;">
                            * 기간을 비워두면 고정 해제 전까지 계속 상단 고정돼.
                        </div>
                    </div>

                    <!-- 버튼 -->
                    <div>
                        <button type="submit"
                                style="padding: 8px 18px; border:none; border-radius:6px;
                                       background-color:#2563eb; color:white; font-weight:600; cursor:pointer;">
                            수정 완료
                        </button>
                        <a href="${pageContext.request.contextPath}/notice/detail?noticeId=${notice.noticeId}"
                           style="margin-left: 8px; font-size:14px; text-decoration:none; color:#2563eb;">
                            취소
                        </a>
                    </div>

                </form>
            </div>

        </main>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script>
        // 상단 고정 여부에 따라 기간 입력 비활성화/활성화
        function togglePinPeriod() {
            const pinnedRadio = document.querySelector('input[name="pinnedYn"][value="Y"]');
            if (!pinnedRadio) return;

            const isPinned = pinnedRadio.checked;
            document.querySelectorAll('.pin-period input').forEach(el => {
                el.disabled = !isPinned;
            });
        }

        document.addEventListener("DOMContentLoaded", () => {
            // 상단 고정 라디오 이벤트
            document.querySelectorAll('input[name="pinnedYn"]').forEach(radio => {
                radio.addEventListener("change", togglePinPeriod);
            });
            togglePinPeriod(); // 초기 상태 반영

            // === 파일 드래그 & 클릭 업로드 ===
            const dropzone   = document.getElementById("fileDropzone");
            const fileInput  = document.getElementById("files");
            const fileBtn    = document.getElementById("fileSelectBtn");
            const fileListEl = document.getElementById("fileList");

            if (dropzone && fileInput && fileBtn && fileListEl) {

                // 버튼 클릭 시 파일 선택창 열기
                fileBtn.addEventListener("click", () => fileInput.click());

                // input으로 선택된 파일 목록 표시
                fileInput.addEventListener("change", (e) => {
                    renderFileList(e.target.files);
                });

                ["dragenter", "dragover"].forEach(eventName => {
                    dropzone.addEventListener(eventName, (e) => {
                        e.preventDefault();
                        e.stopPropagation();
                        dropzone.classList.add("drag-over");
                    });
                });

                ["dragleave", "drop"].forEach(eventName => {
                    dropzone.addEventListener(eventName, (e) => {
                        e.preventDefault();
                        e.stopPropagation();
                        dropzone.classList.remove("drag-over");
                    });
                });

                dropzone.addEventListener("drop", (e) => {
                    const files = e.dataTransfer.files;
                    fileInput.files = files; // 실제 전송될 파일 세팅
                    renderFileList(files);
                });

                function renderFileList(files) {
                    if (!files || files.length === 0) {
                        fileListEl.innerHTML = "";
                        return;
                    }
                    let html = "";
                    for (let i = 0; i < files.length; i++) {
                        html += `<div>• ${files[i].name} (${files[i].size} Byte)</div>`;
                    }
                    fileListEl.innerHTML = html;
                }
            }
        });
    </script>

</body>
</html>
