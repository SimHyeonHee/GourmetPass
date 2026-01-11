<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
    const APP_CONFIG = {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}",
        userId: "${member.user_id}",
        role: "ROLE_OWNER",
        storeId: "${store.store_id}"
    };

    document.addEventListener("DOMContentLoaded", function() {
        if(typeof initMyPageWebSocket === 'function') {
            initMyPageWebSocket(APP_CONFIG.userId, APP_CONFIG.role, APP_CONFIG.storeId);
        }
    });

    function deleteMenu(menuId) {
        if(confirm("정말 이 메뉴를 삭제하시겠습니까?")) {
            location.href = APP_CONFIG.contextPath + "/store/menu/delete?menu_id=" + menuId;
        }
    }
</script>
<script src="<c:url value='/resources/js/member-mypage.js'/>"></script>

<div style="width: 80%; margin: 0 auto; padding: 40px 0; text-align: center;">
    <div class="dashboard-container" style="text-align: left;">
        <h2>🏠 내 가게 관리 (점주 전용)</h2>
        <p>매장의 영업 정보와 메뉴를 실시간으로 관리하세요.</p>

        <c:choose>
            <c:when test="${not empty store}">
                <div class="owner-grid">
                    <div class="owner-card" style="width: 35%;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                            <h3 style="margin: 0;">가게 정보</h3>
                            <button class="btn-action" onclick="location.href='<c:url value='/store/update?store_id=${store.store_id}'/>'">
                                수정
                            </button>
                        </div>
                        
                        <div style="text-align: center; margin-bottom: 20px;">
                            <c:choose>
                                <c:when test="${not empty store.store_img}">
                                    <img src="<c:url value='/upload/${store.store_img}'/>" class="img-thumbnail">
                                </c:when>
                                <c:otherwise>
                                    <div class="img-placeholder" style="width: 100%; height: 180px; line-height: 180px;">이미지 없음</div>
                                </c:otherwise>
                            </c:choose>
                            <h4 style="margin: 15px 0 5px;">${store.store_name}</h4>
                            <span class="badge-cat">${store.store_category}</span>
                        </div>

                        <table class="info-table" style="border: none;">
                            <tr>
                                <td style="color: #666; border: none; padding: 8px 0;">영업시간</td>
                                <td align="right" style="border: none; padding: 8px 0;">
                                    <b>
                                        <c:if test="${not empty store.open_time}">${store.open_time} ~ ${store.close_time}</c:if>
                                        <c:if test="${empty store.open_time}">미설정</c:if>
                                    </b>
                                </td>
                            </tr>
                            <tr>
                                <td style="color: #666; border: none; padding: 8px 0;">예약단위</td>
                                <td align="right" style="border: none; padding: 8px 0;"><b>${store.res_unit}분</b></td>
                            </tr>
                            <tr>
                                <td style="color: #666; border: none; padding: 8px 0;">가게번호</td>
                                <td align="right" style="border: none; padding: 8px 0;"><b>${store.store_tel}</b></td>
                            </tr>
                        </table>

                        <button class="btn-orange" onclick="location.href='<c:url value='/book/manage?store_id=${store.store_id}'/>'" style="margin-top: 20px;">
                            실시간 예약/웨이팅 관리
                        </button>
                    </div>

                    <div class="owner-card" style="flex: 1;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                            <h3 style="margin: 0;">메뉴 관리 (${menuList.size()})</h3>
                            <button class="btn-success" onclick="location.href='<c:url value='/store/menu/register?store_id=${store.store_id}'/>'">
                                + 메뉴 추가
                            </button>
                        </div>

                        <table class="menu-table" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th>이미지</th><th>메뉴명</th><th>가격</th><th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="menu" items="${menuList}">
                                    <tr>
                                        <td align="center">
                                            <c:if test="${not empty menu.menu_img}">
                                                <img src="<c:url value='/upload/${menu.menu_img}'/>" class="img-menu">
                                            </c:if>
                                        </td>
                                        <td align="left">
                                            <b>${menu.menu_name}</b>
                                            <c:if test="${menu.menu_sign == 'Y'}"><span class="badge-best">대표</span></c:if>
                                        </td>
                                        <td align="right" style="color: #d32f2f;">
                                            <b><fmt:formatNumber value="${menu.menu_price}" pattern="#,###" />원</b>
                                        </td>
                                        <td align="center">
                                            <button class="btn-primary" onclick="location.href='<c:url value='/store/menu/update?menu_id=${menu.menu_id}'/>'">수정</button>
                                            <button class="btn-danger" onclick="deleteMenu(${menu.menu_id})">삭제</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty menuList}">
                                    <tr><td colspan="4" style="padding: 60px; color: gray; text-align: center;">등록된 메뉴가 없습니다.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="owner-card" style="margin-top: 30px;">
                    <h3 style="margin-bottom: 20px;">💬 우리 가게 리뷰 관리</h3>
                    <div style="max-height: 500px; overflow-y: auto;">
                        <c:choose>
                            <c:when test="${not empty store_review_list}">
                                <c:forEach var="review" items="${store_review_list}">
                                    <div style="padding: 15px; border: 1px solid #eee; border-radius: 8px; margin-bottom: 15px; background: #fff;">
                                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                                            <div>
                                                <strong style="font-size: 16px;">${review.user_nm} 고객님</strong>
                                                <span style="color: #f1c40f; margin-left: 10px;">
                                                    <c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
                                                </span>
                                            </div>
                                            <span style="color: #999; font-size: 13px;">
                                                <fmt:formatDate value="${review.review_date}" pattern="yyyy-MM-dd HH:mm" />
                                            </span>
                                        </div>
                                        <div style="display: flex; gap: 15px;">
                                            <c:if test="${not empty review.img_url}">
                                                <img src="<c:url value='/upload/${review.img_url}'/>" style="width: 100px; height: 100px; object-fit: cover; border-radius: 5px;">
                                            </c:if>
                                            <div style="flex: 1;">
                                                <p style="margin: 0; line-height: 1.5; color: #444;">${review.content}</p>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div style="padding: 40px; text-align: center; color: #999;">아직 등록된 리뷰가 없습니다.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:when>
            
            <c:otherwise>
                <div style="padding: 120px; text-align: center; border: 2px dashed #ccc; background: #fafafa; border-radius: 15px; margin-top: 30px;">
                    <h3 style="color: #666;">연결된 매장 정보가 없습니다.</h3>
                    <p>가게 정보를 등록하여 Gourmet Pass 서비스를 시작하세요.</p>
                    <button class="btn-orange" onclick="location.href='<c:url value='/member/signup/owner2'/>'" style="width: 200px;">가게 등록하기</button>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />