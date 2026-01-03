<%-- 
    [1] 페이지 설정
    - contentType, pageEncoding: 한글 깨짐 방지
    - taglib: JSTL(c:if 등) 사용 선언
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 로그인</title>
</head>
<body>
    
    <%-- 
        [2-1] 로그인 실패 메시지 처리
        - 상황: 아이디/비번 틀림
        - 동작: Security가 '/member/login?error'로 리다이렉트 시킴
        - 결과: param.error가 존재하므로 경고창 뜸
    --%>
    <c:if test="${not empty param.error}">
        <script>alert("아이디 또는 비밀번호가 잘못되었습니다.");</script>
    </c:if>

    <%-- 
        [2-2] 로그아웃 성공 메시지 처리 (New!)
        - 상황: 사용자가 로그아웃 버튼 누름
        - 동작: Security가 로그아웃 처리 후 '/member/login?logout'으로 리다이렉트 시킴
              (security-context.xml에서 logout-success-url="/member/login?logout" 설정 필요)
        - 결과: param.logout이 존재하므로 알림창 뜸 -> logoutMsg.jsp 파일 불필요!
    --%>
    <c:if test="${not empty param.logout}">
        <script>alert("성공적으로 로그아웃되었습니다. 이용해 주셔서 감사합니다.");</script>
    </c:if>

    <%-- 
        [3] 로그인 폼 (Form)
        - action: "${pageContext.request.contextPath}/login"
          (중요) 이 주소는 실제 컨트롤러(Controller)에는 없습니다!
          Spring Security 필터가 요청을 중간에 낚아채서 로그인 처리를 수행하는 '가상 주소'입니다.
    --%>
    <form action="${pageContext.request.contextPath}/login" method="post">
        
        <%-- 
            [보안 핵심] CSRF 토큰
            - 해커가 가짜 사이트에서 로그인 요청을 보내는 것을 막기 위한 '인증 티켓'입니다.
            - Security를 쓸 때 POST 전송에는 이 태그가 무조건! 필수입니다.
        --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

        <table border="1" align="center">
            <tr>
                <td colspan="2" align="center"><h3>Gourmet Pass 로그인</h3></td>
            </tr>
            <tr>
                <td>아이디:</td>
                <%-- 
                    [이름 주의!] name="username"
                    - 내 DB 컬럼명이 'user_id'여도 여기선 'username'이라고 써야 합니다.
                    - Security 기본 설정이 이 이름을 찾기 때문입니다.
                --%>
                <td><input type="text" name="username" required placeholder="ID"></td>
            </tr> 
            <tr>
                <td>비밀번호:</td>
                <%-- 
                    [이름 주의!] name="password"
                    - 마찬가지로 Security 기본 약속 이름인 'password'를 사용해야 합니다.
                --%>
                <td><input type="password" name="password" required placeholder="Password"></td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <!-- 로그인 버튼 (Submit) -->
                    <input type="submit" value="로그인">
                    
                    <%-- 
                        [회원가입 이동 버튼]
                        - 일반/점주 선택 페이지(/member/signup/select)로 이동합니다.
                    --%>
                    <input type="button" value="회원가입" 
                           onclick="location.href='${pageContext.request.contextPath}/member/signup/select'">
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
