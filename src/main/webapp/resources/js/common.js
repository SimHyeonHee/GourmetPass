/* src/main/webapp/resources/js/common.js */

/**
 * 전화번호 자동 하이픈 (제공하신 로직 그대로 유지)
 */
const autoHyphen = (target) => {
    let val = target.value.replace(/[^0-9]/g, "");
    let str = "";

    if (val.startsWith("02")) {
        if (val.length < 3) { str = val; }
        else if (val.length < 6) { str = val.substr(0, 2) + "-" + val.substr(2); }
        else if (val.length < 10) { str = val.substr(0, 2) + "-" + val.substr(2, 3) + "-" + val.substr(5); }
        else { str = val.substr(0, 2) + "-" + val.substr(2, 4) + "-" + val.substr(6); }
    } else {
        if (val.length < 4) { str = val; }
        else if (val.length < 7) { str = val.substr(0, 3) + "-" + val.substr(3); }
        else if (val.length < 11) { str = val.substr(0, 3) + "-" + val.substr(3, 3) + "-" + val.substr(6); }
        else { str = val.substr(0, 3) + "-" + val.substr(3, 4) + "-" + val.substr(7); }
    }
    target.value = str;
};

/**
 * [원칙 1] JSP 내 onclick 이벤트를 대체하기 위한 공통 클릭 핸들러
 */
$(document).ready(function() {
    $(".clickable").on("click", function() {
        var url = $(this).data("url");
        if(url) {
            location.href = APP_CONFIG.contextPath + url;
        }
    });
});