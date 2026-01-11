package com.uhi.gourmet.review;

import java.util.Date;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReviewVO {
    private int review_id;      // 리뷰 고유 번호 (PK)
    private int store_id;       // 가게 고유 번호 (FK)
    private Integer book_id;    // 예약 번호 (FK, null 허용)
    private Integer wait_id;    // 웨이팅 번호 (FK, null 허용)
    private int rating;         // 별점 (1~5)
    private String content;     // 리뷰 내용
    private String img_url;     // 리뷰 이미지 경로
    private Date review_date;   // 작성일

    // [조인용 추가 필드] DB 테이블에는 없지만 화면 출력에 꼭 필요한 필드들
    private String user_nm;     // 작성자 이름 (가게 상세페이지 출력용)
    private String user_id;     // 작성자 아이디
    private String store_name;  // 가게 이름 (마이페이지 내 리뷰 목록 출력용)
}