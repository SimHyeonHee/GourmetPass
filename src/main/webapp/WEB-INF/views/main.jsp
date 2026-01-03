<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<jsp:include page="common/header.jsp" />

<div style="width: 80%; margin: 0 auto; text-align: center;">

    <div style="margin: 30px 0; padding: 20px; border: 1px solid #ccc; background-color: #f0f0f0;">
        <h3>오늘 뭐 먹지?</h3>
        <form action="${pageContext.request.contextPath}/store/list" method="get">
            <input type="text" name="keyword" placeholder="가게 이름을 입력하세요" style="width: 300px; padding: 5px;">
            <input type="submit" value="검색">
        </form>
    </div>

    <div style="margin-bottom: 30px;">
        <h4>카테고리별 보기</h4>
        <button onclick="location.href='${pageContext.request.contextPath}/store/list?category=한식'">한식 🍚</button>
        <button onclick="location.href='${pageContext.request.contextPath}/store/list?category=일식'">일식 🍣</button>
        <button onclick="location.href='${pageContext.request.contextPath}/store/list?category=양식'">양식 🍝</button>
        <button onclick="location.href='${pageContext.request.contextPath}/store/list?category=중식'">중식 🥡</button>
        <button onclick="location.href='${pageContext.request.contextPath}/store/list?category=카페'">카페 ☕</button>
    </div>

    <hr>

    <div style="margin-top: 30px;">
        <h3 style="color: orange;">🔥 실시간 인기 맛집 (Top 4)</h3>
        
        <table border="1" style="width: 100%;">
            <thead style="background-color: #eee;">
                <tr>
                    <th width="15%">이미지</th>
                    <th width="10%">카테고리</th>
                    <th width="20%">가게이름</th>
                    <th width="40%">주소</th>
                    <th width="15%">조회수</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty storeList}">
                        <c:forEach var="store" items="${storeList}">
                            <%-- storeId -> store_id 로 변경 --%>
                            <tr onclick="location.href='${pageContext.request.contextPath}/store/detail?store_id=${store.store_id}'" 
                                style="cursor: pointer;" onmouseover="this.style.background='#f9f9f9'" onmouseout="this.style.background='white'">
                                
                                <td>
                                    <%-- storeImg -> store_img 로 변경 --%>
                                    <c:if test="${not empty store.store_img}">
                                        <img src="${pageContext.request.contextPath}/upload/${store.store_img}" width="80" height="80" style="object-fit:cover;">
                                    </c:if>
                                    <c:if test="${empty store.store_img}">
                                        <span>이미지 없음</span>
                                    </c:if>
                                </td>
                                
                                <%-- storeCategory -> store_category 로 변경 --%>
                                <td>[${store.store_category}]</td>
                                
                                <%-- storeName -> store_name 로 변경 --%>
                                <td style="font-weight: bold;">${store.store_name}</td>
                                
                                <%-- storeAddr1 -> store_addr1 로 변경 --%>
                                <td style="text-align: left;">${store.store_addr1}</td>
                                
                                <%-- storeCnt -> store_cnt 로 변경 --%>
                                <td style="color: red;">${store.store_cnt}회</td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" style="padding: 20px;">현재 등록된 인기 맛집이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="common/footer.jsp" />