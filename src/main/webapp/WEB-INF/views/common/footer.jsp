<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

    </div> 
    
    <div style="height: 100px;"></div> 

    <div style="position: fixed; bottom: 0; left: 0; width: 100%; height: 70px; background-color: #f9f9f9; border-top: 2px solid #ddd; z-index: 1030;">
        <div style="width: 80%; margin: 0 auto; height: 100%; display: flex; justify-content: space-around; align-items: center;">
            
            <a href="<c:url value='/'/>" style="text-align: center; text-decoration: none; color: #333;">🏠<br><small>홈</small></a>
            
            <a href="<c:url value='/store/list'/>" style="text-align: center; text-decoration: none; color: #333;">🔍<br><small>검색</small></a>
            
            <sec:authorize access="isAnonymous()">
                <a href="<c:url value='/member/login'/>" style="text-align: center; text-decoration: none; color: #333;">📅<br><small>이용현황</small></a>
            </sec:authorize>
            
            <sec:authorize access="isAuthenticated()">
                <sec:authorize access="hasRole('ROLE_USER')">
                    <a href="<c:url value='/wait/myStatus'/>" style="text-align: center; text-decoration: none; color: #333;">📅<br><small>이용현황</small></a>
                </sec:authorize>
                <sec:authorize access="hasRole('ROLE_OWNER')">
                    <a href="<c:url value='/book/manage'/>" style="text-align: center; text-decoration: none; color: #333;">📅<br><small>예약관리</small></a>
                </sec:authorize>
            </sec:authorize>
            
            <sec:authorize access="isAnonymous()">
                <a href="<c:url value='/member/login'/>" style="text-align: center; text-decoration: none; color: #333;">👤<br><small>로그인</small></a>
            </sec:authorize>
            
            <sec:authorize access="isAuthenticated()">
                <a href="<c:url value='/member/mypage'/>" style="text-align: center; color: #ff3d00; text-decoration: none;">
                    <sec:authorize access="hasRole('ROLE_OWNER')">🏪<br><small>매장관리</small></sec:authorize>
                    <sec:authorize access="hasRole('ROLE_USER')">👤<br><small>MY</small></sec:authorize>
                </a>
            </sec:authorize>
            
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>