<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="site-header">

  <!-- Left -->
  <div class="site-header-left">
    <a href="${pageContext.request.contextPath}/home" class="site-logo-link" aria-label="홈으로">
      <div class="site-logo">LMS</div>
    </a>
  </div>

  <!-- Center -->
  <div class="site-header-center">
    <a href="${pageContext.request.contextPath}/home"
       class="brand-logo-link"
       aria-label="Gudi University 홈으로 이동">

      <!-- 1) SVG 로고 -->
      <img src="${pageContext.request.contextPath}/img/logo-gudi.svg"
           alt="Gudi University | 구디대학교"
           class="brand-logo-svg"
           onerror="this.style.display='none'; this.nextElementSibling.style.display='inline-flex';" />

      <!-- 2) SVG 깨지면 보여줄 텍스트 로고 -->
      <span class="brand-logo-text" style="display:none;">
        <span class="brand-en">Gudi University</span>
        <span class="brand-sep">|</span>
        <span class="brand-ko">구디대학교</span>
      </span>
    </a>
  </div>

  <!-- Right -->
  <div class="site-header-right">
    <c:choose>
      <c:when test="${not empty loginUser}">
        <span class="header-user-info">
          ${loginUser.departmentName} / ${loginUser.userName} / ${loginUser.studentNo}
        </span>

        <!-- 🔔 알림 (로그인시에만 노출) -->
        <div class="notification-wrapper">
          <button type="button" id="btnNotification" class="icon-button" aria-label="알림">
            🔔
            <span id="notificationDot" class="notification-dot" style="display:none;"></span>
            <span id="notificationBadge" class="notification-badge" style="display:none;">0</span>
          </button>

          <div id="notificationDropdown" class="notification-dropdown hidden">
            <div class="dropdown-header">
              <span>알림센터</span>
              <span id="notificationHeaderCount" class="header-count"></span>
            </div>
            <ul id="notificationList" class="notification-list"></ul>
            <div class="dropdown-footer">
              <span class="dropdown-tip">알림을 클릭하면 해당 페이지로 이동합니다.</span>
            </div>
          </div>
        </div>

        <a href="${pageContext.request.contextPath}/mypage" class="header-link">마이페이지</a>
        <a href="${pageContext.request.contextPath}/logout" class="header-link">로그아웃</a>
      </c:when>

      <c:otherwise>
        <a href="${pageContext.request.contextPath}/login" class="header-link">로그인</a>
        <a href="${pageContext.request.contextPath}/find-id" class="header-link">아이디 찾기</a>
        <a href="${pageContext.request.contextPath}/find-password" class="header-link">비밀번호 찾기</a>
      </c:otherwise>
    </c:choose>
  </div>

</header>

<!-- 알림 JS는 그대로 두되, header.jsp에 한 번만 존재해야 함 -->
<script>
document.addEventListener('DOMContentLoaded', function() {
  const btn = document.getElementById('btnNotification');
  const dropdown = document.getElementById('notificationDropdown');
  if (!btn || !dropdown) return; // 비로그인일 땐 아예 없음

  const badge = document.getElementById('notificationBadge');
  const listEl = document.getElementById('notificationList');
  const headerCount = document.getElementById('notificationHeaderCount');
  const dot = document.getElementById('notificationDot');
  const ctx = '<c:out value="${pageContext.request.contextPath}" />';

  function refreshBadge(unreadCount) {
    if (unreadCount > 0) {
      badge.style.display = 'inline-flex';
      badge.textContent = unreadCount > 9 ? '9+' : unreadCount;
      headerCount.textContent = '미확인 알림 ' + unreadCount + '건';
      if (dot) dot.style.display = 'block';
    } else {
      badge.style.display = 'none';
      headerCount.textContent = '미확인 알림 0건';
      if (dot) dot.style.display = 'none';
    }
  }

  function categoryLabel(category) {
    if (!category) return '';
    const key = category.toLowerCase();
    switch (key) {
      case 'notice': return '공지';
      case 'assignment': return '과제';
      case 'score': return '성적';
      case 'event':
      case 'schedule': return '학사일정';
      default: return category;
    }
  }

  function categoryClass(category) {
    const key = (category || '').toUpperCase();
    switch (key) {
      case 'NOTICE': return 'category-notice';
      case 'ASSIGNMENT': return 'category-assignment';
      case 'SCORE': return 'category-score';
      case 'EVENT': return 'category-event';
      default: return 'category-notice';
    }
  }

  function formatDate(dateStr) {
    if (!dateStr) return '';
    return dateStr.replace('T', ' ').substring(0, 16);
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
          li.dataset.notificationId = item.notificationId;

          const pillRow = document.createElement('div');
          pillRow.className = 'notification-pill-row';

          const iconSpan = document.createElement('span');
          iconSpan.className = 'notification-category-icon';
          iconSpan.textContent = (function(cat) {
            const k = (cat || '').toLowerCase();
            switch (k) {
              case 'notice': return '📢';
              case 'assignment': return '📌';
              case 'score': return '📊';
              case 'event':
              case 'schedule': return '🎓';
              default: return '🔔';
            }
          })(item.category);
          pillRow.appendChild(iconSpan);

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

          const titleDiv = document.createElement('div');
          titleDiv.className = 'notification-title';
          titleDiv.textContent = item.title;

          const msgDiv = document.createElement('div');
          msgDiv.className = 'notification-message';
          msgDiv.textContent = item.message || '';

          const metaDiv = document.createElement('div');
          metaDiv.className = 'notification-meta';
          metaDiv.textContent = formatDate(item.createdate);

          li.appendChild(pillRow);
          li.appendChild(titleDiv);
          li.appendChild(msgDiv);
          li.appendChild(metaDiv);

          const deleteBtn = document.createElement('button');
          deleteBtn.type = 'button';
          deleteBtn.className = 'notification-delete-btn';
          deleteBtn.textContent = '삭제';
          deleteBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            if (!confirm('해당 알림을 삭제할까요?')) return;

            fetch(ctx + '/api/notifications/' + item.notificationId, { method: 'DELETE' })
              .then(res => res.json())
              .then(d => {
                if (!d.success) {
                  alert(d.message || '알림 삭제에 실패했습니다.');
                  return;
                }
                li.remove();
                if (d.unreadCount != null) refreshBadge(d.unreadCount);
              });
          });
          li.appendChild(deleteBtn);

          li.addEventListener('click', function() {
            fetch(ctx + '/api/notifications/' + item.notificationId + '/read', { method: 'POST' })
              .then(() => { if (item.linkUrl) window.location.href = ctx + item.linkUrl; });
          });

          listEl.appendChild(li);
        });
      });
  }

  btn.addEventListener('click', function(e) {
    e.stopPropagation();
    const hidden = dropdown.classList.contains('hidden');
    if (hidden) {
      dropdown.classList.remove('hidden');
      loadNotifications();
    } else {
      dropdown.classList.add('hidden');
    }
  });

  document.addEventListener('click', function() {
    dropdown.classList.add('hidden');
  });
  dropdown.addEventListener('click', function(e) { e.stopPropagation(); });

  fetch(ctx + '/api/notifications/unread-count')
    .then(res => res.json())
    .then(data => { if (data.success) refreshBadge(data.unreadCount || 0); });
});
</script>
