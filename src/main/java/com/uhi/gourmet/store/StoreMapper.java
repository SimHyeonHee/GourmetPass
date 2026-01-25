/* com/uhi/gourmet/store/StoreMapper.java */
package com.uhi.gourmet.store;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface StoreMapper {

    // [1] 메인 페이지용 인기 맛집 조회 (조회수 기준 상위 6개)
    List<StoreVO> selectPopularStore();

    /**
     * [DTO 적용] 2. 맛집 리스트 조회
     * 기존 개별 @Param 방식에서 Criteria DTO 방식으로 변경하여 확장성을 확보했습니다.
     * @param cri 페이지 번호, 출력량, 검색 조건을 담은 객체
     */
    List<StoreVO> getListStore(@Param("cri") Criteria cri);

    /**
     * [신규] 2-1. 페이징을 위한 전체 맛집 개수 조회
     * PageDTO에서 실제 마지막 페이지(realEnd)를 계산하기 위해 반드시 필요합니다.
     * @param cri 검색 조건이 포함된 Criteria 객체
     */
    int getTotalCount(@Param("cri") Criteria cri);

    // [3] 특정 가게의 상세 정보 조회 (store_id 기준)
    StoreVO getStoreDetail(int store_id);

    // [4] 특정 가게에 등록된 메뉴 리스트 조회
    List<MenuVO> getMenuList(int store_id);

    // [5] 가게 상세 페이지 열람 시 조회수 증가
    void updateViewCount(int store_id);

    // [6] 가게 정보 등록
    void insertStore(StoreVO store);

    // [7] 점주 아이디로 해당 점주의 가게 조회
    StoreVO getStoreByUserId(String user_id);

    // [8] 가게 정보 수정
    void updateStore(StoreVO store);

    // [9] 메뉴 관리
    void insertMenu(MenuVO menu);
    void deleteMenu(int menu_id);
    void updateMenu(MenuVO menu);
    MenuVO getMenuDetail(int menu_id);

    // [10] 특정 날짜에 점유된 예약 시간 리스트 조회
    List<String> getBookedTimes(@Param("store_id") int store_id, 
                              @Param("book_date") String book_date);
}