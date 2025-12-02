<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내 정보 수정</title>

    <!-- 공통 레이아웃 CSS -->
    <link rel="stylesheet" href="/css/layout.css">

    <!-- 마이페이지 CSS -->
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

    <main class="content">

        <div class="mypage-card">
            <h1 class="mypage-title">내 정보 수정</h1>
            <p class="mypage-subtitle">연락처와 주소, 학과 정보를 수정할 수 있습니다.</p>

            <form action="/mypage/edit" method="post" class="mypage-form">

                <!-- 이름 -->
                <div class="mypage-form-group">
                    <label class="mypage-label" for="userName">이름</label>
                    <input type="text"
                           id="userName"
                           name="userName"
                           class="mypage-input"
                           value="${user.userName}">
                </div>

                <!-- 전화번호 -->
                <div class="mypage-form-group">
                    <label class="mypage-label" for="phone">전화번호</label>
                    <input type="text"
                           id="phone"
                           name="phone"
                           class="mypage-input"
                           value="${user.phone}">
                </div>

                <!-- 이메일 -->
                <div class="mypage-form-group">
                    <label class="mypage-label" for="email">이메일</label>
                    <input type="text"
                           id="email"
                           name="email"
                           class="mypage-input"
                           value="${user.email}">
                </div>

                <!-- 주소 (카카오 주소 API) -->
                <div class="mypage-form-group">
                    <label class="mypage-label" for="zipCode">우편번호</label>
                    <div class="mypage-zip-row">
                        <input type="text"
                               id="zipCode"
                               name="zipCode"
                               class="mypage-input"
                               value="${user.zipCode}"
                               readonly>
                        <button type="button"
						        class="mypage-btn-outline"
						        onclick="execDaumPostcode();">
						    주소 검색
						</button>
                    </div>
                </div>

                <div class="mypage-form-group">
                    <label class="mypage-label" for="address1">기본주소</label>
                    <input type="text"
                           id="address1"
                           name="address1"
                           class="mypage-input"
                           value="${user.address1}"
                           readonly>
                </div>

                <div class="mypage-form-group">
                    <label class="mypage-label" for="address2">상세주소</label>
                    <input type="text"
                           id="address2"
                           name="address2"
                           class="mypage-input"
                           value="${user.address2}">
                </div>

                <!-- 학과 -->
                <div class="mypage-form-group">
                    <label class="mypage-label" for="departmentId">학과</label>
                    <select id="departmentId"
                            name="departmentId"
                            class="mypage-input">
                        <option value="">선택</option>
                        <c:forEach var="dept" items="${departmentList}">
                            <option value="${dept.departmentId}"
                                <c:if test="${user.departmentId == dept.departmentId}">selected</c:if>>
                                ${dept.departmentName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mypage-btn-area">
                    <button type="submit" class="mypage-btn-primary">저장</button>
                    <button type="button"
                            class="mypage-btn-secondary"
                            onclick="location.href='/mypage';">
                        취소
                    </button>
                </div>

            </form>
        </div>

    </main>
</div>

<!-- 카카오(다음) 우편번호 API -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
    // 버튼 클릭 테스트용 (정상 동작 확인)
    function execDaumPostcode() {
        // alert("주소 검색 클릭!");

        new daum.Postcode({
            oncomplete: function(data) {
                // 도로명/지번 중 선택
                var addr = data.roadAddress;
                if (!addr || addr === '') {
                    addr = data.jibunAddress;
                }

                // 값 세팅
                document.getElementById('zipCode').value  = data.zonecode; // 우편번호
                document.getElementById('address1').value = addr;          // 기본주소

                // 상세주소 포커스
                document.getElementById('address2').focus();
            }
        }).open();
    }
</script>