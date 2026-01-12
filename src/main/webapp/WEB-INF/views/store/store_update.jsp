<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%> 

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<script src="<c:url value='/resources/js/common.js'/>"></script>
<script src="<c:url value='/resources/js/address-api.js'/>"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>

<div class="edit-wrapper">
    <div class="edit-title">🛠️ 가게 정보 수정</div>
    
    <%-- [403 에러 해결 핵심] action 주소 뒤에 CSRF 토큰을 쿼리 스트링으로 추가 --%>
    <form action="${pageContext.request.contextPath}/store/update?${_csrf.parameterName}=${_csrf.token}" 
          method="post" enctype="multipart/form-data" id="storeUpdateForm">
        
        <%-- 기존의 hidden 토큰도 유지합니다 (이중 안전장치) --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

        <input type="hidden" name="store_id" value="${store.store_id}">
        <input type="hidden" name="store_img" value="${store.store_img}">
        <input type="hidden" name="user_id" value="${store.user_id}">
        <input type="hidden" name="store_lat" id="store_lat" value="${store.store_lat}">
        <input type="hidden" name="store_lon" id="store_lon" value="${store.store_lon}">

        <table class="edit-table">
            <tr>
                <th>가게 이름</th>
                <td><input type="text" name="store_name" value="${store.store_name}" class="signup-input" required></td>
            </tr>
            <tr>
                <th>카테고리</th>
                <td>
                    <select name="store_category" class="signup-select" required>
                        <option value="한식" ${store.store_category == '한식' ? 'selected' : ''}>한식</option>
                        <option value="양식" ${store.store_category == '양식' ? 'selected' : ''}>양식</option>
                        <option value="일식" ${store.store_category == '일식' ? 'selected' : ''}>일식</option>
                        <option value="중식" ${store.store_category == '중식' ? 'selected' : ''}>중식</option>
                        <option value="카페" ${store.store_category == '카페' ? 'selected' : ''}>카페/디저트</option>
                        <option value="기타" ${store.store_category == '기타' ? 'selected' : ''}>기타</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>가게 번호</th>
                <td><input type="text" name="store_tel" value="${store.store_tel}" class="signup-input" oninput="autoHyphen(this)" maxlength="13"></td>
            </tr>
            <tr>
                <th>가게 주소</th>
                <td>
                    <div class="input-row">
                        <input type="text" name="store_zip" id="store_zip" value="${store.store_zip}" class="signup-input" style="width: 120px; flex: none;" readonly>
                        <button type="button" onclick="execDaumPostcode('store')" class="btn-wire">주소 검색</button>
                    </div>
                    <input type="text" name="store_addr1" id="store_addr1" value="${store.store_addr1}" class="signup-input" style="margin-top:8px;" readonly>
                    <input type="text" name="store_addr2" id="store_addr2" value="${store.store_addr2}" class="signup-input" style="margin-top:8px;">
                </td>
            </tr>
            <tr>
                <th>영업 시간</th>
                <td>
                    <div class="input-row">
                        <input type="time" name="open_time" value="${store.open_time}" class="signup-input" style="flex:1;">
                        <span>~</span>
                        <input type="time" name="close_time" value="${store.close_time}" class="signup-input" style="flex:1;">
                    </div>
                </td>
            </tr>
            <tr>
                <th>예약 단위</th>
                <td>
                    <select name="res_unit" class="signup-select">
                        <option value="30" ${store.res_unit == 30 ? 'selected' : ''}>30분 단위</option>
                        <option value="60" ${store.res_unit == 60 ? 'selected' : ''}>1시간 단위</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>매장 소개</th>
                <td><textarea name="store_desc" rows="5" class="signup-input" style="resize:none;">${store.store_desc}</textarea></td>
            </tr>
            <tr>
                <th>대표 이미지</th>
                <td>
                    <c:if test="${not empty store.store_img}">
                        <div style="margin-bottom: 10px;">
                            <img src="${pageContext.request.contextPath}/upload/${store.store_img}" width="120" style="border: 2px solid #333; border-radius: 8px;">
                        </div>
                    </c:if>
                    <input type="file" name="file" class="signup-input">
                </td>
            </tr>
        </table>

        <div class="btn-group">
            <button type="submit" class="btn-submit">수정 완료</button>
            <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
        </div>
    </form>
</div>

<jsp:include page="../common/footer.jsp" />