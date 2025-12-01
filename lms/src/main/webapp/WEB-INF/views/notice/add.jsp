<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 등록</title>

    <!-- 공통 레이아웃 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>

    <%-- 상단 헤더 --%>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="layout">
        <%-- 왼쪽 사이드바 --%>
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

        <%-- 오른쪽 본문 영역 --%>
        <main class="main-content">

            <h2 style="margin-top: 0; margin-bottom: 16px;">공지사항 등록</h2>

            <div class="box">
                <form action="${pageContext.request.contextPath}/notice/add" method="post" enctype="multipart/form-data">

                    <!-- 제목 -->
                    <div style="margin-bottom: 16px;">
                        <label for="title" style="display:block; font-weight:600; margin-bottom:6px;">제목</label>
                        <input type="text" id="title" name="title" required
                               style="width: 100%; max-width: 600px; padding: 8px 10px; box-sizing: border-box;">
                    </div>

                    <!-- 내용 -->
                    <div style="margin-bottom: 16px;">
                        <label for="content" style="display:block; font-weight:600; margin-bottom:6px;">내용</label>
                        <textarea id="content" name="content" rows="12" required
                                  style="width: 100%; max-width: 600px; padding: 8px 10px; box-sizing: border-box; resize: vertical;"></textarea>
                    </div>

                    <!-- 첨부파일 (드래그&드롭) -->
                    <div style="margin-bottom: 16px;">
                        <label style="display:block; font-weight:600; margin-bottom:6px;">
                            첨부파일
                        </label>

                        <%-- 실제 파일 인풋(숨김) --%>
                        <input type="file" id="files" name="files" multiple style="display:none;">

                        <%-- 드래그&드롭 존 --%>
                        <div id="dropZone" class="file-dropzone">
                            여기로 파일을 드래그 하거나<br>
                            <span class="file-dropzone-click">클릭해서 선택</span>
                        </div>

                        <%-- 선택된 파일 목록 --%>
                        <ul id="fileList" class="file-list"></ul>

                        <div style="font-size:12px; color:#6b7280; margin-top:4px;">
                            * 여러 개 파일을 한 번에 선택할 수 있어요.
                        </div>
                    </div>
                    
                    <!-- 상단 고정 여부 -->
                    <div style="margin-bottom: 16px;">
                        <span style="display:block; font-weight:600; margin-bottom:6px;">상단 고정</span>
                        <label>
                            <input type="radio" name="pinnedYn" value="Y"> 예
                        </label>
                        <label style="margin-left: 16px;">
                            <input type="radio" name="pinnedYn" value="N" checked> 아니오
                        </label>
                    </div>

                    <!-- 상단 고정 기간 -->
                    <div class="pin-period" style="margin-bottom: 16px;">
                        <label style="display:block; font-weight:600; margin-bottom:6px;">
                            상단 고정 기간 (선택사항)
                        </label>
                        <input type="datetime-local" id="pinStart" name="pinStart"
                               style="padding: 6px 8px; box-sizing: border-box;">
                        ~
                        <input type="datetime-local" id="pinEnd" name="pinEnd"
                               style="padding: 6px 8px; box-sizing: border-box;">
                        <div style="margin-top: 4px; font-size:12px; color:#6b7280;">
                            * 기간을 비워두면 고정 해제 전까지 상단 고정
                        </div>
                    </div>

                    <!-- 버튼 -->
                    <div>
                        <button type="submit"
                                style="padding: 8px 18px; border:none; border-radius:6px;
                                       background-color:#2563eb; color:white; font-weight:600; cursor:pointer;">
                            등록
                        </button>
                        <a href="${pageContext.request.contextPath}/notice/list"
                           style="margin-left: 8px; font-size:14px; text-decoration:none; color:#2563eb;">
                            목록으로
                        </a>
                    </div>

                </form>
            </div>

        </main>
    </div>

    <%-- 하단 푸터 --%>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script>
        // 상단 고정 여부에 따라 기간 입력 비활성화/활성화
        function togglePinPeriod() {
            const isPinned =
                document.querySelector('input[name="pinnedYn"][value="Y"]').checked;
            document.querySelectorAll('.pin-period input').forEach(el => {
                el.disabled = !isPinned;
            });
        }

        document.addEventListener("DOMContentLoaded", () => {
            // 상단 고정 라디오 이벤트
            document.querySelectorAll('input[name="pinnedYn"]').forEach(radio => {
                radio.addEventListener("change", togglePinPeriod);
            });
            togglePinPeriod(); // 초기 상태 한 번 반영

            // ====== 파일 드래그&드롭 설정 ======
            const dropZone = document.getElementById("dropZone");
            const fileInput = document.getElementById("files");
            const fileList = document.getElementById("fileList");

            if (dropZone && fileInput) {

                // 파일 목록 출력
                const updateFileList = (files) => {
                    fileList.innerHTML = "";
                    for (let i = 0; i < files.length; i++) {
                        const li = document.createElement("li");
                        const file = files[i];
                        const sizeText = file.size ? ` (${file.size} byte)` : "";
                        li.textContent = file.name + sizeText;
                        fileList.appendChild(li);
                    }
                };

                // 클릭하면 파일 선택창
                dropZone.addEventListener("click", () => {
                    fileInput.click();
                });

                // input으로 고른 경우
                fileInput.addEventListener("change", () => {
                    updateFileList(fileInput.files);
                });

                // 드래그 올라왔을 때
                dropZone.addEventListener("dragover", (e) => {
                    e.preventDefault();
                    dropZone.classList.add("dragover");
                });

                // 드래그 나갔을 때
                dropZone.addEventListener("dragleave", (e) => {
                    e.preventDefault();
                    dropZone.classList.remove("dragover");
                });

                // 드롭됐을 때
                dropZone.addEventListener("drop", (e) => {
                    e.preventDefault();
                    dropZone.classList.remove("dragover");

                    const files = e.dataTransfer.files;
                    if (!files || files.length === 0) return;

                    // FileList는 읽기 전용이라 DataTransfer 사용
                    const dt = new DataTransfer();
                    for (let i = 0; i < files.length; i++) {
                        dt.items.add(files[i]);
                    }
                    fileInput.files = dt.files;

                    updateFileList(fileInput.files);
                });
            }
        });
    </script>

</body>
</html>
