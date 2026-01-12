<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- [1] 공통 헤더 삽입 (APP_CONFIG 및 기본 레이아웃 포함) --%>
<jsp:include page="../common/header.jsp" />

<%-- [2] 관심사 분리: 통합된 회원 스타일시트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="select-wrapper">
    <h2 style="font-size: 28px; font-weight: 900;">회원가입 유형을 선택해주세요</h2>
    <p style="color: #888;">어떤 목적으로 Gourmet Pass를 이용하시나요?</p>
    
    <div class="select-group">
        <%-- 일반 회원 선택 카드 --%>
        <a href="${pageContext.request.contextPath}/member/signup/general" class="select-card">
            <span class="select-icon">😊</span>
            <span class="select-title">일반 회원</span>
            <span class="select-desc">
                맛집을 예약하고<br>
                웨이팅을 신청하고 싶어요.
            </span>
        </a>

        <%-- 점주 회원 선택 카드 --%>
        <a href="${pageContext.request.contextPath}/member/signup/owner1" class="select-card">
            <span class="select-icon">👨‍🍳</span>
            <span class="select-title">점주 회원</span>
            <span class="select-desc">
                우리 가게를 등록하고<br>
                손님을 받고 싶어요.
            </span>
        </a>
    </div>
</div>

<%-- [3] 공통 푸터 삽입 (하단 메뉴바 포함) --%>
<jsp:include page="../common/footer.jsp" />