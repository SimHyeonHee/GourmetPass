/* src/main/webapp/resources/js/mypage.js */

/**
 * 1. 메뉴 삭제 처리 (점주 전용)
 * @param {number} menuId - 삭제할 메뉴의 고유 ID
 */
function deleteMenu(menuId) {
    if(confirm("정말로 이 메뉴를 삭제하시겠습니까?\n삭제 후에는 복구할 수 없습니다.")) {
        submitPostRequest('/store/menu/delete', {
            'menu_id': menuId
        });
    }
}

/**
 * 2. 리뷰 삭제 처리 (공용)
 * @param {string} reviewId - 삭제할 리뷰 ID
 * @param {string} storeId - 해당 맛집 ID
 */
function confirmDeleteReview(reviewId, storeId) {
    if(confirm("이 리뷰를 삭제하시겠습니까?")) {
        submitPostRequest('/review/delete', {
            'review_id': reviewId,
            'store_id': storeId
        });
    }
}

/**
 * [공통 로직] POST 요청 폼 생성 및 전송
 * @param {string} url - 요청 경로 (contextPath 제외)
 * @param {object} params - 전송할 데이터 파라미터
 */
function submitPostRequest(url, params) {
    var form = document.createElement('form');
    form.method = 'POST';
    form.action = APP_CONFIG.contextPath + url;
    
    // [오류 수정] 최신 문법(Spread Operator) 대신 표준 할당 방식 사용
    var fields = params || {};
    fields[APP_CONFIG.csrfName] = APP_CONFIG.csrfToken;

    for (var key in fields) {
        if (fields.hasOwnProperty(key)) {
            var input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = fields[key];
            form.appendChild(input);
        }
    }

    document.body.appendChild(form);
    form.submit();
}