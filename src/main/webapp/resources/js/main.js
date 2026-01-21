/* src/main/webapp/resources/js/main.js */
$(document).ready(function() {
    // [원칙 1: 분리] JSP에 직접 작성했던 onclick 로직을 이곳으로 통합
    // [원칙 3: 용이성] clickable 클래스를 가진 요소에 클릭 이벤트 일괄 부여
    $(".clickable").on("click", function() {
        var url = $(this).data("url");
        if(url) {
            location.href = APP_CONFIG.contextPath + url;
        }
    });
});