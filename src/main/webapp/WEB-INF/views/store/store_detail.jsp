<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="<c:url value='/resources/css/store_detail.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<!-- 예약중복과 한 가게에서의 중복 예약의 대한 에러 메시지 -->
<script type="text/javascript">
	// EL 문법인 ${msg}를 사용하여 값을 가져옵니다.
	// 값이 없을 경우를 대비해 빈 문자열("") 처리를 합니다.
	var msg = "${msg}";

	if (msg && msg !== "null" && msg !== "") {
		alert(msg);
	}
	
	// 컨트롤러에서 보낸 loginUser 객체가 있다면 자바스크립트 변수에 할당	 -- JSP에 직접 써야함
	window.loginUserInfo = {
	    email: "${loginUser.user_email}",
	    name:  "${loginUser.user_nm}",
	    tel:   "${loginUser.user_tel}",
	    addr:  "${loginUser.user_addr1} ${loginUser.user_addr2}",
	    post:  "${loginUser.user_zip}",
	 	// 포트원 변수도 같이(properties)
	    impInit: "${impInit}",		
	    pg: "${pg}"
	};
</script>
<%-- [교정 포인트] data-store-id 속성을 추가하여 JS(v1.0.8)가 AJAX 요청 시 store_id를 인식하게 함 --%>
<div class="detail-wrapper" id="storeDetailApp"
	data-store-id="${store.store_id}" data-lat="${store.store_lat}"
	data-lng="${store.store_lon}" data-name="${store.store_name}"
	data-open-time="${store.open_time}"
	data-close-time="${store.close_time}" data-res-unit="${store.res_unit}"
	data-context="${pageContext.request.contextPath}">

	<%-- 1. 상단 타이틀 섹션 --%>
	<div class="detail-header">
		<h1 class="store-main-title">🏠 ${store.store_name}</h1>
		<div class="store-meta-info">
			<span class="badge-cat">${store.store_category}</span> <span
				class="rating-box">⭐ <b>${store.avg_rating}</b>
				(${store.review_cnt}개의 리뷰)
			</span>
		</div>
	</div>

	<%-- 2. 메인 정보 카드 --%>
	<div class="info-main-card">
		<div class="store-img-section">
			<c:choose>
				<c:when test="${not empty store.store_img}">
					<img src="<c:url value='/upload/${store.store_img}'/>"
						class="main-thumb">
				</c:when>
				<c:otherwise>
					<div class="no-img-box">NO IMAGE</div>
				</c:otherwise>
			</c:choose>
		</div>
		<div class="store-text-section">
			<p>
				<b>📍 주소</b> ${store.store_addr1} ${store.store_addr2}
			</p>
			<p>
				<b>📞 전화</b> ${store.store_tel}
			</p>
			<p>
				<b>⏰ 영업</b> ${store.open_time} ~ ${store.close_time}
			</p>
			<p>
				<b>🚶 대기</b> <span class="wait-count-text">현재
					${currentWaitCount}팀 대기 중</span>
			</p>
			<p>
				<b>📝 소개</b> ${store.store_desc}
			</p>
		</div>
	</div>

	<%-- 3. 인터랙션 버튼 그룹 --%>
	<div class="detail-action-group">
		<button type="button" class="btn-main-wire btn-booking"
			onclick="showInteraction('booking')">📅 예약하기</button>
		<button type="button" class="btn-main-wire btn-waiting"
			onclick="showInteraction('waiting')">🚶 웨이팅하기</button>
	</div>

	<%-- 4. 예약 신청 영역 --%>
	<div id="booking-area" class="interaction-card" style="display: none;">
		<h3 class="section-title">📅 당일 예약 신청</h3>
		<sec:authorize access="isAuthenticated()">
			<!-- data-user-* 결제를 위한 사용자 정보 data넣기 -->
			<form id="bookForm" action="<c:url value='/book/register'/>" method="post">
				<input type="hidden" name="store_id" value="${store.store_id}">
				<input type="hidden" id="payIdField" name="pay_id" value="">
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />

				<%-- 서버 RequestParam("book_date") 수신용 히든 필드 --%>
				<!-- <input type="hidden" name="book_date" id="bookDate"> -->

				<table class="edit-table">
					<tr>
						<th>예약 인원</th>
						<td><select name="people_cnt" class="login-input">
								<c:forEach var="i" begin="1" end="10">
									<option value="${i}">${i}명</option>
								</c:forEach>
						</select></td>
					</tr>
					<tr>
						<th>예약 날짜</th>
						<td><input type="date" name="book_date" id="bookDate"
							class="login-input" onchange="loadAvailableSlots()"
							min="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>">
							<p class="info-text">* 당일 및 이후 날짜만 선택 가능합니다.</p></td>
					</tr>
					<tr>
					<tr>
						<th>예약 시간</th>
						<td>
							<div id="timeSlotContainer" class="time-grid">
								<%-- JS에 의해 타임 버튼이 동적으로 생성됨 --%>
							</div> <input type="hidden" name="book_time" id="selectedTime" required>
						</td>
					</tr>
				</table>
				<button type="submit" class="btn-submit-wire">🚀 예약 확정하기</button>
			</form>
		</sec:authorize>
		<sec:authorize access="isAnonymous()">
			<div class="text-center" style="padding: 20px;">
				예약은 <a href="<c:url value='/member/login'/>"
					style="text-decoration: underline; font-weight: 900;">로그인</a> 후 이용
				가능합니다.
			</div>
		</sec:authorize>
	</div>

	<%-- 5. 웨이팅 신청 영역 --%>
	<div id="waiting-area" class="interaction-card" style="display: none;">
		<h3 class="section-title">🚶 실시간 웨이팅 신청</h3>
		<sec:authorize access="isAuthenticated()">
			<form action="<c:url value='/wait/register'/>" method="post">
				<input type="hidden" name="store_id" value="${store.store_id}">
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />
				<table class="edit-table">
					<tr>
						<th>방문 인원</th>
						<td><select name="people_cnt" class="login-input">
								<c:forEach var="i" begin="1" end="10">
									<option value="${i}">${i}명</option>
								</c:forEach>
						</select></td>
					</tr>
				</table>
				<button type="submit" class="btn-submit-wire dark-btn">줄서기
					신청하기</button>
			</form>
		</sec:authorize>
		<sec:authorize access="isAnonymous()">
			<div class="text-center" style="padding: 20px;">
				웨이팅은 <a href="<c:url value='/member/login'/>"
					style="text-decoration: underline; font-weight: 900;">로그인</a> 후 이용
				가능합니다.
			</div>
		</sec:authorize>
	</div>

	<%-- 6. 지도 및 리뷰 섹션 --%>
	<div id="map"
		style="width: 100%; height: 350px; border: 2px solid #333; border-radius: 15px; margin-bottom: 50px;"></div>

	<div class="review-summary-section">
		<div class="card-header">
			<h3 class="card-title">💬 최근 리뷰</h3>
			<a href="<c:url value='/store/reviews?store_id=${store.store_id}'/>"
				class="btn-wire" style="font-size: 12px; padding: 5px 10px;">전체보기
				❯</a>
		</div>
		<div class="review-grid" style="margin-top: 20px;">
			<c:choose>
				<c:when test="${not empty reviewList}">
					<c:forEach var="rev" items="${reviewList}">
						<div class="item-card" style="margin-bottom: 15px; padding: 20px;">
							<div
								style="display: flex; justify-content: space-between; margin-bottom: 10px;">
								<span style="font-weight: 900;">${rev.user_nm}</span> <span
									style="color: #f1c40f;"> <c:forEach begin="1"
										end="${rev.rating}">⭐</c:forEach>
								</span>
							</div>
							<p style="font-size: 14px; color: #666; line-height: 1.6;">${rev.content}</p>
						</div>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div
						style="text-align: center; padding: 40px; color: #999; font-weight: 800;">작성된
						리뷰가 없습니다.</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</div>



<%-- 필수 라이브러리 및 스크립트 연동 --%>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- iamport.payment.js -->
<script type="text/javascript"
	src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
<script
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="<c:url value='/resources/js/store_detail.js'/>"></script>

<jsp:include page="../common/footer.jsp" />