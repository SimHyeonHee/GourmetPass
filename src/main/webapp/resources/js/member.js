/* src/main/webapp/resources/js/member.js */
$(document).ready(function() {
    
    // [1] 기존 로직: 로그인/로그아웃 알림 (사용자님 제공 코드)
    const error = $("#auth-msg").data("error");
    const logout = $("#auth-msg").data("logout");

    if (error) alert("아이디 또는 비밀번호가 잘못되었습니다.");
    if (logout) alert("성공적으로 로그아웃되었습니다. 이용해 주셔서 감사합니다.");


    // [2] 새 로직: 회원가입 상태 관리 변수
    let isIdChecked = false;
    let isPwMatched = false;


    // [3] 새 로직: 아이디 중복 확인 (AJAX)
    $("#btnIdCheck").click(function() {
        const userId = $("#user_id").val();
        
        if(userId.length < 3) {
            alert("아이디는 3글자 이상 입력해주세요.");
            return;
        }

        $.ajax({
            url: APP_CONFIG.contextPath + "/member/idCheck",
            type: "POST",
            data: { 
                user_id: userId, 
                [APP_CONFIG.csrfName]: APP_CONFIG.csrfToken 
            },
            success: function(res) {
                if(res === "success") {
                    $("#idCheckMsg").html("<span class='msg-ok'>사용 가능한 아이디입니다.</span>");
                    isIdChecked = true;
                } else {
                    $("#idCheckMsg").html("<span class='msg-no'>이미 사용 중인 아이디입니다.</span>");
                    isIdChecked = false;
                }
            }
        });
    });


    // [4] 새 로직: 비밀번호 일치 여부 실시간 확인
    $("#user_pw, #user_pw_confirm").on("keyup", function() {
        const pw = $("#user_pw").val();
        const pwConfirm = $("#user_pw_confirm").val();

        if(pw === "" || pwConfirm === "") {
            $("#pwCheckMsg").empty();
            return;
        }

        if(pw === pwConfirm) {
            $("#pwCheckMsg").html("<span class='msg-ok'>비밀번호가 일치합니다.</span>");
            isPwMatched = true;
        } else {
            $("#pwCheckMsg").html("<span class='msg-no'>비밀번호가 일치하지 않습니다.</span>");
            isPwMatched = false;
        }
    });


    // [5] 새 로직: 회원가입 및 단계별 폼 최종 검증
    $("#joinForm, #ownerStep2Form").submit(function() {
        // 아이디 중복확인 여부 체크
        if($("#user_id").length > 0 && !isIdChecked) {
            alert("아이디 중복확인을 해주세요.");
            return false;
        }
        
        // 비밀번호 일치 여부 체크
        if($("#user_pw").length > 0 && !isPwMatched) {
            alert("비밀번호 확인이 일치하지 않습니다.");
            return false;
        }

        // 점주 가입 2단계: 위치 정보 체크
        if($("#store_lat").length > 0 && $("#store_lat").val() == "0.0") {
            alert("가게 위치 검색을 통해 주소를 확정해주세요.");
            return false;
        }

        return true;
    });
    
    /**
 * 회원 탈퇴 처리
 */
function dropUser(userId) {
    if (confirm("정말로 탈퇴하시겠습니까?\n탈퇴 시 모든 예약 및 웨이팅 내역이 삭제됩니다.")) {
        // 탈퇴 프로세스 호출 (CSRF 토큰 필요)
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = APP_CONFIG.contextPath + '/member/withdraw';
        
        const csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = APP_CONFIG.csrfName;
        csrfInput.value = APP_CONFIG.csrfToken;
        
        form.appendChild(csrfInput);
        document.body.appendChild(form);
        form.submit();
    }
}

});