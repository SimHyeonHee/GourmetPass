<%-- 
    [1] 페이지 설정
    - contentType: 한글 깨짐 방지
    - taglib (sec): Spring Security 태그 (로그인 상태에 따라 버튼을 바꾸기 위해 필요)
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!-- 
    [2] 여백 확보용 빈 박스
    - 하단 바(Footer)가 화면 바닥에 고정(fixed)되어 있기 때문에, 
      본문 내용의 맨 아래쪽이 가려지는 것을 막기 위해 100px만큼 공간을 미리 띄워줍니다.
-->
<div style="height: 100px;"></div> 

<!-- 
    [3] 하단 고정 네비게이션 바 (Bottom Nav Bar)
    - position: fixed; bottom: 0; -> 화면 맨 아래에 본드처럼 딱 붙임 (스크롤해도 따라다님)
    - z-index: 1030; -> 다른 요소들보다 위에 떠있게 함 (가려지지 않게)
-->
<div style="position: fixed; bottom: 0; left: 0; width: 100%; height: 70px; background-color: #f9f9f9; border-top: 2px solid #ddd; z-index: 1030;">
    
    <!-- 메뉴 4개를 균등하게 나누기 위해 테이블 사용 (width: 25%씩 자동 배분) -->
    <table style="width: 100%; height: 100%; border-collapse: collapse; table-layout: fixed;">
        <tr>
            
            <!-- [메뉴 1] 홈 버튼 -->
            <td style="text-align: center; border: 1px solid #eee;">
                <a href="${pageContext.request.contextPath}/" style="display: block; text-decoration: none; color: #666;">
                    <div style="font-size: 20px;">🏠</div> <!-- 아이콘 -->
                    <div style="font-size: 12px; font-weight: bold;">홈</div> <!-- 텍스트 -->
                </a>
            </td>
            
            <!-- [메뉴 2] 검색 버튼 -->
            <td style="text-align: center; border: 1px solid #eee;">
                <a href="${pageContext.request.contextPath}/store/list" style="display: block; text-decoration: none; color: #666;">
                    <div style="font-size: 20px;">🔍</div>
                    <div style="font-size: 12px; font-weight: bold;">검색</div>
                </a>
            </td>
            
            <!-- [메뉴 3] 이용현황 (스마트한 버튼) -->
            <td style="text-align: center; border: 1px solid #eee;">
                <%-- 상황 1: 로그인 안 한 사람 --%>
                <sec:authorize access="isAnonymous()">
                    <!-- 누르면 로그인 페이지로 보냄 -->
                    <a href="${pageContext.request.contextPath}/member/login" style="display: block; text-decoration: none; color: #666;">
                        <div style="font-size: 20px;">📅</div>
                        <div style="font-size: 12px; font-weight: bold;">이용현황</div>
                    </a>
                </sec:authorize>
                
                <%-- 상황 2: 로그인 한 사람 --%>
                <sec:authorize access="isAuthenticated()">
                    <!-- 진짜 내 예약 현황 페이지로 보냄 (색상도 주황색으로 강조!) -->
                    <a href="${pageContext.request.contextPath}/wait/myStatus" style="display: block; text-decoration: none; color: #ff3d00;">
                        <div style="font-size: 20px;">📅</div>
                        <div style="font-size: 12px; font-weight: bold;">이용현황</div>
                    </a>
                </sec:authorize>
            </td>
            
            <!-- [메뉴 4] 마이페이지 (변신하는 버튼) -->
            <td style="text-align: center; border: 1px solid #eee;">
                <%-- 상황 1: 로그인 안 한 사람 -> '로그인' 버튼으로 보임 --%>
                <sec:authorize access="isAnonymous()">
                    <a href="${pageContext.request.contextPath}/member/login" style="display: block; text-decoration: none; color: #666;">
                        <div style="font-size: 20px;">👤</div>
                        <div style="font-size: 12px; font-weight: bold;">로그인</div>
                    </a>
                </sec:authorize>
                
                <%-- 상황 2: 로그인 한 사람 --%>
                <sec:authorize access="isAuthenticated()">
                    
                    <%-- (A) 사장님인 경우 -> '매장관리' 버튼으로 변신 (빨간색) --%>
                    <sec:authorize access="hasRole('ROLE_OWNER')">
                        <a href="${pageContext.request.contextPath}/member/mypage_owner" style="display: block; text-decoration: none; color: #d9534f;">
                            <div style="font-size: 20px;">🏪</div>
                            <div style="font-size: 12px; font-weight: bold;">매장관리</div>
                        </a>
                    </sec:authorize>
                    
                    <%-- (B) 일반손님인 경우 -> 'MY' 버튼으로 변신 (검정색) --%>
                    <sec:authorize access="hasRole('ROLE_USER')">
                        <a href="${pageContext.request.contextPath}/member/mypage" style="display: block; text-decoration: none; color: #333;">
                            <div style="font-size: 20px;">👤</div>
                            <div style="font-size: 12px; font-weight: bold;">MY</div>
                        </a>
                    </sec:authorize>
                </sec:authorize>
            </td>
        </tr>
    </table>
</div>

<!-- 부트스트랩 JS: 혹시 모달창이나 드롭다운 쓸까봐 넣어둠 (선택사항) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- 
    [참고] </body>와 </html> 태그가 여기에 있는 이유:
    이 파일(footer.jsp)은 항상 페이지의 '가장 마지막'에 조립되기 때문입니다.
    header.jsp에서 열었던 <html> 태그를 여기서 닫아주는 구조입니다.
-->
</body>
</html>
