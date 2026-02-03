package com.uhi.gourmet.pay;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@AllArgsConstructor
@NoArgsConstructor
@Data
public class PayVO {
	private int pay_id;
	private String payment_id;
	private int amount;
	private Date pay_date;
	
	
}
