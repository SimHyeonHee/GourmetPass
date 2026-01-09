package com.uhi.gourmet.store;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface StoreMapper {

    // 메인 페이지용 인기 맛집 조회 (조회수 기준 상위 6개)
    List<StoreVO> selectPopularStore();

    // 맛집 리스트 조회 (카테고리, 지역으로 필터링 가능)
    List<StoreVO> getListStore(@Param("category") String category, 
            @Param("region") String region, 
            @Param("keyword") String keyword);

    // 특정 가게의 상세 정보 조회 (store_id 기준)
    StoreVO getStoreDetail(int store_id);

    // 특정 가게에 등록된 메뉴 리스트 조회
    List<MenuVO> getMenuList(int store_id);

    // 가게 상세 페이지 열람 시 조회수 증가
    void updateViewCount(int store_id);

    // 가게 정보 등록 (점주 user_id 포함)
    void insertStore(StoreVO store);

    // 점주 아이디로 해당 점주의 가게 1개 조회 (1:1 구조)
    StoreVO getStoreByUserId(String user_id);

    // 가게 정보 수정 (점주 아이디는 변경하지 않음)
    void updateStore(StoreVO store);

    // 메뉴 등록 (특정 가게에 메뉴 추가)
    void insertMenu(MenuVO menu);

    // 메뉴 삭제 (menu_id 기준)
    void deleteMenu(int menu_id);

    // 메뉴 수정 (이름, 가격, 이미지, 대표여부 등 변경)
    void updateMenu(MenuVO menu);

    // 메뉴 단건 조회 (수정 화면용 상세 조회)
    MenuVO getMenuDetail(int menu_id);
    
    
}
