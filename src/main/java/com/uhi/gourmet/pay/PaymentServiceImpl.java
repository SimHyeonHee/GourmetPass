package com.uhi.gourmet.pay;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.exception.IamportResponseException;
import com.siot.IamportRestClient.request.CancelData;
import com.siot.IamportRestClient.response.IamportResponse;
import com.siot.IamportRestClient.response.Payment;

import lombok.extern.slf4j.Slf4j;


@Service
public class PaymentServiceImpl implements PaymentService{
	
	@Autowired
	private PaymentMapper mapper;
	
//	private String apiSecret = "4O1Tu4XejyKK8zIkJfdvNZcLYG7GQU3sBsHcmCRILoeTEDpdUVKhxdQdERXAFzPcmoxYlDZ6b9YkJWyX";
	
	@Value("${portone.api.secret}")
    private String apiSecret;
	
	
	
 // 예약금 가격과 결제되는 가격 비교 로직
 	@Override
     public boolean paymentVal(String paymentId) throws IOException {
         System.out.println("V2 결제 검증 시작: " + paymentId);

         // 1. RestTemplate 생성 (Spring의 HTTP 통신 객체)
         RestTemplate restTemplate = new RestTemplate();
         String url = "https://api.portone.io/payments/" + paymentId;

         // 2. 헤더 설정 (V2 인증 방식: PortOne 시크릿키)
         HttpHeaders headers = new HttpHeaders();
         headers.set("Authorization", "PortOne " + apiSecret);
         headers.setContentType(MediaType.APPLICATION_JSON);
         HttpEntity<String> entity = new HttpEntity<>(headers);

         try {
             // 3. 포트원 API 호출 (GET)
             ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.GET, entity, Map.class);
             Map<String, Object> paymentData = response.getBody();

             if (paymentData == null) return false;

             // 4. 결제 상태 및 금액 추출 (V2 응답 구조)
             String status = (String) paymentData.get("status"); // PAID, CANCELLED 등
             
             // amount 객체 안의 total 값을 가져옴
             Map<String, Object> amountObj = (Map<String, Object>) paymentData.get("amount");
             int actualAmount = (int) amountObj.get("total");

             int expectedPrice = 1000; // 서버에서 기대하는 금액 (예약금)

             System.out.println("결제 상태: " + status + ", 실결제금액: " + actualAmount);

             if ("PAID".equals(status) && actualAmount == expectedPrice) {
                 System.out.println("결제 검증 성공: DB 저장 로직 실행");
                 
                 PayVO vo = new PayVO();
                 vo.setPayment_id(paymentId); // 필드명은 유지하되 paymentId 저장
                 vo.setAmount(actualAmount);
                 
                 mapper.insertPayment(vo);
                 return true;
             } else {
                 System.out.println("검증 실패: 금액 불일치 또는 결제 미완료");
                 // 필요한 경우 여기서 V2 환불 API 호출 로직 추가
                 // V2 환불 URL (포트원 공식 문서 기준)
                 url = "https://api.portone.io/payments/" + paymentId + "/cancel";
                HttpHeaders refundHeaders = new HttpHeaders();
                refundHeaders.set("Authorization", "PortOne " + apiSecret); // properties에 저장된 V2 Secret
         	    refundHeaders.setContentType(MediaType.APPLICATION_JSON);

         	    // 4. 바디 설정 (사유는 필수값이 아닐 수 있으나 보내주는 것이 좋습니다)
         	    Map<String, String> body = new HashMap<>();
         	    body.put("reason", "고객 요청에 의한 환불");

         	    HttpEntity<Map<String, String>> reFundentity = new HttpEntity<>(body, headers);
                 
	         	   try {
	       	        // 5. POST 요청 전송
	         		   
	       	        ResponseEntity<Map> refundResponse = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);
	       	        
	       	        if (refundResponse.getStatusCode() == HttpStatus.OK) {
	       	            System.out.println("포트원 V2 환불 성공: " + paymentId);
	       	            // 여기서 DB 상태를 'REFUNDED' 등으로 업데이트하는 로직을 추가하면 완벽합니다.
	       	            return true;
	       	        }
	       	    } catch (Exception e) {
	       	    	System.out.println("환불 처리 중 서버 에러: " + e.getMessage());
	       	    }
         	    
                 return false;
             }
         } catch (Exception e) {
             System.err.println("API 호출 중 오류 발생: " + e.getMessage());
             return false;
         }
     }

 	@Override
	public boolean refund(String paymentId) throws IOException {
		
		// 1. RestTemplate 생성
	    RestTemplate restTemplate = new RestTemplate();
	    
	    // 2. V2 환불 URL (포트원 공식 문서 기준)
	    String url = "https://api.portone.io/payments/" + paymentId + "/cancel";

	    // 3. 헤더 설정 (중요: PortOne 키워드 필수)
	    HttpHeaders headers = new HttpHeaders();
	    headers.set("Authorization", "PortOne " + apiSecret); // properties에 저장된 V2 Secret
	    headers.setContentType(MediaType.APPLICATION_JSON);

	    // 4. 바디 설정 (사유는 필수값이 아닐 수 있으나 보내주는 것이 좋습니다)
	    Map<String, String> body = new HashMap<>();
	    body.put("reason", "고객 요청에 의한 환불");

	    HttpEntity<Map<String, String>> entity = new HttpEntity<>(body, headers);

	    try {
	        // 5. POST 요청 전송
	        ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);
	        
	        if (response.getStatusCode() == HttpStatus.OK) {
	            System.out.println("포트원 V2 환불 성공: " + paymentId);
	            // 여기서 DB 상태를 'REFUNDED' 등으로 업데이트하는 로직을 추가하면 완벽합니다.
	            return true;
	        }
	    } catch (Exception e) {
	    	System.out.println("환불 처리 중 서버 에러: " + e.getMessage());
	    }
	    return false;
//		if(response.getResponse() != null) {	// 환불 로직 실행
//			log.info("환불 성공............");
//			return true;
//			
//		} else {
//			log.info("환불 실패............");
//			return false;
//		}
		
	}
	
	
	// pay_id로 PayVO 하나 가져오기
	@Override
	public PayVO getPayById(int pay_id) {
		System.out.println("Service() getPayById()............");

		return mapper.getPayById(pay_id);
	}


	@Override
	public int deletePayById(int pay_id) {
		System.out.println("Service() getPayById()............");
		
		return mapper.deletePayById(pay_id);
	}


	@Override
	public int getPayIdByImpUid(String impUid) {
		System.out.println("Service() getPayByIdImpUid()............");
		
		return mapper.getPayIdByImpUid(impUid);
	}
	
	

}
