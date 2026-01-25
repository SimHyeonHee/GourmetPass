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
            <input type="hidden" name="pageNum" id="pageNum" value="${pageMaker.cri.pageNum}">
            <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
            <input type="hidden" name="category" id="selectedCategory" value="${category}">
            <input type="hidden" name="keyword" value="${keyword}">

            <div class="filter-item">
                <label>📍 지역 선택</label>
                <select name="region" onchange="resetPageAndSubmit()" class="wire-select" style="width:200px;">
                    <option value="">전체 지역</option>
                    <option value="서울" ${region == '서울' ? 'selected' : ''}>서울</option>
                    <option value="경기" ${region == '경기' ? 'selected' : ''}>경기</option>
                    <option value="인천" ${region == '인천' ? 'selected' : ''}>인천</option>
                </select>
            </div>
            
            <div class="filter-item">
                <label>🍴 카테고리</label>
                <div class="chip-group">
                    <c:set var="cats" value="한식,일식,중식,양식,카페" />
                    <c:forEach var="cat" items="${fn:split(cats, ',')}">
                        <div class="cat-chip ${category == cat ? 'active' : ''}" 
                             onclick="selectCategory('${cat}')">${cat}</div>
                    </c:forEach>
                </div>
            </div>
        </form>
    </div>

    <%-- 2. 맛집 그리드 섹션 --%>
    <div class="store-grid">
        <c:choose>
            <c:when test="${not empty storeList}">
                <c:forEach var="store" items="${storeList}">
                    <div class="store-card" onclick="location.href='${pageContext.request.contextPath}/store/detail?storeId=${store.store_id}'">
                        <div class="store-img-box">
                            <c:choose>
                                <c:when test="${not empty store.store_img}">
                                    <img src="${pageContext.request.contextPath}/upload/${store.store_img}" class="store-thumb">
                                </c:when>
                                <c:otherwise>
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
            </c:when>
            <c:otherwise>
                <div class="empty-status-box" style="grid-column: 1/-1; text-align: center; padding: 80px; font-weight: 800; border: 2px dashed #ccc; border-radius: 15px; color: #999;">
                    검색 결과와 일치하는 맛집이 없습니다.
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- 3. 페이징 섹션 --%>
    <div class="pagination-container">
        <ul class="pagination">
            <c:if test="${pageMaker.prev}">
                <li class="page-item">
                    <a class="page-link" href="javascript:void(0);" onclick="movePage(${pageMaker.startPage - 1})">PREV</a>
                </li>
            </c:if>

            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                <li class="page-item ${pageMaker.cri.pageNum == num ? 'active' : ''}">
                    <a class="page-link" href="javascript:void(0);" onclick="movePage(${num})">${num}</a>
                </li>
            </c:forEach>

            <c:if test="${pageMaker.next}">
                <li class="page-item">
                    <a class="page-link" href="javascript:void(0);" onclick="movePage(${pageMaker.endPage + 1})">NEXT</a>
                </li>
            </c:if>
        </ul>
    </div>
</div>

<%-- [핵심 수정] 미작동의 원인: 스크립트 파일을 반드시 포함해야 합니다 --%>
<script src="${pageContext.request.contextPath}/resources/js/store_list.js"></script>

<jsp:include page="../common/footer.jsp" />