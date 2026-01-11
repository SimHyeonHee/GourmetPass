<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<jsp:include page="../common/header.jsp" />

<style>
    /* 전체 레이아웃 정렬 */
    .mypage-wrapper {
        width: 80%;
        max-width: 600px;
        margin: 40px auto;
        font-family: sans-serif;
    }

    /* [1] 사용자님이 만족하셨던 프로필 섹션 복원 */
    .profile-card {
        background: #fff;
        border: 2px solid #333;
        border-radius: 15px;
        padding: 30px;
        display: flex;
        align-items: center;
        justify-content: space-between; /* 양 끝 정렬 */
        margin-bottom: 25px;
    }

    /* [2] 메뉴 버튼 정렬 (Grid & Flex) */
    .menu-container {
        display: flex;
        flex-direction: column;
        gap: 12px; /* 세로 간격 */
        width: 100%;
    }

    .button-row {
        display: flex;
        gap: 12px; /* 버튼 사이 간격 */
        width: 100%;
    }

    .btn-wire {
        flex: 1; /* 가로 너비 1:1 보장 */
        padding: 18px 0;
        border: 1px solid #333;
        border-radius: 8px;
        background: #fff;
        text-align: center;
        text-decoration: none;
        color: #333;
        font-weight: bold;
        font-size: 16px;
        cursor: pointer;
        box-sizing: border-box; /* 패딩이 너비에 영향을 주지 않도록 */
        display: block;
    }

    .btn-wire:hover {
        background: #f5f5f5;
    }

    .btn-full {
        width: 100%;
        background: #333;
        color: #fff;
    }

    /* 리뷰 리스트 정렬 */
    .review-section {
        margin-top: 50px;
        text-align: left;
    }

    .review-card {
        border: 1px solid #eee;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 15px;
        background: #fff;
    }
</style>

<div class="mypage-wrapper">
    
    <div class="profile-card">
        <div style="text-align: left;">
            <span style="font-size: 13px; color: #888; text-transform: uppercase;">Member Profile</span>
            <h2 style="margin: 5px 0;">${member.user_nm} <small style="font-weight: normal; color: #999;">님</small></h2>
            <p style="margin: 0; font-size: 14px; color: #666;">${member.user_id} | ${member.user_tel}</p>
        </div>
        <div style="font-size: 45px;">👤</div>
    </div>

    <div class="menu-container">
        <div class="button-row">
            <a href="<c:url value='/member/edit'/>" class="btn-wire">🛠️ 정보 수정</a>
            <form action="<c:url value='/logout'/>" method="post" style="flex: 1; margin: 0; padding: 0;">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <button type="submit" class="btn-wire" style="width: 100%; border: 1px solid #333;">🚪 로그아웃</button>
            </form>
        </div>

        <a href="<c:url value='/wait/myStatus'/>" class="btn-wire btn-full">📅 나 의 이 용 현 황</a>
    </div>

    <hr style="margin: 40px 0; border: 0; border-top: 1px solid #eee;">

    <div class="review-section">
        <h3 style="margin-bottom: 20px; font-size: 18px;">💬 나의 리뷰 기록 (${my_review_list.size()})</h3>
        
        <c:choose>
            <c:when test="${not empty my_review_list}">
                <c:forEach var="review" items="${my_review_list}">
                    <div class="review-card">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                            <div>
                                <a href="<c:url value='/store/detail?storeId=${review.store_id}'/>" 
                                   style="font-weight: bold; color: #333; text-decoration: none; font-size: 16px;">
                                   🏨 ${review.store_name} ❯
                                </a>
                                <div style="color: #f1c40f; margin-top: 5px;">
                                    <c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
                                </div>
                            </div>
                            <button type="button" onclick="confirmDeleteReview('${review.review_id}', '${review.store_id}')"
                                    style="background: none; border: 1px solid #ddd; color: #999; padding: 4px 8px; border-radius: 4px; cursor: pointer; font-size: 12px;">
                                삭제
                            </button>
                        </div>
                        <p style="margin: 15px 0; font-size: 14px; line-height: 1.6; color: #444;">${review.content}</p>
                        <div style="font-size: 12px; color: #bbb;">
                            <fmt:formatDate value="${review.review_date}" pattern="yyyy.MM.dd" />
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 50px; border: 1px dashed #ccc; border-radius: 10px; color: #bbb;">
                    아직 작성된 리뷰가 없습니다.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function confirmDeleteReview(reviewId, storeId) {
        if(confirm("이 리뷰를 삭제하시겠습니까?")) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/review/delete';
            const fields = {
                'review_id': reviewId,
                'store_id': storeId,
                '${_csrf.parameterName}': '${_csrf.token}'
            };
            for (const key in fields) {
                const input = document.createElement('input');
                input.type = 'hidden'; input.name = key; input.value = fields[key];
                form.appendChild(input);
            }
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>

<jsp:include page="../common/footer.jsp" />