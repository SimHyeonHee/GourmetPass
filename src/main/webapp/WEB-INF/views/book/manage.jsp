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
        role: "ROLE_OWNER",
        storeId: "${store.store_id}"
    };

    document.addEventListener("DOMContentLoaded", function() {
        if(typeof initMyPageWebSocket === 'function') {
            initMyPageWebSocket(null, APP_CONFIG.role, APP_CONFIG.storeId);
        }
    });
</script>
<script src="<c:url value='/resources/js/member-mypage.js'/>"></script>

<div style="width: 80%; margin: 0 auto; padding: 40px 0;">
    <h2>⚙️ 실시간 매장 관리</h2>

    <div class="dashboard-container">
        <h3 style="color: #2f855a; border-bottom: 2px solid #2f855a; padding-bottom:10px;">🚶 실시간 웨이팅 관리</h3>
        <table class="info-table" style="width: 100%; margin-bottom: 50px;">
            <thead>
                <tr>
                    <th>번호</th><th>고객ID</th><th>인원</th><th>현재상태</th><th>상태변경 관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="wait" items="${store_wait_list}">
                    <tr>
                        <td align="center"><b>${wait.wait_num}번</b></td>
                        <td>${wait.user_id}</td>
                        <td align="center">${wait.people_cnt}명</td>
                        <td align="center">
                            <c:choose>
                                <c:when test="${wait.wait_status == 'WAITING'}"><span class="msg-ok">대기중</span></c:when>
                                <c:when test="${wait.wait_status == 'CALLED'}"><span style="color:blue;">호출중</span></c:when>
                                <c:when test="${wait.wait_status == 'FINISH'}">방문완료</c:when>
                                <c:otherwise>${wait.wait_status}</c:otherwise>
                            </c:choose>
                        </td>
                        <td align="center">
                            <form action="<c:url value='/wait/updateStatus'/>" method="post" style="display: flex; gap: 5px; justify-content: center;">
                                <input type="hidden" name="wait_id" value="${wait.wait_id}">
                                <input type="hidden" name="user_id" value="${wait.user_id}">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                
                                <%-- 상태에 따른 버튼 노출 --%>
                                <c:if test="${wait.wait_status == 'WAITING'}">
                                    <button type="submit" name="status" value="CALLED" class="btn-primary" style="padding: 5px 10px;">호출</button>
                                </c:if>
                                <c:if test="${wait.wait_status == 'CALLED' or wait.wait_status == 'WAITING'}">
                                    <button type="submit" name="status" value="FINISH" class="btn-success" style="padding: 5px 10px;">방문완료</button>
                                    <button type="submit" name="status" value="CANCELLED" class="btn-danger" style="padding: 5px 10px;">취소</button>
                                </c:if>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty store_wait_list}">
                    <tr><td colspan="5" align="center" style="padding:40px; color:#999;">현재 대기 중인 고객이 없습니다.</td></tr>
                </c:if>
            </tbody>
        </table>

        <h3 style="color: #e65100; border-bottom: 2px solid #e65100; padding-bottom:10px;">📅 오늘 예약 관리</h3>
        <table class="info-table" style="width: 100%;">
            <thead>
                <tr>
                    <th>시간</th><th>고객ID</th><th>인원</th><th>현재상태</th><th>방문확인</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="book" items="${store_book_list}">
                    <tr>
                        <td align="center"><b><fmt:formatDate value="${book.book_date}" pattern="HH:mm"/></b></td>
                        <td>${book.user_id}</td>
                        <td align="center">${book.people_cnt}명</td>
                        <td align="center">${book.book_status}</td>
                        <td align="center">
                            <c:if test="${book.book_status == 'RESERVED'}">
                                <form action="<c:url value='/book/updateStatus'/>" method="post" style="display: flex; gap: 5px; justify-content: center;">
                                    <input type="hidden" name="book_id" value="${book.book_id}">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <button type="submit" name="status" value="FINISH" class="btn-success" style="padding: 5px 10px;">방문확인</button>
                                    <button type="submit" name="status" value="NOSHOW" class="btn-danger" style="padding: 5px 10px;">노쇼</button>
                                </form>
                            </c:if>
                            <c:if test="${book.book_status == 'FINISH'}"><span>✅ 완료</span></c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty store_book_list}">
                    <tr><td colspan="5" align="center" style="padding:40px; color:#999;">오늘 예정된 예약이 없습니다.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />