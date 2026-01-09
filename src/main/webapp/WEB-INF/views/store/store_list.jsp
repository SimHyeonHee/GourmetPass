<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:include page="../common/header.jsp" />

<style>
    .search-container { width: 90%; margin: 20px auto; padding: 25px; background: #fff; border: 1px solid #ddd; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
    .filter-row { display: flex; align-items: center; gap: 25px; flex-wrap: wrap; margin-bottom: 15px; }
    .search-row { display: flex; align-items: center; gap: 10px; width: 100%; padding-top: 15px; border-top: 1px solid #eee; }
    
    /* 실시간 검색창 스타일 */
    .input-search { flex: 1; padding: 10px 15px; border: 2px solid #eee; border-radius: 8px; font-size: 15px; transition: 0.3s; }
    .input-search:focus { border-color: #ff3d00; outline: none; }
    
    /* 카테고리 칩 스타일 */
    .cat-chip { cursor: pointer; padding: 6px 15px; border-radius: 20px; border: 1px solid #ddd; background: #fff; font-size: 14px; transition: 0.2s; }
    .cat-chip:hover { border-color: #ff3d00; color: #ff3d00; }
    .cat-chip.active { background: #ff3d00; color: #fff; border-color: #ff3d00; font-weight: bold; }

    .store-table { width: 90%; margin: 0 auto 50px; border-collapse: collapse; }
    .store-table th { background: #f8f9fa; padding: 15px; border-bottom: 2px solid #eee; }
    .store-table td { padding: 15px; border-bottom: 1px solid #f0f0f0; vertical-align: middle; }
</style>

<div class="search-container">
    <form id="filterForm" action="${pageContext.request.contextPath}/store/list" method="get">
        <div class="filter-row">
            <div>
                <b style="margin-right:10px;">📍 지역</b>
                <select name="region" onchange="submitFilter()" style="padding: 8px; border-radius: 5px; border: 1px solid #ccc;">
                    <option value="">전체 지역</option>
                    <option value="서울" ${region == '서울' ? 'selected' : ''}>서울</option>
                    <option value="경기" ${region == '경기' ? 'selected' : ''}>경기</option>
                    <option value="부산" ${region == '부산' ? 'selected' : ''}>부산</option>
                </select>
            </div>

            <div style="display: flex; align-items: center; gap: 10px;">
                <b style="margin-left:10px;">📂 카테고리</b>
                <input type="hidden" name="category" id="selectedCategory" value="${category}">
                
                <div class="cat-chip ${empty category ? 'active' : ''}" onclick="selectCategory('')">전체</div>
                <div class="cat-chip ${category == '한식' ? 'active' : ''}" onclick="selectCategory('한식')">한식</div>
                <div class="cat-chip ${category == '일식' ? 'active' : ''}" onclick="selectCategory('일식')">일식</div>
                <div class="cat-chip ${category == '중식' ? 'active' : ''}" onclick="selectCategory('중식')">중식</div>
                <div class="cat-chip ${category == '양식' ? 'active' : ''}" onclick="selectCategory('양식')">양식</div>
            </div>
        </div>

        <div class="search-row">
            <input type="text" name="keyword" value="${keyword}" class="input-search" placeholder="가게 이름으로 검색해 보세요 (예: 미슐랭, 파스타 등)" onkeypress="if(event.keyCode==13){submitFilter();}">
            <button type="button" onclick="submitFilter()" style="padding: 10px 25px; background: #333; color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: bold;">
                검색
            </button>
        </div>
    </form>
</div>

<table class="store-table">
    <thead>
        <tr>
            <th width="120">사진</th>
            <th width="100">카테고리</th>
            <th>가게명</th>
            <th>지역/주소</th>
            <th width="80">조회수</th>
            <th width="120">상세보기</th>
        </tr>
    </thead>
    <tbody>
        <c:choose>
            <c:when test="${not empty storeList}">
                <c:forEach var="store" items="${storeList}">
                    <tr>
                        <td align="center">
                            <c:if test="${not empty store.store_img}">
                                <img src="${pageContext.request.contextPath}/resources/upload/${store.store_img}" width="100" height="75" style="object-fit: cover; border-radius: 6px;">
                            </c:if>
                        </td>
                        <td align="center"><span style="font-size:13px; color:#777;">${store.store_category}</span></td>
                        <td>
                            <strong style="font-size: 17px;">${store.store_name}</strong>
                            <c:if test="${store.store_cnt > 100}"><span style="color:red; font-size:10px; margin-left:5px;">[HOT]</span></c:if>
                        </td>
                        <td>${store.store_addr1}</td>
                        <td align="center">${store.store_cnt}</td>
                        <td align="center">
                            <button onclick="location.href='detail?storeId=${store.store_id}'" style="padding: 6px 15px; background: #fff; border: 1px solid #333; cursor: pointer; border-radius: 4px;">상세보기</button>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr><td colspan="6" align="center" style="padding:100px; color:#999;">검색 결과가 없습니다. 😢</td></tr>
            </c:otherwise>
        </c:choose>
    </tbody>
</table>

<script>
    // 1. 통합 제출 함수
    function submitFilter() {
        document.getElementById('filterForm').submit();
    }

    // 2. 카테고리 선택 함수
    function selectCategory(cat) {
        document.getElementById('selectedCategory').value = cat;
        submitFilter();
    }
</script>

<jsp:include page="../common/footer.jsp" />