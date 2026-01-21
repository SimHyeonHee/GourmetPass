<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="<c:url value='/resources/css/store_list.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="list-wrapper">
    <%-- 1. 필터 섹션 --%>
    <div class="filter-card">
        <form id="filterForm" action="${pageContext.request.contextPath}/store/list" method="get">
            <div class="filter-item">
                <label>📍 지역 선택</label>
                <select name="region" onchange="this.form.submit()" class="wire-select" style="width:200px;">
                    <option value="">전체 지역</option>
                    <option value="서울" ${region == '서울' ? 'selected' : ''}>서울</option>
                    <option value="경기" ${region == '경기' ? 'selected' : ''}>경기</option>
                </select>
            </div>
            <div class="filter-item">
                <label>🍴 카테고리</label>
                <div class="chip-group">
                    <c:set var="cats" value="한식,일식,중식,양식,카페" />
                    <c:forEach var="cat" items="${fn:split(cats, ',')}">
                        <div class="cat-chip ${category == cat ? 'active' : ''}" 
                             onclick="location.href='?category=${cat}'">${cat}</div>
                    </c:forEach>
                </div>
            </div>
        </form>
    </div>

    <%-- 2. 맛집 그리드 섹션 --%>
    <div class="store-grid">
        <c:forEach var="store" items="${storeList}">
            <div class="store-card" onclick="location.href='detail?storeId=${store.store_id}'">
                <div class="store-img-box">
                    <c:choose>
                        <c:when test="${not empty store.store_img}">
                            <img src="<c:url value='/upload/${store.store_img}'/>" class="store-thumb">
                        </c:when>
                        <c:otherwise>
                            <%-- [교정] 수동 패딩을 제거하고 중앙 정렬 클래스 적용 --%>
                            <div class="no-img-placeholder">NO IMAGE</div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="store-info">
                    <span class="badge-cat">${store.store_category}</span>
                    <h3 class="store-name">${store.store_name}</h3>
                    <div class="store-meta">
                        <span class="rating">⭐ ${store.avg_rating}</span>
                        <span class="view-cnt">조회 ${store.store_cnt}</span>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />