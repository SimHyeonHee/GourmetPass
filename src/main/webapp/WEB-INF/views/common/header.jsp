<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Gourmet Pass (Basic)</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
    /* 최소한의 정렬만 위한 스타일 */
    body { text-align: center; font-family: sans-serif; }
    table { margin: 0 auto; width: 80%; border-collapse: collapse; }
    th, td { padding: 10px; border: 1px solid #ccc; }
    a { text-decoration: none; color: black; font-weight: bold; }
    a:hover { color: red; }
    .nav-bar { background-color: #eee; padding: 10px; margin-bottom: 20px; border-bottom: 2px solid #ddd; }
</style>
</head>
<body>

<div class="nav-bar">
    <table style="border: none; width: 100%;">
        <tr style="border: none;">
            <td style="border: none; text-align: left; width: 30%;">
                <h2 style="margin: 0;"><a href="${pageContext.request.contextPath}/">Gourmet Pass</a></h2>
            </td>
            
            <td style="border: none; text-align: right;">
                <a href="${pageContext.request.contextPath}/store/list">[맛집 검색]</a>
                
                <sec:authorize access="isAnonymous()">
                    | <a href="${pageContext.request.contextPath}/member/login">로그인</a>
                    | <a href="${pageContext.request.contextPath}/member/signup/select">회원가입</a>
                </sec:authorize>
                
                <sec:authorize access="isAuthenticated()">
                    <sec:authentication property="principal" var="user" />
                    <%-- [수정] userNm 대신 시큐리티 User 객체의 기본 속성인 username 사용 --%>
                    | <span><b>${user.username}</b>님</span>
                    
                    <sec:authorize access="hasRole('ROLE_OWNER')">
                        | <a href="${pageContext.request.contextPath}/member/mypage_owner" style="color: blue;">[매장관리]</a>
                    </sec:authorize>
                    
                    <sec:authorize access="hasRole('ROLE_USER')">
                        | <a href="${pageContext.request.contextPath}/member/mypage">[마이페이지]</a>
                    </sec:authorize>
                    
                    | 
                    <%-- [수정] 로그아웃 경로를 /logout으로 변경 및 CSRF 토큰 유지 --%>
                    <form action="${pageContext.request.contextPath}/logout" method="post" style="display: inline;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit">로그아웃</button>
                    </form>
                </sec:authorize>
            </td>
        </tr>
    </table>
</div>