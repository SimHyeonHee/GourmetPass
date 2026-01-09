<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 페이지 기본 설정: UTF-8 / HTML 응답 --%>

<jsp:include page="../common/header.jsp" />
<%-- 공통 헤더 포함 --%>

<h2 align="center">➕ 메뉴 등록</h2>

<%-- [POST + 파일업로드]
     - /store/menu/register 로 메뉴 등록 요청
     - enctype="multipart/form-data": 파일(input type="file")을 서버로 전송하려면 필요 --%>
<form action="${pageContext.request.contextPath}/store/menu/register"
      method="post"
      enctype="multipart/form-data">

    <%-- [보안] CSRF 토큰: Spring Security 사용 시 POST 폼에 hidden으로 포함하는 패턴 --%>
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    <%-- Spring Security 문서에서도 HTML form은 hidden input으로 CSRF 토큰을 포함하는 예시를 제공합니다. [web:45] --%>

    <%-- [연결 키] 어떤 가게(store)의 메뉴인지 구분하기 위한 store_id 전달 --%>
    <input type="hidden" name="store_id" value="${param.store_id}">
    <%-- param.store_id: 현재 요청 URL의 쿼리스트링(store_id=...) 값을 그대로 사용 --%>

    <table border="1" align="center" cellpadding="5">
        <%-- 메뉴명 입력 --%>
        <tr>
            <td>메뉴명</td>
            <td><input type="text" name="menu_name" required></td>
        </tr>

        <%-- 가격 입력(number) --%>
        <tr>
            <td>가격</td>
            <td><input type="number" name="menu_price" required></td>
        </tr>

        <%-- 이미지 업로드(file) --%>
        <tr>
            <td>이미지</td>
            <td><input type="file" name="file"></td>
        </tr>

        <%-- 대표메뉴 여부: 체크되면 menu_sign=Y가 전송됨 / 체크 안되면 파라미터 자체가 안 넘어갈 수 있음 --%>
        <tr>
            <td>대표메뉴</td>
            <td>
                <input type="checkbox" name="menu_sign" value="Y"> 대표 메뉴로 설정
            </td>
        </tr>

        <%-- 제출/취소 --%>
        <tr>
            <td colspan="2" align="center">
                <input type="submit" value="등록">
                <input type="button" value="취소" onclick="history.back()">
            </td>
        </tr>
    </table>
</form>

<jsp:include page="../common/footer.jsp" />
<%-- 공통 푸터 포함 --%>
