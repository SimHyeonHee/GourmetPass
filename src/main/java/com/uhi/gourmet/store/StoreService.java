package com.uhi.gourmet.store;

import java.util.List;

public interface StoreService {
    // 1. 맛집 목록 및 상세 조회 (Public)
	List<StoreVO> getStoreList(String category, String region, String keyword);
    StoreVO getStoreDetail(int storeId);
    List<MenuVO> getMenuList(int storeId);
    void plusViewCount(int storeId);
    
    // 2. 가게 관리 (Owner Only)
    void registerStore(StoreVO vo, String userId);
    void modifyStore(StoreVO vo, String userId);
    StoreVO getMyStore(int storeId, String userId); // 소유권 검증 포함 조회
    
    // 3. 메뉴 관리 (Owner Only)
    void addMenu(MenuVO vo, String userId);
    void removeMenu(int menuId, String userId);
    MenuVO getMenuDetail(int menuId, String userId); // 소유권 검증 포함 조회
    void modifyMenu(MenuVO vo, String userId);
}