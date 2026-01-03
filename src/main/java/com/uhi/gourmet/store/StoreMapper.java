package com.uhi.gourmet.store;

import java.util.List;
import org.apache.ibatis.annotations.Mapper; // 스프링 버전에 따라 생략 가능하지만 명시 권장

@Mapper
public interface StoreMapper {

    // [1] 점주 가입 시 가게 정보 등록 (MemberController에서 사용 중)
    void insertStore(StoreVO vo);

    // [2] 메인 페이지: 인기 맛집 Top N 조회 (MainController에서 사용 예정)
    // 조건: store_cnt(방문/예약수)가 높은 순서대로 4~8개 정도 가져옴
    List<StoreVO> selectPopularStore();

    // [3] 카테고리별 가게 리스트 조회 (Main에서 아이콘 클릭 시 이동할 list.do용)
    // 파라미터: "한식", "일식", "중식" 등
    List<StoreVO> selectStoreByCategory(String store_category);

    // [4] 가게 상세 정보 조회 (가게 클릭 시 detail.do용)
    StoreVO selectStoreDetail(int store_id);
}