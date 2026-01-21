package com.uhi.gourmet.pay;

import java.io.IOException;

import com.siot.IamportRestClient.exception.IamportResponseException;

public interface PaymentService {
	// 결제 기능 (가격 비교를 포함한)
	public boolean paymentVal(String impUid) throws IamportResponseException, IOException;
	// 환불 기능
	public boolean refund(String impUid) throws IamportResponseException, IOException;
	// Pay하나 가져오기
	public PayVO getPayById(int pay_id);
	// impUid로 pay_id 가져오기
	public int getPayIdByImpUid(String impUid);
	
	public int deletePayById(int pay_id);
	
}
