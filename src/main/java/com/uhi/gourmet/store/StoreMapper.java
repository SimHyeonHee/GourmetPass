/* com/uhi/gourmet/store/StoreMapper.java */
package com.uhi.gourmet.store;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface StoreMapper {

    // [1] 메인 페이지용 인기 맛집 조회 (조회수 기준 상위 6개)
    List<StoreVO> selectPopularStore();

    // [2] 맛집 리스트 조회 (카테고리, 지역, 검색어로 필터링 가능)
    List<StoreVO> getListStore(@Param("category") String category, 
                             @Param("region") String region, 
                             @Param("keyword") String keyword);

    // [3] 특정 가게의 상세 정보 조회 (store_id 기준)
    StoreVO getStoreDetail(int store_id);

    // [4] 특정 가게에 등록된 메뉴 리스트 조회
    List<MenuVO> getMenuList(int store_id);

    // [5] 가게 상세 페이지 열람 시 조회수 증가
    void updateViewCount(int store_id);

    // [6] 가게 정보 등록 (점주 user_id 포함)
    void insertStore(StoreVO store);

    // [7] 점주 아이디로 해당 점주의 가게 조회 (1:1 구조)
    StoreVO getStoreByUserId(String user_id);

    // [8] 가게 정보 수정
    void updateStore(StoreVO store);

    // [9] 메뉴 관리 (등록, 삭제, 수정, 상세조회)
    void insertMenu(MenuVO menu);
    void deleteMenu(int menu_id);
    void updateMenu(MenuVO menu);
    MenuVO getMenuDetail(int menu_id);

    /**
     * [교정 포인트] 10. 특정 날짜에 이미 점유된 예약 시간 리스트 조회
     * 기능: StoreServiceImpl.java의 getAvailableTimeSlots에서 호출하여 중복 예약을 필터링합니다.
     * @param store_id 해당 가게 번호
     * @param book_date 예약 시도 날짜 (YYYY-MM-DD)
     * @return 이미 예약된 시간 리스트 (예: ["12:00", "13:30"])
     */
    List<String> getBookedTimes(@Param("store_id") int store_id, 
                              @Param("book_date") String book_date);
    
}