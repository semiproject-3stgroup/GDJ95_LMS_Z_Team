<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="site-header">
    <div class="site-header-left">
        <div class="site-logo">L</div>
        <div>
            <span class="site-title-main">LMS 학사관리 시스템</span>
            <span class="site-title-sub">GDJ95 Z팀</span>
        </div>
    </div>

    <div class="site-header-right">
        <c:choose>
            <c:when test="${not empty loginUser}">
                <!-- 로그인 정보 -->
                <span class="header-user-info">
					${loginUser.departmentId}
					/
					${loginUser.userName}
					/
					${loginUser.studentNo}
                </span>

                <!-- 🔔 알림 센터 -->
                <div class="notification-wrapper">
                    <button type="button" id="btnNotification" class="icon-button">
                        🔔
                        <span id="notificationBadge" class="notification-badge" style="display:none;">0</span>
                    </button>

                    <div id="notificationDropdown" class="notification-dropdown hidden">
                        <div class="dropdown-header">
                            <span>알림센터</span>
                            <span id="notificationHeaderCount" class="header-count"></span>
                        </div>
                        <ul id="notificationList" class="notification-list">
                            <!-- JS에서 채움 -->
                        </ul>
                        <div class="dropdown-footer">
                            <span class="dropdown-tip">알림을 클릭하면 해당 페이지로 이동합니다.</span>
                        </div>
                    </div>
                </div>

                <!-- 마이페이지 / 로그아웃 -->
                <a href="${pageContext.request.contextPath}/mypage">마이페이지</a>
                <a href="${pageContext.request.contextPath}/logout">로그아웃</a>
            </c:when>

            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login">로그인</a>
                <a href="${pageContext.request.contextPath}/findId">아이디 찾기</a>
                <a href="${pageContext.request.contextPath}/reset-Password">비밀번호 찾기</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>

<!-- 🔔 알림센터용 JS -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const btn = document.getElementById('btnNotification');
    const dropdown = document.getElementById('notificationDropdown');
    const badge = document.getElementById('notificationBadge');
    const listEl = document.getElementById('notificationList');
    const headerCount = document.getElementById('notificationHeaderCount');

    // 컨텍스트패스 (ex: /lms)
    const ctx = '<c:out value="${pageContext.request.contextPath}" />';

    if (!btn || !dropdown) return;

    function categoryLabel(category) {
        switch (category) {
            case 'notice': return '공지';
            case 'assignment': return '과제';
            case 'score': return '성적';
            case 'schedule': return '일정';
            default: return category || '';
        }
    }

    function categoryClass(category) {
        switch (category) {
            case 'notice': return 'category-notice';
            case 'assignment': return 'category-assignment';
            case 'score': return 'category-score';
            case 'schedule': return 'category-schedule';
            default: return 'category-notice';
        }
    }

    function formatDate(dateStr) {
        if (!dateStr) return '';
        return dateStr.replace('T', ' ').substring(0, 16); // 2025-12-04 15:05
    }

    function refreshBadge(unreadCount) {
        if (unreadCount > 0) {
            badge.style.display = 'inline-flex';
            badge.textContent = unreadCount > 9 ? '9+' : unreadCount;
            headerCount.textContent = '미확인 알림 ' + unreadCount + '건';
        } else {
            badge.style.display = 'none';
            headerCount.textContent = '미확인 알림 0건';
        }
    }

    function loadNotifications() {
        fetch(ctx + '/api/notifications/recent?limit=5')
            .then(res => res.json())
            .then(data => {
                if (!data.success) return;

                const items = data.items || [];
                refreshBadge(data.unreadCount || 0);

                listEl.innerHTML = '';
                if (items.length === 0) {
                    const li = document.createElement('li');
                    li.className = 'notification-item';
                    li.textContent = '새 알림이 없습니다.';
                    listEl.appendChild(li);
                    return;
                }

                items.forEach(item => {
                    const li = document.createElement('li');
                    li.className = 'notification-item' + (item.readYn === 'N' ? ' unread' : '');

                    // 윗줄 (카테고리 pill + 미확인 뱃지)
                    const pillRow = document.createElement('div');
                    pillRow.className = 'notification-pill-row';

                    const pill = document.createElement('span');
                    pill.className = 'notification-category-pill ' + categoryClass(item.category);
                    pill.textContent = categoryLabel(item.category);
                    pillRow.appendChild(pill);

                    if (item.readYn === 'N') {
                        const unreadSpan = document.createElement('span');
                        unreadSpan.className = 'notification-unread-badge';
                        unreadSpan.textContent = '미확인';
                        pillRow.appendChild(unreadSpan);
                    }

                    // 제목
                    const titleDiv = document.createElement('div');
                    titleDiv.className = 'notification-title';
                    titleDiv.textContent = item.title;

                    // 메시지
                    const msgDiv = document.createElement('div');
                    msgDiv.className = 'notification-message';
                    msgDiv.textContent = item.message || '';

                    // 날짜
                    const metaDiv = document.createElement('div');
                    metaDiv.className = 'notification-meta';
                    metaDiv.textContent = formatDate(item.createdate);

                    li.appendChild(pillRow);
                    li.appendChild(titleDiv);
                    li.appendChild(msgDiv);
                    li.appendChild(metaDiv);

                    // 클릭 시 읽음 처리 + 이동
                    li.addEventListener('click', function() {
                        fetch(ctx + '/api/notifications/' + item.notificationId + '/read', {
                            method: 'POST'
                        }).then(() => {
                            if (item.linkUrl) {
                                window.location.href = ctx + item.linkUrl;
                            }
                        });
                    });

                    listEl.appendChild(li);
                });
            })
            .catch(err => console.error('알림 조회 오류', err));
    }

    // 드롭다운 토글
    btn.addEventListener('click', function(event) {
        event.stopPropagation();
        const hidden = dropdown.classList.contains('hidden');
        if (hidden) {
            dropdown.classList.remove('hidden');
            loadNotifications();
        } else {
            dropdown.classList.add('hidden');
        }
    });

    // 바깥 클릭 시 닫기
    document.addEventListener('click', function() {
        dropdown.classList.add('hidden');
    });
    dropdown.addEventListener('click', function(e) {
        e.stopPropagation();
    });

    // 최초 배지 숫자만 한 번 가져오기
    fetch(ctx + '/api/notifications/unread-count')
        .then(res => res.json())
        .then(data => {
            if (!data.success) return;
            refreshBadge(data.unreadCount || 0);
        })
        .catch(err => console.error(err));
});
</script>
