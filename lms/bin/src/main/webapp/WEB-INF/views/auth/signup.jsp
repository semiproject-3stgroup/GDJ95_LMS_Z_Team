<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link rel="stylesheet" href="/css/auth.css">
</head>
<body>

<div class="auth-page">
    <div class="auth-card">

        <h2>회원가입</h2>
        <p class="subtitle">LMS 학사관리 시스템을 이용하기 위해 아래 정보를 입력해 주세요.</p>

        <form action="/signup" method="post" id="signupForm">

            <!-- ===== 기본 정보 ===== -->
            <section class="section-box">
                <h3>기본 정보</h3>

                <div class="grid-2">
                    <!-- 아이디 -->
                    <div class="form-group">
                        <label>아이디<span class="req">*</span></label>
                        <input type="text" name="loginId" required
                               placeholder="영문/숫자 조합 4~20자">
                        <small>중복확인은 나중에 AJAX로 구현하면 좋아.</small>
                    </div>

                    <!-- 이메일 -->
                    <div class="form-group">
                        <label>이메일<span class="req">*</span></label>
                        <input type="email" name="email" required
                               placeholder="example@university.ac.kr">
                    </div>

                    <!-- 비밀번호 -->
                    <div class="form-group">
                        <label>비밀번호<span class="req">*</span></label>
                        <input type="password" name="password" required
                               placeholder="숫자+특수문자 포함 8~16자">
                        <small>숫자 및 특수기호를 1개 이상 포함한 8~16자리 비밀번호.</small>
                    </div>

                    <!-- 비밀번호 확인 (DTO에는 없음, 검증용) -->
                    <div class="form-group">
                        <label>비밀번호 확인<span class="req">*</span></label>
                        <input type="password" name="confirmPassword" required
                               placeholder="비밀번호를 한 번 더 입력">
                    </div>

                    <!-- 이름 -->
                    <div class="form-group">
                        <label>이름<span class="req">*</span></label>
                        <input type="text" name="userName" required>
                    </div>

                    <!-- 휴대폰 번호 -->
                    <div class="form-group">
                        <label>휴대폰 번호<span class="req">*</span></label>
                        <input type="text" name="phone" required
                               placeholder="010-0000-0000">
                    </div>

                    <!-- 성별 -->
                    <div class="form-group">
                        <label>성별<span class="req">*</span></label>
                        <div class="radio-group">
                            <label><input type="radio" name="gender" value="M" checked> 남</label>
                            <label><input type="radio" name="gender" value="F"> 여</label>
                        </div>
                    </div>

                    <!-- 역할 -->
                    <div class="form-group">
                        <label>역할<span class="req">*</span></label>
                        <select name="role" id="roleSelect">
                            <option value="STUDENT">학생</option>
                            <option value="PROF">교수</option>
                        </select>
                    </div>
                </div>
            </section>

            <!-- ===== 학생 정보 ===== -->
            <section class="section-box" id="studentSection">
                <div class="section-header">
                    <h3>학생 정보 <span class="badge">Student</span></h3>
                </div>

                <div class="grid-2">
                    <!-- 학번 -->
                    <div class="form-group">
                        <label>학번<span class="req">*</span></label>
                        <input type="text" name="studentNo"
                               placeholder="예) 202312345">
                    </div>

                    <!-- 학과 -->
                    <div class="form-group">
                        <label>학과<span class="req">*</span></label>
                        <select name="departmentId">
                            <option value="">선택</option>
                            <option value="1">컴퓨터공학과</option>
                            <option value="2">전자공학과</option>
                            <option value="3">경영학과</option>
                            <option value="4">디자인학과</option>
                        </select>
                    </div>

                    <!-- 학년(userGrade) -->
                    <div class="form-group">
                        <label>학년<span class="req">*</span></label>
                        <select name="userGrade">
                            <option value="">선택</option>
                            <option value="1">1학년</option>
                            <option value="2">2학년</option>
                            <option value="3">3학년</option>
                            <option value="4">4학년</option>
                        </select>
                    </div>

                    <!-- 입학년도 (DB엔 컬럼 없음 → 일단 화면용만 / name 빼도 됨) -->
                    <div class="form-group">
                        <label>입학년도</label>
                        <select>
                            <option value="">선택</option>
                            <option>2021</option>
                            <option>2022</option>
                            <option>2023</option>
                            <option>2024</option>
                        </select>
                    </div>
                </div>
            </section>

            <!-- ===== 교수 정보 ===== -->
            <section class="section-box" id="profSection" style="display:none;">
                <div class="section-header">
                    <h3>교수 정보 <span class="badge badge-prof">Professor</span></h3>
                </div>

                <div class="grid-2">
                    <!-- 사번(employeeNo) -->
                    <div class="form-group">
                        <label>사번<span class="req">*</span></label>
                        <input type="text" name="employeeNo"
                               placeholder="예) P2023001">
                    </div>

                    <!-- 소속 학과 -->
                    <div class="form-group">
                        <label>소속 학과<span class="req">*</span></label>
                        <select name="departmentId">
                            <option value="">선택</option>
                            <option value="1">컴퓨터공학과</option>
                            <option value="2">전자공학과</option>
                            <option value="3">경영학과</option>
                            <option value="4">디자인학과</option>
                        </select>
                    </div>

                    <!-- 연구실 전화 (DB 컬럼 없음) -->
                    <div class="form-group">
                        <label>연구실 전화 (선택)</label>
                        <input type="text" placeholder="02-0000-0000">
                    </div>
                </div>
            </section>

            <!-- ===== 주소 정보 ===== -->
            <section class="section-box">
                <h3>주소 정보</h3>

                <div class="grid-3">
                    <div class="form-group">
                        <label>우편번호<span class="req">*</span></label>
                        <div class="inline">
                            <input type="text" name="zipCode" id="zipCode" readonly required>
                            <button type="button" onclick="execDaumPostcode()">검색</button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>기본 주소<span class="req">*</span></label>
                        <input type="text" name="address1" id="address1" readonly required>
                    </div>

                    <div class="form-group">
                        <label>상세 주소<span class="req">*</span></label>
                        <input type="text" name="address2" required>
                    </div>
                </div>
            </section>

            <!-- ===== 약관 동의 ===== -->
            <section class="section-box">
                <div class="checkbox-group">
                    <label><input type="checkbox" required> [필수] 이용약관에 동의합니다.</label>
                    <label><input type="checkbox" required> [필수] 개인정보 처리방침에 동의합니다.</label>
                    <label><input type="checkbox"> [선택] 이메일/문자로 소식 및 안내를 받겠습니다.</label>
                </div>
            </section>

            <!-- 버튼 -->
            <div class="btn-row">
                <button type="reset" class="btn-secondary">다시 작성</button>
                <button type="submit" class="btn-primary">회원가입 완료</button>
            </div>

        </form>
    </div>
</div>

<!-- 다음 주소 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    // 역할에 따라 학생/교수 섹션 토글
    document.getElementById('roleSelect').addEventListener('change', function () {
        const role = this.value;
        const studentSec = document.getElementById('studentSection');
        const profSec = document.getElementById('profSection');

        if (role === 'STUDENT') {
            studentSec.style.display = '';
            profSec.style.display = 'none';
        } else {
            studentSec.style.display = 'none';
            profSec.style.display = '';
        }
    });

    // 비밀번호 확인 검사
    document.getElementById('signupForm').addEventListener('submit', function (e) {
        const pw = this.password.value;
        const cpw = this.confirmPassword.value;
        if (pw !== cpw) {
            alert('비밀번호가 일치하지 않습니다.');
            e.preventDefault();
        }
    });

    // 다음 우편번호
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function (data) {
                document.getElementById('zipCode').value = data.zonecode;
                document.getElementById('address1').value = data.address;
                document.getElementById('address2').focus();
            }
        }).open();
    }
</script>

</body>
</html>
