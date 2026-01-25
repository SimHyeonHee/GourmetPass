/* com/uhi/gourmet/store/StoreService.java */
package com.uhi.gourmet.store;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;

/**
 * 맛집 관련 비즈니스 로직 인터페이스
 */
public interface StoreService {
    
    // 1. 맛집 목록 및 상세 조회
    /**
     * [DTO 적용] 맛집 목록 조회
     * @param cri 현재 페이지, 페이지당 게시물 수, 검색 조건을 담은 객체 
     * @return 검색 조건 및 페이징이 적용된 맛집 리스트
     */
    List<StoreVO> getStoreList(Criteria cri);

    /**
     * [신규] 전체 데이터 개수 조회
     * 페이징 바 UI 생성을 위한 총 레코드 수를 반환합니다. 
     * @param cri 검색 조건이 포함된 Criteria 객체
     * @return 전체 행 수
     */
    int getTotal(Criteria cri);

    /**
     * [신규] 메인 페이지용 인기 맛집 조회
     * 조회수(store_cnt) 기준 상위 6개의 매장을 반환합니다.
     */
    List<StoreVO> getPopularStores();

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
    List<String> getAvailableTimeSlots(StoreVO store, String bookDate);
    List<String> generateTimeSlots(StoreVO store);
    String uploadFile(MultipartFile file, String realPath);
}