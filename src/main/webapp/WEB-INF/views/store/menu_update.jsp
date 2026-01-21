<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="../common/header.jsp" />

<%-- 통합 스타일시트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="edit-wrapper">
    <div class="edit-title">✏️ 메뉴 정보 수정</div>
    
    <%-- 
        enctype="multipart/form-data" 사용 시 CSRF 필터 대응을 위해 
        action URL 뒤에 직접 토큰을 쿼리 스트링으로 포함합니다. 
    --%>
    <form action="${pageContext.request.contextPath}/store/menu/update?${_csrf.parameterName}=${_csrf.token}" 
          method="post" 
          enctype="multipart/form-data">
          
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        
        <input type="hidden" name="menu_id" value="${menu.menu_id}">
        <input type="hidden" name="store_id" value="${menu.store_id}">
        <input type="hidden" name="menu_img" value="${menu.menu_img}"> 
        
        <table class="edit-table">
            <tr>
                <th>메뉴명</th>
                <td>
                    <input type="text" name="menu_name" value="${menu.menu_name}" 
                           class="login-input" required placeholder="메뉴 이름을 입력하세요">
                </td>
            </tr>
            <tr>
                <th>가격</th>
                <td>
                    <input type="number" name="menu_price" value="${menu.menu_price}" 
                           class="login-input" required placeholder="가격을 입력하세요">
                </td>
            </tr>
            <tr>
                <th>메뉴 이미지</th>
                <td>
                    <c:if test="${not empty menu.menu_img}">
                        <div style="margin-bottom: 15px;">
                            <img src="${pageContext.request.contextPath}/upload/${menu.menu_img}" 
                                 width="120" style="border: 2px solid #333; border-radius: 10px;">
                        </div>
                    </c:if>
                    <input type="file" name="file" class="login-input" style="padding-top: 10px;">
                    <div class="msg-box" style="color: #888;">교체 시에만 파일을 선택해 주세요.</div>
                </td>
            </tr>
            <tr>
                <th>대표메뉴 여부</th>
                <td>
                    <div style="display: flex; align-items: center; gap: 10px; height: 50px;">
                        <input type="checkbox" name="menu_sign" value="Y" 
                               ${menu.menu_sign == 'Y' ? 'checked' : ''} 
                               style="width: 20px; height: 20px; cursor: pointer;">
                        <span style="font-weight: 800; font-size: 14px;">대표 메뉴로 설정</span>
                    </div>
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