<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
    const APP_CONFIG = {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}",
        userId: "<sec:authentication property='principal.username'/>",
        role: "ROLE_USER"
    };

    document.addEventListener("DOMContentLoaded", function() {
        if(typeof initMyPageWebSocket === 'function') {
            initMyPageWebSocket(APP_CONFIG.userId, APP_CONFIG.role);
        }
    });

    function cancelWait(waitId) {
        if(!confirm("웨이팅을 취소하시겠습니까?")) return;
        const form = document.createElement("form");
        form.method = "POST";
        form.action = APP_CONFIG.contextPath + "/wait/cancel";
        
        const inputId = document.createElement("input");
        inputId.type = "hidden"; inputId.name = "wait_id"; inputId.value = waitId;
        
        const inputCsrf = document.createElement("input");
        inputCsrf.type = "hidden"; inputCsrf.name = APP_CONFIG.csrfName; inputCsrf.value = APP_CONFIG.csrfToken;
        
        form.appendChild(inputId);
        form.appendChild(inputCsrf);
        document.body.appendChild(form);
        form.submit();
    }

    // 전체 내역 토글 함수
    function toggleHistory() {
        const area = document.getElementById('full-history-area');
        const btn = document.getElementById('history-toggle-btn');
        if(area.style.display === 'none') {
            area.style.display = 'block';
            btn.innerText = '내역 닫기 ▲';
        } else {
            area.style.display = 'none';
            btn.innerText = '전체 이용 내역 보기 ▼';
        }
    }
</script>
<script src="<c:url value='/resources/js/member-mypage.js'/>"></script>

<div style="width: 80%; margin: 0 auto; padding: 40px 0;">
    <h2 style="text-align: left;">📅 나의 이용현황</h2>
    
    <div style="margin-top: 30px;">
        <c:choose>
            <c:when test="${not empty activeWait or not empty activeBook}">
                <div style="background: #fff; border: 2px solid #333; border-radius: 15px; padding: 30px; margin-bottom: 20px;">
                    <h4 style="margin-top: 0; color: #333;">🔥 현재 이용 중인 서비스</h4>
                    
                    <c:if test="${not empty activeWait}">
                        <div style="display: flex; justify-content: space-between; align-items: center; padding: 15px 0; border-bottom: 1px dashed #ddd;">
                            <div>
                                <span class="badge-cat">실시간 웨이팅</span>
                                <h3 style="margin: 10px 0;">${activeWait.store_name}</h3>
                                <p style="color: #666; margin: 0;">대기 번호: <b>${activeWait.wait_num}번</b> / ${activeWait.people_cnt}명</p>
                            </div>
                            <div style="text-align: right;">
                                <span style="font-size: 24px; font-weight: bold; color: #2f855a;">
                                    <c:choose>
                                        <c:when test="${activeWait.wait_status == 'CALLED'}">지금 입장하세요!</c:when>
                                        <c:otherwise>대기 중</c:otherwise>
                                    </c:choose>
                                </span><br>
                                <button type="button" class="btn-danger" onclick="cancelWait('${activeWait.wait_id}')" style="margin-top: 10px;">취소하기</button>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not empty activeBook}">
                        <div style="display: flex; justify-content: space-between; align-items: center; padding: 15px 0;">
                            <div>
                                <span class="badge-cat" style="background: #e65100;">확정된 예약</span>
                                <h3 style="margin: 10px 0;">${activeBook.store_name}</h3>
                                <p style="color: #666; margin: 0;">예약 일시: <b><fmt:formatDate value="${activeBook.book_date}" pattern="MM월 dd일 HH:mm"/></b> / ${activeBook.people_cnt}명</p>
                            </div>
                            <div style="text-align: right;">
                                <span style="font-size: 20px; font-weight: bold; color: #e65100;">방문 예정</span>
                            </div>
                        </div>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <div style="background: #f9f9f9; border: 1px dashed #ccc; border-radius: 15px; padding: 40px; text-align: center; color: #999;">
                    현재 진행 중인 예약이나 웨이팅이 없습니다.
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div style="margin-top: 50px;">
        <h3 style="text-align: left;">✅ 최근 방문 완료</h3>
        <div style="border: 1px solid #ddd; border-radius: 10px; background: #fff; padding: 10px;">
            <c:forEach var="item" items="${finishedWaits}">
                <div style="padding: 15px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;">
                    <span><b>${item.store_name}</b> (웨이팅) - <fmt:formatDate value="${item.wait_date}" pattern="MM/dd"/></span>
                    <button class="btn-action" onclick="location.href='<c:url value='/review/write?store_id=${item.store_id}&wait_id=${item.wait_id}'/>'">리뷰 쓰기</button>
                </div>
            </c:forEach>
            <c:forEach var="item" items="${finishedBooks}">
                <div style="padding: 15px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;">
                    <span><b>${item.store_name}</b> (예약) - <fmt:formatDate value="${item.book_date}" pattern="MM/dd"/></span>
                    <button class="btn-action" onclick="location.href='<c:url value='/review/write?store_id=${item.store_id}&book_id=${item.book_id}'/>'">리뷰 쓰기</button>
                </div>
            </c:forEach>
            <c:if test="${empty finishedWaits and empty finishedBooks}">
                <p style="text-align: center; padding: 20px; color: #999;">방문 기록이 없습니다.</p>
            </c:if>
        </div>
    </div>

    <div style="margin-top: 30px; text-align: center;">
        <button id="history-toggle-btn" onclick="toggleHistory()" style="background: none; border: 1px solid #999; color: #666; padding: 10px 20px; border-radius: 20px; cursor: pointer;">
            전체 이용 내역 보기 ▼
        </button>
    </div>

    <div id="full-history-area" style="display: none; margin-top: 30px;">
        <h4 style="text-align: left;">📜 전체 히스토리</h4>
        <table class="info-table" style="width: 100%;">
            <thead>
                <tr><th>가게명</th><th>유형</th><th>일시</th><th>상태</th></tr>
            </thead>
            <tbody>
                <c:forEach var="w" items="${my_wait_list}">
                    <tr><td>${w.store_name}</td><td>웨이팅</td><td><fmt:formatDate value="${w.wait_date}" pattern="yy-MM-dd"/></td><td>${w.wait_status}</td></tr>
                </c:forEach>
                <c:forEach var="b" items="${my_book_list}">
                    <tr><td>${b.store_name}</td><td>예약</td><td><fmt:formatDate value="${b.book_date}" pattern="yy-MM-dd"/></td><td>${b.book_status}</td></tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />