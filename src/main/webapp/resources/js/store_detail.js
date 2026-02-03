/**
 * 고메패스 맛집 상세 페이지 전용 스크립트 [v1.1.7]
 * 리팩토링: 전역 함수 안정화 및 결제 로직 통합
 */

// ================================================================
// [A] 전역 함수 영역
// ================================================================

/**
 * 1. 실시간 예약 가능 시간 슬롯 로드
 */
window.loadAvailableSlots = function() {
    const app = document.getElementById('storeDetailApp');
    if (!app) return;

    const contextPath = app.dataset.context;
    const storeId = app.dataset.storeId;
    const openTime = app.dataset.openTime;
    const closeTime = app.dataset.closeTime;
    const resUnit = parseInt(app.dataset.resUnit) || 30;

    const bookDate = $("#bookDate").val();
    const container = $("#timeSlotContainer");

    if (!bookDate || !container.length) return;

    // 현재 시간 기준 마감 처리
    const now = new Date();
    const todayStr = now.getFullYear() + "-" + String(now.getMonth() + 1).padStart(2, '0') + "-" + String(now.getDate()).padStart(2, '0');
    const bufferTime = new Date(now.getTime() + 10 * 60000); 
    const currentTimeStr = String(bufferTime.getHours()).padStart(2, '0') + ":" + String(bufferTime.getMinutes()).padStart(2, '0');

    container.html("<p class='status-text'>조회 중...</p>");
    $("#selectedTime").val(""); 

    $.ajax({
        url: contextPath + "/store/api/timeSlots",
        type: "GET",
        data: { store_id: storeId, book_date: bookDate },
        dataType: "json",
        success: function(availableList) {
            const allSlots = generateAllSlots(openTime, closeTime, resUnit); 
            let html = "";

            allSlots.forEach(time => {
                const isBooked = !availableList.includes(time);
                const isPast = (bookDate === todayStr && time <= currentTimeStr);

                if (isBooked || isPast) {
                    const reason = isPast ? "마감" : "예약됨";
                    html += `<button type="button" class="time-btn disabled" disabled title="${reason}">${time}</button>`;
                } else {
                    html += `<button type="button" class="time-btn" data-time="${time}">${time}</button>`;
                }
            });
            container.html(html || "<p>영업 시간이 설정되지 않았습니다.</p>");
        },
        error: function() {
            container.html("<p class='error-text'>정보 로드 실패</p>");
        }
    });
};

/**
 * 2. 영업시간 기반 슬롯 배열 생성
 */
window.generateAllSlots = function(open, close, unit) {
    const slots = [];
    let current = open;
    if(!current || !close) return slots;

    while (current <= close) {
        slots.push(current);
        let [h, m] = current.split(':').map(Number);
        m += unit;
        if (m >= 60) { h++; m -= 60; }
        current = String(h).padStart(2, '0') + ":" + String(m).padStart(2, '0');
        if (current > close) break;
    }
    return slots;
};

/**
 * 3. 예약/웨이팅 섹션 전환
 */
window.showInteraction = function(type) {
    $(".interaction-card").hide();
    const target = $("#" + type + "-area");
    if (target.length) {
        target.fadeIn();
        $('html, body').animate({ scrollTop: target.offset().top - 100 }, 500);
    }
    $(".btn-main-wire").removeClass("active");
    $(".btn-" + type).addClass("active");
};


// ================================================================
// [B] 문서 로드 완료 후 실행 영역
// ================================================================

$(document).ready(function() {
    const app = document.getElementById('storeDetailApp');
    if (!app) return;

    // 1. 날짜 초기값 설정
    const now = new Date();
    const today = now.getFullYear() + "-" + String(now.getMonth() + 1).padStart(2, '0') + "-" + String(now.getDate()).padStart(2, '0');
    $("#bookDate").val(today).attr("min", today);

    // 2. 지도 초기화 (Kakao Maps API)
    if (app.dataset.lat && app.dataset.lng) {
        const container = document.getElementById('map');
        if (container) {
            const options = {
                center: new kakao.maps.LatLng(app.dataset.lat, app.dataset.lng),
                level: 3
            };
            const map = new kakao.maps.Map(container, options);
            new kakao.maps.Marker({ position: options.center }).setMap(map);
        }
    }

    // 3. 시간 버튼 클릭 처리
    $(document).on("click", ".time-btn:not([disabled])", function() {
	    $(".time-btn").removeClass("active");
	    $(this).addClass("active");
	    $("#selectedTime").val($(this).data("time")); 
    });

     // [4] 예약 폼 제출 핸들러 (중복 체크 -> 결제 -> 제출)
    $("#bookForm").on("submit", function(e) {
        e.preventDefault();
        const form = this;
        const selectedTime = $("#selectedTime").val();
        const bookDate = $("#bookDate").val();
        const storeId = $("input[name='store_id']").val();
        const contextPath = app.dataset.context;
        

        if(!selectedTime) {
            alert("방문 시간을 선택해 주세요!");
            return;
        }
        // [Step 1] 예약 중복 체크
        $.ajax({
            url: contextPath + "/book/api/checkDuplicate",
            type: "GET",
            data: { store_id: storeId, book_date: bookDate, book_time: selectedTime },
            // V2 결제창이 Promise 기반이므로 콜백에 async 추가
            success: async function(result) {
                if (result === "AVAILABLE") {
                    if(!confirm(bookDate + " " + selectedTime + " 예약을 위해 결제를 진행하시겠습니까?")) return;

                    try {
                        // [Step 2] 포트원 V2 결제창 호출
                        const response = await PortOne.requestPayment({
                            storeId: loginUserInfo.portOneStoreId, // 본인 Store ID
                            channelKey: loginUserInfo.portOneChannelKey, // V2 채널 키
                            paymentId: "pay-" + new Date().getTime(),
                            orderName: "예약 보증금",
                            totalAmount: 1000,
                            currency: "CURRENCY_KRW",
                            payMethod: "CARD",
                            customer: {
                                fullName: loginUserInfo.name,
                                phoneNumber: loginUserInfo.tel,
                                email: loginUserInfo.email
                            }
                        });

                        // [Step 3] 결제 결과 처리
                        // V2는 성공 시 response.code가 존재하지 않음(null)
                        if (response.code == null) {
                            
                            // [Step 4] 서버 결제 검증 (V2 방식: JSON 전송)
                            $.ajax({
                                url: contextPath + '/pay/api/v2/payment/complete',
                                type: 'POST',
                                contentType: 'application/json',
                                data: JSON.stringify({ paymentId: response.paymentId }),
                                beforeSend: function(xhr) {
                                    if(typeof APP_CONFIG !== 'undefined') {
                                        xhr.setRequestHeader("X-CSRF-TOKEN", APP_CONFIG.csrfToken);
                                    }
                                }
                            }).done(function(payId) {
                                // 검증 성공 시 받은 payId를 hidden 필드에 넣고 폼 제출
                                $("#payIdField").val(payId);
                                alert("결제가 완료되었습니다!");
                                form.submit(); 
                            }).fail(function(xhr) {
                                console.error("서버 검증 실패:", xhr.responseText);
                                alert("결제 검증에 실패했습니다. 관리자에게 문의하세요.");
                            });

                        } else {
                            // 결제창 실패 또는 사용자가 닫음
                            alert("결제가 취소되었습니다: " + response.message);
                        }

                    } catch (err) {
                        console.error("결제 프로세스 에러:", err);
                        alert("결제창을 불러오는 중 오류가 발생했습니다.");
                    }

                } else if (result === "DUPLICATE_TIME") {
                    alert("죄송합니다. 그 사이에 예약이 마감되었습니다.");
                    window.loadAvailableSlots();
                } else if (result === "DUPLICATE_USER") {
                    alert("해당 날짜에 이미 예약 내역이 존재합니다.");
                } else {
                    alert("예약 정보를 확인하는 중 문제가 발생했습니다.");
                }
            },
            error: function() {
                alert("서버 통신 중 오류가 발생했습니다.");
            }
        });
    });

    // 5. 초기 슬롯 실행
    window.loadAvailableSlots();
});