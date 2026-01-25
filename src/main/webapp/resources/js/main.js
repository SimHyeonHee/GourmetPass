/* src/main/webapp/resources/js/main.js */
$(document).ready(function() {
    /**
     * [교정] 공통 클릭 이벤트 핸들러
     * - clickable 클래스를 가진 요소의 data-url 속성을 읽어 페이지를 이동시킵니다.
     * - main.jsp에서 이미 contextPath가 포함된 URL을 생성하므로 추가 경로 연산이 필요 없습니다.
     */
    $(".clickable").on("click", function() {
        var url = $(this).data("url");
        if(url) {
            // JSTL로 생성된 풀 경로를 그대로 사용합니다.
            location.href = url;
        }
    });

    // 검색창 엔터키 입력 시 폼 제출 보조 (선택 사항)
    $(".search-input").on("keypress", function(e) {
        if (e.which == 13) {
            $(this).closest("form").submit();
        }
    });
});