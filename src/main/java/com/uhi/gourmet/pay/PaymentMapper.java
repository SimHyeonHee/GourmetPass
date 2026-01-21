package com.uhi.gourmet.pay;


import java.util.List;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface PaymentMapper {

	public void insertPayment(PayVO vo);
	
	public PayVO getPayById(int pay_id);
	
	public int getPayIdByImpUid(String impUid);
	
	public int deletePayById(int pay_id);
	
}
