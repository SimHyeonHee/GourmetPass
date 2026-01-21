<%-- WEB-INF/views/member/member_edit.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="../common/header.jsp" />

<%-- [원칙 1] 통합 스타일시트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="edit-wrapper">
    <div class="edit-title">⚙️ 회원 정보 수정</div>

    <form action="<c:url value='/member/updateProcess'/>" method="post" id="joinForm">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="user_lat" id="user_lat" value="${member.user_lat}">
        <input type="hidden" name="user_lon" id="user_lon" value="${member.user_lon}">

        <table class="edit-table">
            <tr>
                <th>아이디</th>
                <td>
                    <%-- readonly 속성으로 수정 불가함을 명시 --%>
                    <input type="text" name="user_id" id="user_id" value="${member.user_id}" readonly>
                </td>
            </tr>
            <tr>
                <th>새 비밀번호</th>
                <td><input type="password" name="user_pw" id="user_pw" placeholder="변경 시에만 입력하세요"></td>
            </tr>
            <tr>
                <th>비밀번호 확인</th>
                <td>
                    <input type="password" id="user_pw_confirm" placeholder="비밀번호를 한 번 더 입력하세요">
                    <div id="pwCheckMsg" class="msg-box"></div>
                </td>
            </tr>
            <tr>
                <th>성명</th>
                <td><input type="text" name="user_nm" value="${member.user_nm}" required placeholder="성함을 입력하세요"></td>
            </tr>
            <tr>
                <th>전화번호</th>
                <td>
                    <input type="text" name="user_tel" value="${member.user_tel}" required 
                           oninput="autoHyphen(this)" maxlength="13" placeholder="숫자만 입력">
                </td>
            </tr>
            <tr>
                <th>주소</th>
                <td>
                    <%-- [교정] input-row 클래스를 사용하여 우편번호와 버튼 정렬 일치 --%>
                    <div class="input-row mb-10">
                        <input type="text" name="user_zip" id="user_zip" value="${member.user_zip}" 
                               style="width: 120px; flex: none;" readonly placeholder="우편번호">
                        <button type="button" onclick="execDaumPostcode('user')" class="btn-wire">주소검색</button>
                    </div>
                    <input type="text" name="user_addr1" id="user_addr1" value="${member.user_addr1}" 
                           class="mb-10" readonly placeholder="기본주소">
                    <input type="text" name="user_addr2" id="user_addr2" value="${member.user_addr2}" 
                           placeholder="상세 주소를 입력하세요">
                    <div id="coordStatus" class="msg-box msg-ok">주소 변경 시 위치 정보가 자동으로 갱신됩니다.</div>
                </td>
            </tr>
        </table>

        <%-- [교정] 하단 버튼 배치: 대칭형 Bold Wire 디자인 --%>
        <div class="btn-group">
            <button type="submit" class="btn-submit">정보 수정 완료</button>
            <a href="<c:url value='/member/mypage'/>" class="btn-cancel">취소</a>
        </div>
    </form>

    <%-- [교정] 탈퇴 섹션 디자인 정돈 --%>
    <div class="withdraw-section">
        <button type="button" class="btn-link-withdraw" onclick="dropUser('${member.user_id}')">
            회원 탈퇴하기
        </button>
    </div>
</div>

<%-- [원칙 1] 스크립트 분리 및 API 연결 --%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="<c:url value='/resources/js/address-api.js'/>"></script>
<script src="<c:url value='/resources/js/common.js'/>"></script>
<script src="<c:url value='/resources/js/member.js'/>"></script>

<jsp:include page="../common/footer.jsp" />