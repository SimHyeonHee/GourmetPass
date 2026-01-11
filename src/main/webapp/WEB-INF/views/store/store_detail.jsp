<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/store-detail.css'/>">

<div style="width: 80%; margin: 0 auto; padding: 20px 0;">
    <h1 style="text-align: left;">
        🏠 ${store.store_name} 
        <small style="font-size:15px; color:gray;">(${store.store_category})</small>
        <span style="font-size: 18px; color: #f1c40f; margin-left: 10px;">
            ⭐ ${store.avg_rating} <small style="color: #666;">(${store.review_count}개의 리뷰)</small>
        </span>
    </h1>
    
    <table border="0" cellpadding="10" cellspacing="0" width="100%" style="border: 1px solid #ddd; border-radius: 12px; overflow: hidden; background: #fff;">
        <tr>
            <td width="350" align="center" bgcolor="#fafafa" style="border-right: 1px solid #ddd;">
                <c:choose>
                    <c:when test="${not empty store.store_img}">
                        <img src="<c:url value='/upload/${store.store_img}'/>" width="320" style="border-radius: 10px; box-shadow: 2px 2px 10px rgba(0,0,0,0.1);">
                    </c:when>
                    <c:otherwise><div style="width:320px; height:200px; background:#eee; line-height:200px; border-radius:10px; color:#aaa;">이미지 준비중</div></c:otherwise>
                </c:choose>
            </td>
            <td valign="top" style="padding: 25px; text-align: left;">
                <p style="margin-bottom:15px;"><b>📍 주소:</b> ${store.store_addr1} ${store.store_addr2}</p>
                <p style="margin-bottom:15px;"><b>📞 전화:</b> ${store.store_tel}</p>
                <p style="margin-bottom:15px;"><b>⏰ 영업:</b> ${store.open_time} ~ ${store.close_time} (${store.res_unit}분 단위)</p>
                <p style="margin-bottom:15px;"><b>🚶 실시간 웨이팅:</b> <span style="color: #2f855a; font-weight: bold;">현재 ${currentWaitCount}팀 대기 중</span></p>
                <p style="margin-bottom:15px;"><b>📝 소개:</b> ${store.store_desc}</p>
                <p><b>👀 조회:</b> <fmt:formatNumber value="${store.store_cnt}" />회</p>
            </td>
        </tr>
    </table>

    <div class="menu-section" style="text-align: left; margin-top: 40px;">
        <div class="menu-group-title">📋 대표 메뉴</div>
        <div class="menu-grid">
            <c:forEach var="menu" items="${menuList}">
                <c:if test="${menu.menu_sign == 'Y'}">
                    <div class="menu-card">
                        <c:choose>
                            <c:when test="${not empty menu.menu_img}"><img src="<c:url value='/upload/${menu.menu_img}'/>"></c:when>
                            <c:otherwise><div class="no-img" style="line-height:100px; text-align:center; color:#ccc; font-size:12px;">No Image</div></c:otherwise>
                        </c:choose>
                        <div class="menu-details">
                            <div class="menu-name">${menu.menu_name}<span class="best-label">BEST</span></div>
                            <div class="menu-price"><fmt:formatNumber value="${menu.menu_price}" pattern="#,###"/>원</div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>

        <c:set var="has_other_menu" value="false" />
        <c:forEach var="m" items="${menuList}"><c:if test="${m.menu_sign == 'N'}"><c:set var="has_other_menu" value="true" /></c:if></c:forEach>
        <c:if test="${has_other_menu}">
            <div class="toggle-wrapper" style="text-align: center; margin-top: 20px;">
                <button type="button" class="btn-toggle" id="menu-toggle-btn" onclick="toggleMenus()">전체 메뉴 보기 ↓</button>
            </div>
        </c:if>

        <div id="other-menu-area" style="display: none; margin-top: 30px;">
            <div class="menu-group-title" style="border-left-color: #999;">🍴 일반 메뉴</div>
            <div class="menu-grid">
                <c:forEach var="menu" items="${menuList}">
                    <c:if test="${menu.menu_sign == 'N'}">
                        <div class="menu-card">
                            <c:choose>
                                <c:when test="${not empty menu.menu_img}"><img src="<c:url value='/upload/${menu.menu_img}'/>"></c:when>
                                <c:otherwise><div class="no-img">No Image</div></c:otherwise>
                            </c:choose>
                            <div class="menu-details">
                                <div class="menu-name">${menu.menu_name}</div>
                                <div class="menu-price"><fmt:formatNumber value="${menu.menu_price}" pattern="#,###"/>원</div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>

    <hr style="margin: 40px 0; border: 0; border-top: 1px solid #eee;">

    <h3 style="text-align: left;">🗺️ 찾아오시는 길</h3>
    <div id="map" style="width:100%; height:380px; border-radius: 12px; border:1px solid #ddd; margin-bottom:40px;"></div>

    <div class="action-btn-container" style="display: flex; justify-content: center; gap: 20px;">
        <button type="button" class="btn-main btn-booking" onclick="showInteraction('booking')" style="width: 200px;">📅 예약하기</button>
        <button type="button" class="btn-main btn-waiting" onclick="showInteraction('waiting')" style="width: 200px;">🚶 웨이팅하기</button>
    </div>

    <div id="booking-area" class="interaction-area" style="display: none; text-align: left; margin-top: 30px;">
        <h3 style="color: #e65100; margin-top:0;">📅 당일 예약하기</h3>
        <sec:authorize access="isAnonymous()">
            <div style="text-align: center; padding: 30px;">
                <p>로그인 후 예약이 가능합니다.</p>
                <a href="${pageContext.request.contextPath}/member/login" class="btn-main btn-booking" style="display:inline-block; width:auto; padding:10px 30px; text-decoration:none;">로그인</a>
            </div>
        </sec:authorize>
        <sec:authorize access="isAuthenticated()">
            <form id="bookForm" action="${pageContext.request.contextPath}/book/register" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="store_id" value="${store.store_id}">
                <sec:authentication property="principal.username" var="login_id"/>
                <input type="hidden" name="user_id" value="${login_id}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                <div style="display: flex; gap: 40px; flex-wrap: wrap;">
                    <div style="flex: 1; min-width: 250px;">
                        <label class="step-title">Step 1. 날짜</label>
                        <input type="text" id="bookDate" name="book_date" readonly class="form-input">
                        
                        <label class="step-title" style="margin-top: 25px;">Step 2. 인원</label>
                        <select name="people_cnt" class="form-input" style="cursor: pointer;">
                            <c:forEach var="i" begin="1" end="10"><option value="${i}">${i}명</option></c:forEach>
                        </select>
                    </div>
                    <div style="flex: 2; min-width: 300px; border-left: 1px dashed #ffccbc; padding-left: 40px;">
                        <label class="step-title">Step 3. 시간 선택</label>
                        <div id="timeSlotContainer" class="time-slot-grid"></div>
                        <input type="hidden" name="book_time" id="selectedTime" required>
                    </div>
                </div>
                <div style="text-align: center; margin-top: 40px;">
                    <button type="submit" class="btn-confirm-booking">🚀 예약 확정하기</button>
                </div>
            </form>
        </sec:authorize>
    </div>

    <div id="waiting-area" class="interaction-area" style="display: none; text-align: left; margin-top: 30px;">
        <h3 style="color: #2f855a; margin-top:0;">🚶 실시간 웨이팅하기</h3>
        <p style="background: #f0fff4; padding: 10px; border-radius: 5px; color: #2f855a; font-weight: bold;">
            📢 현재 내 앞에 ${currentWaitCount}팀이 대기하고 있습니다.
        </p>
        <sec:authorize access="isAnonymous()">
            <div style="text-align: center; padding: 30px;">
                <p>로그인 후 웨이팅 신청이 가능합니다.</p>
                <a href="${pageContext.request.contextPath}/member/login" class="btn-main btn-waiting" style="display:inline-block; width:auto; padding:10px 30px; text-decoration:none;">로그인</a>
            </div>
        </sec:authorize>
        <sec:authorize access="isAuthenticated()">
            <form action="${pageContext.request.contextPath}/wait/register" method="post">
                <input type="hidden" name="store_id" value="${store.store_id}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div style="max-width: 400px; margin: auto;">
                    <label class="step-title">방문 인원</label>
                    <select name="people_cnt" class="form-input">
                        <c:forEach var="i" begin="1" end="10"><option value="${i}">${i}명</option></c:forEach>
                    </select>
                    <button type="submit" class="btn-confirm-waiting" style="margin-top:20px;">줄서기 신청</button>
                </div>
            </form>
        </sec:authorize>
    </div>

    <hr style="margin: 50px 0; border: 0; border-top: 2px solid #333;">

    <div id="review-section" style="text-align: left;">
        <h3>💬 리뷰 (${store.review_count})</h3>

        <sec:authorize access="isAuthenticated()">
            <c:choose>
                <c:when test="${canWriteReview}">
                    <div style="background: #f9f9f9; padding: 20px; border-radius: 10px; border: 1px solid #eee; margin-bottom: 30px;">
                        <form action="${pageContext.request.contextPath}/review/write" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="store_id" value="${store.store_id}">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            
                            <div style="margin-bottom: 10px;">
                                <label>별점: </label>
                                <select name="rating" style="padding: 5px;">
                                    <option value="5">⭐⭐⭐⭐⭐ (5점)</option>
                                    <option value="4">⭐⭐⭐⭐ (4점)</option>
                                    <option value="3">⭐⭐⭐ (3점)</option>
                                    <option value="2">⭐⭐ (2점)</option>
                                    <option value="1">⭐ (1점)</option>
                                </select>
                            </div>
                            <textarea name="content" placeholder="맛있는 경험을 공유해주세요!" required 
                                      style="width: 100%; height: 80px; padding: 10px; border: 1px solid #ddd; border-radius: 5px; resize: none;"></textarea>
                            <div style="margin-top: 10px; display: flex; justify-content: space-between; align-items: center;">
                                <input type="file" name="file">
                                <button type="submit" style="padding: 8px 25px; background: #333; color: white; border: none; border-radius: 5px; cursor: pointer;">리뷰 등록</button>
                            </div>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="background: #fff8e1; padding: 20px; border-radius: 10px; border: 1px solid #ffe082; margin-bottom: 30px; text-align: center; color: #795548;">
                        📢 <strong>방문 완료 후 리뷰를 작성하실 수 있습니다.</strong><br>
                        <small>예약 또는 웨이팅을 이용하고 맛있는 경험을 나눠주세요!</small>
                    </div>
                </c:otherwise>
            </c:choose>
        </sec:authorize>

        <sec:authorize access="isAnonymous()">
            <div style="background: #f5f5f5; padding: 20px; border-radius: 10px; border: 1px solid #eee; margin-bottom: 30px; text-align: center; color: #666;">
                리뷰 작성을 위해 <a href="${pageContext.request.contextPath}/member/login" style="color: #333; font-weight: bold;">로그인</a>이 필요합니다.
            </div>
        </sec:authorize>

        <div class="review-list">
            <c:choose>
                <c:when test="${not empty reviewList}">
                    <c:forEach var="review" items="${reviewList}">
                        <div style="padding: 20px 0; border-bottom: 1px solid #eee;">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                                <strong>${review.user_nm}</strong>
                                <span style="color: #999; font-size: 13px;"><fmt:formatDate value="${review.review_date}" pattern="yyyy-MM-dd" /></span>
                            </div>
                            <div style="color: #f1c40f; margin-bottom: 10px;">
                                <c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
                            </div>
                            <p style="margin: 10px 0; line-height: 1.6;">${review.content}</p>
                            <c:if test="${not empty review.img_url}">
                                <img src="<c:url value='/upload/${review.img_url}'/>" width="120" style="border-radius: 5px; margin-top: 10px;">
                            </c:if>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 40px; color: #999;">아직 작성된 리뷰가 없습니다. 첫 리뷰를 남겨보세요!</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div style="margin: 50px 0; text-align: center;">
        <a href="list" style="color: #999; text-decoration: none; font-size:14px;">목록으로 돌아가기</a>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}"></script>
<script>
    // 1. 기초 설정 정보
    const STORE_CONF = {
        lat: "${store.store_lat}",
        lng: "${store.store_lon}",
        storeName: "${store.store_name}",
        openTime: "${store.open_time}",
        closeTime: "${store.close_time}",
        resUnit: "${store.res_unit}",
        contextPath: "${pageContext.request.contextPath}"
    };

    // 2. 지도 초기화
    $(document).ready(function() {
        if (STORE_CONF.lat && STORE_CONF.lng) {
            const container = document.getElementById('map');
            const options = {
                center: new kakao.maps.LatLng(STORE_CONF.lat, STORE_CONF.lng),
                level: 3
            };
            const map = new kakao.maps.Map(container, options);
            const marker = new kakao.maps.Marker({
                position: new kakao.maps.LatLng(STORE_CONF.lat, STORE_CONF.lng)
            });
            marker.setMap(map);
        }
    });

    // 3. UI 인터랙션 함수들
    function toggleMenus() {
        const area = document.getElementById('other-menu-area');
        const btn = document.getElementById('menu-toggle-btn');
        if(area.style.display === 'none') {
            area.style.display = 'block';
            btn.innerText = '전체 메뉴 닫기 ↑';
        } else {
            area.style.display = 'none';
            btn.innerText = '전체 메뉴 보기 ↓';
        }
    }

    function showInteraction(type) {
        $(".interaction-area").hide();
        $("#" + type + "-area").fadeIn();
        window.scrollTo({
            top: $("#" + type + "-area").offset().top - 100,
            behavior: 'smooth'
        });
    }
</script>
<script src="<c:url value='/resources/js/store-detail.js'/>"></script>

<jsp:include page="../common/footer.jsp" />