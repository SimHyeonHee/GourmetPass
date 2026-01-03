<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 로그인</title>
</head>
<body>
    <c:if test="${not empty param.error}">
        <script>alert("아이디 또는 비밀번호가 잘못되었습니다.");</script>
    </c:if>

    <%-- Spring Security 로그인 처리는 보통 '/login' 경로로 POST 요청을 보냅니다. --%>
    <form action="${pageContext.request.contextPath}/login" method="post">
        
        <%-- [중요] Spring Security CSRF 토큰 추가 --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

        <table border="1" align="center">
            <tr>
                <td colspan="2" align="center"><h3>Gourmet Pass 로그인</h3></td>
            </tr>
            <tr>
                <td>아이디:</td>
                <%-- 시큐리티 기본 파라미터명은 'username'입니다 --%>
                <td><input type="text" name="username" required placeholder="ID"></td>
            </tr> 
            <tr>
                <td>비밀번호:</td>
                <%-- 시큐리티 기본 파라미터명은 'password'입니다 --%>
                <td><input type="password" name="password" required placeholder="Password"></td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="submit" value="로그인">
                    
                    <%-- 회원가입 페이지 경로 수정 --%>
                    <input type="button" value="회원가입" 
                           onclick="location.href='${pageContext.request.contextPath}/member/signup/select'">
                </td>
            </tr>
        </table>
    </form>
</body>
</html>