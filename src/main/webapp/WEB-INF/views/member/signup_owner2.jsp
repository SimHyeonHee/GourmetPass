<%-- 
    [1] 페이지 설정 지시어
    - isELIgnored="false": ${kakaoJsKey} 같은 코드를 자바값으로 바꾸라는 뜻
    - taglib: JSTL 사용 선언 (필수)
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>점주 회원가입 - 2단계 (가게 정보)</title>

<!-- [2] 필수 라이브러리 (1단계와 동일) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- 지도 API: 가게 위치 좌표를 따기 위해 필수 -->
<script type="text/javascript" 
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style>
    .msg-ok { color: green; font-size: 12px; font-weight: bold; }
    .msg-no { color: red; font-size: 12px; font-weight: bold; }
    table { margin-top: 20px; border-collapse: collapse; }
    td { padding: 10px; }
    .step-info { color: #666; font-size: 14px; margin-bottom: 10px; }
</style>
</head>
<body>
    <h2 align="center">점주 회원가입 - 2단계 (가게 정보)</h2>
    
    <!-- 안내 문구: 사용자가 "아, 1단계는 끝났구나"라고 알 수 있게 해줌 -->
    <p align="center" class="step-info">사장님 계정 생성이 완료되었습니다.
    이제 운영하실 <b>가게 정보</b>를 입력해주세요.</p>
    
    <%-- 
        [3] 최종 전송 폼 (Final)
        - action: "/member/signup/ownerFinal"
        - 이 컨트롤러 메서드에서 [1단계 정보(세션) + 2단계 정보(여기)]를 합쳐서 DB에 저장함
    --%>
    <form action="${pageContext.request.contextPath}/member/signup/ownerFinal" method="post" id="ownerStep2Form">
        
        <%-- CSRF 토큰: 보안 필수! --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        
        <!-- [중요] 가게 좌표 정보
             사용자가 주소를 검색하면 자동으로 채워짐. 맛집 지도 서비스의 핵심 데이터! -->
        <input type="hidden" name="store_lat" id="store_lat" value="0.0">
        <input type="hidden" name="store_lon" id="store_lon" value="0.0">

        <table border="1" align="center">
            <tr>
                <td width="120">가게 이름</td>
                <td>
                    <input type="text" name="store_nm" id="store_nm" placeholder="예: 구르메 식당" required size="30">
                </td>
            </tr>
            <tr>
                <td>가게 전화번호</td>
                <td>
                    <input type="text" name="store_tel" required placeholder="가게 번호를 입력하세요" 
                           maxlength="13" oninput="autoHyphen(this)">
                </td>
            </tr>
            <tr>
                <td>가게 주소</td>
                <td>
                    <input type="text" name="store_zip" id="store_zip" placeholder="우편번호" readonly>
                    <!-- 클릭 시 '가게 위치 검색' 팝업 뜸 -->
                    <button type="button" onclick="execDaumPostcode()">가게 위치 검색</button><br>
                    
                    <input type="text" name="store_addr1" id="store_addr1" placeholder="가게 기본주소" size="40" readonly><br>
                    <input type="text" name="store_addr2" id="store_addr2" placeholder="가게 상세주소(층, 호수 등)">
                    
                    <!-- 좌표 변환 결과 -->
                    <div id="coordStatus" style="color: blue; font-size: 12px; margin-top: 5px;">
                        주소를 검색하면 매장 지도가 자동으로 매핑됩니다.
                    </div>
                </td>
            </tr>
            <tr>
                <td>가게 소개</td>
                <td>
                    <!-- textarea: 긴 글을 쓸 수 있는 큰 입력창 -->
                    <textarea name="store_info" rows="5" cols="40" placeholder="가게를 소개하는 문구를 입력해주세요."></textarea>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <!-- 버튼 텍스트가 '가입 완료'로 되어 있음 -->
                    <input type="submit" value="최종 가입 완료">
                    <!-- history.back(): 브라우저 뒤로가기 버튼과 똑같은 기능 (1단계로 돌아감) -->
                    <input type="button" value="이전으로" onclick="history.back();">
                </td>
            </tr>
        </table>
    </form>

<script>
    // [4] 주소 검색 및 좌표 변환 (핵심 기능)
    // 1단계(집주소)와 로직은 같지만, 저장하는 변수명(store_lat 등)이 다름
    const geocoder = new kakao.maps.services.Geocoder();

    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 1. 주소 채우기
                var addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                document.getElementById('store_zip').value = data.zonecode;
                document.getElementById('store_addr1').value = addr;

                // 2. 좌표 변환 (가게 위치!)
                geocoder.addressSearch(addr, function(results, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        var result = results[0];
                        
                        // [중요] 변환된 좌표를 hidden input에 저장
                        document.getElementById('store_lat').value = result.y;
                        document.getElementById('store_lon').value = result.x;
                        
                        var msg = "📍 매장 좌표 추출 완료! (위도: " + result.y + ", 경도: " + result.x + ")";
                        $("#coordStatus").html("<span class='msg-ok'>" + msg + "</span>");
                    } else {
                        $("#coordStatus").html("<span class='msg-no'>❌ 좌표 추출 실패</span>");
                    }
                });
                document.getElementById('store_addr2').focus();
            }
        }).open();
    }

    // [5] 전화번호 자동 하이픈
    const autoHyphen = (target) => {
        target.value = target.value
            .replace(/[^0-9]/g, '')
            .replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3").replace(/(\-{1,2})$/g, "");
    }

    // [6] 최종 제출 전 유효성 검사
    $("#ownerStep2Form").submit(function() {
        // 가게 좌표가 없으면(즉, 주소 검색을 안 했으면) 가입 막음!
        // 왜냐하면 맛집 지도 서비스인데 좌표가 없으면 지도에 표시를 못 하니까.
        if($("#store_lat").val() == "0.0") {
            alert("가게 주소 검색을 통해 위치를 지정해주세요.");
            return false; // 전송 중단
        }
        return true; // 전송 허용 -> 컨트롤러(/member/signup/ownerFinal)로 이동
    });
</script>
</body>
</html>
