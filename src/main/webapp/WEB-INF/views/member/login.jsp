<%-- WEB-INF/views/member/login.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<jsp:include page="../common/header.jsp" />

<%-- 통합 스타일시트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<%-- 알림 데이터 보관 --%>
<div id="auth-msg" data-error="${param.error}" data-logout="${param.logout}"></div>

<div class="login-wrapper">
    <div class="login-title">GOURMET PASS</div>
    
    <form action="${pageContext.request.contextPath}/login" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

        <div class="form-group">
            <label>아이디</label>
            <input type="text" name="username" class="login-input" required placeholder="아이디를 입력하세요">
        </div>

        <div class="form-group">
            <label>비밀번호</label>
            <input type="password" name="password" class="login-input" required placeholder="비밀번호를 입력하세요">
        </div>

        <%-- 버튼 그룹: 1:1 대칭 정렬 --%>
        <div class="btn-group">
            <button type="submit" class="btn-login">로그인</button>
            <a href="<c:url value='/member/signup/select'/>" class="btn-signup">회원가입</a>
        </div>
    </form>
    
    <div style="margin-top: 25px; font-size: 13px; color: #999;">
        <a href="#" style="text-decoration: underline;">아이디/비밀번호를 잊으셨나요?</a>
    </div>
</div>

<script src="<c:url value='/resources/js/member.js'/>"></script>
<jsp:include page="../common/footer.jsp" />