<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 페이지 기본 설정: UTF-8 / HTML 응답 --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%-- JSTL(core/fmt) 선언: 조건/반복 + 숫자 포맷 등에 사용 --%>

<jsp:include page="../common/header.jsp" />
<%-- 공통 헤더 포함 --%>

<div style="width: 60%; margin: 50px auto; padding: 30px; border: 1px solid #ddd; border-radius: 10px; background-color: #fff;">
    <h2 align="center">🛠️ 가게 정보 수정</h2>
    <hr style="margin-bottom: 25px;">

    <%-- [POST + 파일업로드]
         - action: /store/update 로 수정 요청 전송
         - enctype="multipart/form-data": 이미지 파일(file input)을 함께 전송하기 위한 필수 설정 --%>
    <form action="${pageContext.request.contextPath}/store/update" method="post" enctype="multipart/form-data">

        <%-- [보안] CSRF 토큰: POST 전송 시 hidden input으로 함께 보내야 함 --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <%-- Spring Security는 unsafe method(POST 등)에서 CSRF 토큰 전송을 요구하는 설정이 일반적입니다. --%>

        <%-- [핵심] 식별자/기존값 유지
             - store_id: 어떤 가게를 수정하는지 식별
             - store_img: 새 파일을 업로드하지 않으면 기존 이미지명을 유지하려는 목적
             - user_id: 가게 소유자 정보 유지(Controller에서 재검증 권장) --%>
        <input type="hidden" name="store_id" value="${store.store_id}">
        <input type="hidden" name="store_img" value="${store.store_img}">
        <input type="hidden" name="user_id" value="${store.user_id}">

        <%-- [좌표] 주소 검색 시 자동으로 갱신될 위도/경도 hidden 값 --%>
        <input type="hidden" name="store_lat" id="store_lat" value="${store.store_lat}">
        <input type="hidden" name="store_lon" id="store_lon" value="${store.store_lon}">

        <table style="width: 100%; border-collapse: collapse;">
            <tr style="height: 50px;">
                <td style="width: 20%; font-weight: bold;">가게 이름</td>
                <td>
                    <input type="text" name="store_name" value="${store.store_name}" required style="width: 80%; padding: 8px;">
                </td>
            </tr>

            <tr style="height: 50px;">
                <td style="font-weight: bold;">카테고리</td>
                <td>
                    <%-- 선택값 유지: 현재 store.store_category와 같으면 selected --%>
                    <select name="store_category" style="padding: 8px;">
                        <option value="한식" ${store.store_category == '한식' ? 'selected' : ''}>한식</option>
                        <option value="양식" ${store.store_category == '양식' ? 'selected' : ''}>양식</option>
                        <option value="일식" ${store.store_category == '일식' ? 'selected' : ''}>일식</option>
                        <option value="중식" ${store.store_category == '중식' ? 'selected' : ''}>중식</option>
                        <option value="카페" ${store.store_category == '카페' ? 'selected' : ''}>카페/디저트</option>
                    </select>
                </td>
            </tr>

            <tr style="height: 50px;">
                <td style="font-weight: bold;">가게 전화번호</td>
                <td>
                    <input type="text" name="store_tel" value="${store.store_tel}" style="width: 80%; padding: 8px;">
                </td>
            </tr>

            <tr style="height: 120px;">
                <td style="font-weight: bold;">가게 주소</td>
                <td>
                    <%-- 우편번호/기본주소는 "주소 검색"으로 채우는 흐름(readonly) --%>
                    <input type="text" name="store_zip" id="store_zip" value="${store.store_zip}"
                           placeholder="우편번호" readonly style="width: 30%; padding: 8px; margin-bottom: 5px;">
                    <button type="button" onclick="searchAddress()" style="padding: 7px 15px;">주소 검색</button><br>

                    <input type="text" name="store_addr1" id="store_addr1" value="${store.store_addr1}"
                           placeholder="기본 주소" readonly style="width: 80%; padding: 8px; margin-bottom: 5px;"><br>

                    <%-- 상세주소는 사용자가 직접 입력 --%>
                    <input type="text" name="store_addr2" id="store_addr2" value="${store.store_addr2}"
                           placeholder="상세 주소" style="width: 80%; padding: 8px;">
                </td>
            </tr>

            <tr style="height: 50px;">
                <td style="font-weight: bold;">영업 시간</td>
                <td>
                    시작: <input type="time" name="open_time" value="${store.open_time}" style="padding: 8px;">
                    ~
                    종료: <input type="time" name="close_time" value="${store.close_time}" style="padding: 8px;">
                </td>
            </tr>

            <tr style="height: 50px;">
                <td style="font-weight: bold;">예약 단위</td>
                <td>
                    <%-- res_unit 선택값 유지(30/60) --%>
                    <select name="res_unit" style="padding: 8px;">
                        <option value="30" ${store.res_unit == 30 ? 'selected' : ''}>30분 단위</option>
                        <option value="60" ${store.res_unit == 60 ? 'selected' : ''}>1시간 단위</option>
                    </select>
                </td>
            </tr>

            <tr style="height: 150px;">
                <td style="font-weight: bold;">매장 소개</td>
                <td>
                    <textarea name="store_desc" style="width: 80%; height: 100px; padding: 8px;">${store.store_desc}</textarea>
                </td>
            </tr>

            <tr style="height: 120px;">
                <td style="font-weight: bold;">대표 이미지</td>
                <td>
                    <%-- 기존 이미지가 있으면 미리보기 출력 --%>
                    <c:if test="${not empty store.store_img}">
                        <div style="margin-bottom: 10px;">
                            <img src="${pageContext.request.contextPath}/upload/${store.store_img}" width="150"
                                 style="border-radius: 5px; border: 1px solid #ddd;">
                            <p style="font-size: 12px; color: gray;">현재 등록된 이미지</p>
                        </div>
                    </c:if>

                    <%-- 새 이미지 업로드(선택) --%>
                    <input type="file" name="file">
                </td>
            </tr>

            <tr style="height: 80px;">
                <td colspan="2" align="center">
                    <button type="submit"
                            style="padding: 12px 40px; background: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold;">
                        수정 완료
                    </button>
                    <button type="button" onclick="history.back()"
                            style="padding: 12px 40px; background: #f44336; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold; margin-left: 10px;">
                        취소
                    </button>
                </td>
            </tr>
        </table>
    </form>
</div>

<%-- [외부 스크립트] 주소 검색 팝업(우편번호 서비스) --%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<%-- daum.Postcode(...)를 사용하기 위한 라이브러리 로딩 --%>

<%-- [외부 스크립트] 주소→좌표 변환(Geocoder)을 쓰기 위해 services 라이브러리 포함 --%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>

<script>
function searchAddress() {
    // [주소 검색] 팝업에서 주소를 선택하면 oncomplete 콜백이 실행됨
    new daum.Postcode({
        oncomplete: function(data) {
            var addr = data.address; // 선택된 주소 문자열

            // [1] 우편번호/기본주소 입력칸 자동 채움
            document.getElementById('store_zip').value = data.zonecode;
            document.getElementById('store_addr1').value = addr;

            // [2] 주소를 위도/경도로 변환하여 hidden에 저장(상세 페이지 지도/거리 기능 등에 재사용)
            var geocoder = new kakao.maps.services.Geocoder();
            geocoder.addressSearch(addr, function(result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    // Kakao 결과: x=경도(lon), y=위도(lat)
                    document.getElementById('store_lat').value = result[0].y;
                    document.getElementById('store_lon').value = result[0].x;
                }
            });
            // [3] 다음 입력으로 자연스럽게 이동
            document.getElementById('store_addr2').focus();
        }
    }).open();
}
</script>

<jsp:include page="../common/footer.jsp" />
<%-- 공통 푸터 포함 --%>
