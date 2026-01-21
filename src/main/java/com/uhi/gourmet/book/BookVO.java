package com.uhi.gourmet.book;

import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BookVO {
    private int book_id;          // 예약 고유 ID
    private String user_id;       // 예약자 ID (FK)
    private int store_id;         // 가게 고유 ID (FK)
    private int pay_id;         // 가게 고유 ID (FK)
    private String store_name;    // 가게 이름
    private Integer review_id;    // [추가] 작성된 리뷰 ID (중복 방지용)
    
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date book_date;       // 방문 예정 날짜
    
    private String book_time;     // 방문 예정 시간
    private int people_cnt;       // 예약 인원
    private Integer book_price;   // 금액
    private String book_status;    // 상태 (RESERVED, FINISH 등)
    
    
	@Override
	public String toString() {
		return "BookVO [book_id=" + book_id + ", user_id=" + user_id + ", store_id=" + store_id + ", pay_id=" + pay_id
				+ ", store_name=" + store_name + ", review_id=" + review_id + ", book_date=" + book_date
				+ ", book_time=" + book_time + ", people_cnt=" + people_cnt + ", book_price=" + book_price
				+ ", book_status=" + book_status + "]";
	}
    
    
}