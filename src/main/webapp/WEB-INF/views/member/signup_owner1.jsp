<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="edit-wrapper">
    <div class="edit-title">👨‍🍳 점주 가입 - 1단계 (계정)</div>
    
    <form action="${pageContext.request.contextPath}/member/signup/ownerStep1" method="post" id="joinForm">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

        <table class="edit-table">
            <tr>
                <th>아이디</th>
                <td>
                    <div class="input-row">
                        <input type="text" name="user_id" id="user_id" required placeholder="3글자 이상">
                        <button type="button" id="btnIdCheck" class="btn-wire">중복확인</button>
                    </div>
                    <div id="idCheckMsg" class="msg-box"></div>
                </td>
            </tr>
            <tr>
                <th>비밀번호</th>
                <td><input type="password" name="user_pw" id="user_pw" required placeholder="비밀번호를 입력하세요"></td>
            </tr>
            <tr>
                <th>비밀번호 확인</th>
                <td>
                    <input type="password" id="user_pw_confirm" required placeholder="비밀번호를 다시 입력하세요">
                    <div id="pwCheckMsg" class="msg-box"></div>
                </td>
            </tr>
            <tr>
                <th>성명</th>
                <td><input type="text" name="user_nm" required placeholder="본인의 실명을 입력하세요"></td>
            </tr>
            <tr>
                <th>전화번호</th>
                <td><input type="text" name="user_tel" required oninput="autoHyphen(this)" maxlength="13" placeholder="숫자만 입력"></td>
            </tr>
            <tr>
                <th>거주지 주소</th>
                <td>
                    <div class="input-row mb-10">
                        <input type="text" name="user_zip" id="user_zip" style="width:120px; flex:none;" readonly placeholder="우편번호">
                        <button type="button" onclick="execDaumPostcode('user')" class="btn-wire">주소검색</button>
                    </div>
                    <input type="text" name="user_addr1" id="user_addr1" class="mb-10" readonly placeholder="기본주소">
                    <input type="text" name="user_addr2" id="user_addr2" placeholder="상세주소">
                    <div id="coordStatus" class="msg-box msg-ok">주소 검색 시 좌표가 자동 입력됩니다.</div>
                </td>
            </tr>
        </table>

        <div class="btn-group">
            <button type="submit" class="btn-submit">다음 단계로 (가게 정보 입력)</button>
            <a href="<c:url value='/member/signup/select'/>" class="btn-cancel">이전으로</a>
        </div>
    </form>
</div>

<script src="<c:url value='/resources/js/common.js'/>"></script>
<script src="<c:url value='/resources/js/member.js'/>"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="<c:url value='/resources/js/address-api.js'/>"></script>

<jsp:include page="../common/footer.jsp" />