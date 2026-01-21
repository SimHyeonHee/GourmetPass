<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<jsp:include page="../common/header.jsp" />

<%-- 공용 스타일시트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/mypage.css'/>">

<div class="detail-wrapper" style="max-width: 900px; margin: 40px auto;">
    
    <%-- 1. 상단 요약 헤더 --%>
    <div class="dashboard-card" style="margin-bottom: 40px;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end;">
            <div>
                <span class="badge-wire" style="margin-bottom: 10px; display: inline-block;">REVIEW BOARD</span>
                <h2 style="font-size: 32px; font-weight: 900; margin: 0;">${store.store_name} <small style="font-size: 18px; color: #666; font-weight: normal;">전체 리뷰</small></h2>
            </div>
            <div style="text-align: right;">
                <div style="font-size: 24px; font-weight: 900; color: #f1c40f;">
                    ⭐ ${store.avg_rating} <span style="font-size: 16px; color: #333; margin-left: 5px;">(${allReviews.size()}건)</span>
                </div>
            </div>
        </div>
    </div>

    <%-- 2. 리뷰 목록 섹션 --%>
    <div class="review-container">
        <c:choose>
            <c:when test="${not empty allReviews}">
                <c:forEach var="rev" items="${allReviews}">
                    <div class="item-card" style="margin-bottom: 30px; padding: 30px;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 20px; border-bottom: 1px dashed #ddd; padding-bottom: 15px;">
                            <div style="display: flex; align-items: center; gap: 15px;">
                                <strong style="font-size: 18px; font-weight: 900;">${rev.user_nm} <small style="font-weight: normal; color: #999;">고객님</small></strong>
                                <span style="color: #f1c40f;">
                                    <c:forEach begin="1" end="${rev.rating}">⭐</c:forEach>
                                </span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 15px;">
                                <span style="color: #aaa; font-size: 14px; font-weight: 800;">
                                    <fmt:formatDate value="${rev.review_date}" pattern="yyyy.MM.dd" />
                                </span>
                                
                                <%-- [관리 기능] 로그인한 유저가 본인이거나, 점주일 경우 삭제 버튼 노출 --%>
                                <sec:authorize access="isAuthenticated()">
                                    <c:if test="${rev.user_id == pageContext.request.userPrincipal.name or pageContext.request.isUserInRole('ROLE_OWNER')}">
                                        <button type="button" class="btn-wire" 
                                                style="height: 30px; padding: 0 10px; font-size: 11px; color: #dc3545; border-color: #dc3545;"
                                                onclick="confirmDeleteReview('${rev.review_id}', '${rev.store_id}')">삭제</button>
                                    </c:if>
                                </sec:authorize>
                            </div>
                        </div>

                        <div style="display: flex; gap: 25px; align-items: flex-start;">
                            <c:if test="${not empty rev.img_url}">
                                <div style="flex: 0 0 160px; height: 160px; border: 2px solid #333; border-radius: 12px; overflow: hidden;">
                                    <img src="<c:url value='/upload/${rev.img_url}'/>" style="width: 100%; height: 100%; object-fit: cover;">
                                </div>
                            </c:if>
                            <div style="flex: 1;">
                                <p style="line-height: 1.8; font-size: 16px; color: #444; margin: 0;">${rev.content}</p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="dashboard-card" style="text-align: center; padding: 100px 0; color: #ccc; font-weight: 900; border-style: dashed;">
                    아직 등록된 리뷰가 없습니다.
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- 3. 하단 네비게이션 --%>
    <div style="text-align: center; margin-top: 50px;">
        <button type="button" class="btn-wire" style="width: 200px; height: 55px;" onclick="history.back()">이전 페이지로</button>
    </div>
</div>

<%-- 스크립트 설정 --%>
<script>
    const APP_CONFIG = {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}"
    };
</script>
<script src="<c:url value='/resources/js/member_mypage.js'/>"></script>

<jsp:include page="../common/footer.jsp" />