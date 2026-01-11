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
    
    // [추가] JSP 에러 해결 및 가게 이름 표시를 위한 필드
    private String store_name;    
    
    // [수정] 400 에러 방지를 위해 날짜 포맷 지정
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date book_date;       // 방문 예정 날짜
    
    // [추가] UI에서 별도로 넘어오는 시간을 받기 위한 필드
    private String book_time;     // 방문 예정 시간
    
    private int people_cnt;       // 예약 인원
    private Integer book_price;   // 예약 관련 금액 (Nullable)
    private String book_status;    // 예약 상태 (RESERVED, CANCELLED, FINISH, NOSHOW)
}