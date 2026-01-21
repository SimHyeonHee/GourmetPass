/* com/uhi/gourmet/store/StoreService.java */
package com.uhi.gourmet.store;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;

public interface StoreService {
    // 1. 맛집 목록 및 상세 조회
    List<StoreVO> getStoreList(String category, String region, String keyword);
    StoreVO getStoreDetail(int storeId);
    List<MenuVO> getMenuList(int storeId);
    void plusViewCount(int storeId);
    
    // 2. 가게 관리 (Owner Only)
    void registerStore(StoreVO vo, String userId);
    void modifyStore(StoreVO vo, String userId);
    StoreVO getMyStore(int storeId, String userId); 
    StoreVO get_store_by_user_id(String userId);    
    
    // 3. 메뉴 관리 (Owner Only)
    void addMenu(MenuVO vo, String userId);
    void removeMenu(int menuId, String userId);
    MenuVO getMenuDetail(int menuId, String userId); 
    void modifyMenu(MenuVO vo, String userId);

    // [추가 및 수정 로직]
    // 단순히 시간표를 만드는 것이 아니라, 특정 날짜의 예약 현황을 반영하여 반환합니다.
    List<String> getAvailableTimeSlots(StoreVO store, String bookDate);
    List<String> generateTimeSlots(StoreVO store);
    String uploadFile(MultipartFile file, String realPath);
}