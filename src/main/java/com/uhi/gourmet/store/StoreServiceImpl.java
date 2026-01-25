/* com/uhi/gourmet/store/StoreServiceImpl.java */
package com.uhi.gourmet.store;

import java.io.File;
import java.io.IOException;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
public class StoreServiceImpl implements StoreService {

    @Autowired
    private StoreMapper storeMapper;

    // 1. 맛집 목록 조회 (페이징 반영)
    @Override
    public List<StoreVO> getStoreList(Criteria cri) {
        return storeMapper.getListStore(cri);
    }

    // 1-1. 전체 데이터 개수 조회
    @Override
    public int getTotal(Criteria cri) {
        return storeMapper.getTotalCount(cri);
    }

    /**
     * [추가] 메인 페이지용 인기 맛집 조회 로직
     * Mapper에서 정의된 상위 6개 매장 조회 SQL을 실행합니다.
     */
    @Override
    public List<StoreVO> getPopularStores() {
        return storeMapper.selectPopularStore();
    }

    // 2. 맛집 상세 조회
    @Override
    @Transactional
    public StoreVO getStoreDetail(int storeId) {
        return storeMapper.getStoreDetail(storeId);
    }

    // 3. 메뉴 목록 조회
    @Override
    public List<MenuVO> getMenuList(int storeId) {
        return storeMapper.getMenuList(storeId);
    }

    // 4. 조회수 증가
    @Override
    public void plusViewCount(int storeId) {
        storeMapper.updateViewCount(storeId);
    }

    // 5. 가게 등록 (점주 전용)
    @Override
    @Transactional
    public void registerStore(StoreVO vo, String userId) {
        vo.setUser_id(userId);
        storeMapper.insertStore(vo);
    }

    // 6. 가게 정보 수정
    @Override
    @Transactional
    public void modifyStore(StoreVO vo, String userId) {
        StoreVO check = storeMapper.getStoreDetail(vo.getStore_id());
        if (check != null && check.getUser_id().equals(userId)) {
            vo.setUser_id(userId);
            storeMapper.updateStore(vo);
        }
    }

    // 7. 내 가게 정보 조회
    @Override
    public StoreVO getMyStore(int storeId, String userId) {
        StoreVO store = storeMapper.getStoreDetail(storeId);
        if (store != null && store.getUser_id().equals(userId)) {
            return store;
        }
        return null;
    }

    // 8. 점주 ID로 가게 조회
    @Override
    public StoreVO get_store_by_user_id(String userId) {
        return storeMapper.getStoreByUserId(userId);
    }

    // 9. 메뉴 추가
    @Override
    @Transactional
    public void addMenu(MenuVO vo, String userId) {
        StoreVO store = storeMapper.getStoreDetail(vo.getStore_id());
        if (store != null && store.getUser_id().equals(userId)) {
            if (vo.getMenu_sign() == null) vo.setMenu_sign("N");
            storeMapper.insertMenu(vo);
        }
    }

    // 10. 메뉴 삭제
    @Override
    @Transactional
    public void removeMenu(int menuId, String userId) {
        MenuVO menu = storeMapper.getMenuDetail(menuId);
        if (menu != null) {
            StoreVO store = storeMapper.getStoreDetail(menu.getStore_id());
            if (store != null && store.getUser_id().equals(userId)) {
                storeMapper.deleteMenu(menuId);
            }
        }
    }

    // 11. 메뉴 상세 조회
    @Override
    public MenuVO getMenuDetail(int menuId, String userId) {
        MenuVO menu = storeMapper.getMenuDetail(menuId);
        if (menu != null) {
            StoreVO store = storeMapper.getStoreDetail(menu.getStore_id());
            if (store != null && store.getUser_id().equals(userId)) {
                return menu;
            }
        }
        return null;
    }

    // 12. 메뉴 수정
    @Override
    @Transactional
    public void modifyMenu(MenuVO vo, String userId) {
        MenuVO menu = storeMapper.getMenuDetail(vo.getMenu_id());
        if (menu != null) {
            StoreVO store = storeMapper.getStoreDetail(menu.getStore_id());
            if (store != null && store.getUser_id().equals(userId)) {
                if (vo.getMenu_sign() == null) vo.setMenu_sign("N");
                storeMapper.updateMenu(vo);
            }
        }
    }

    // 13. 실시간 예약 가능 시간 슬롯 동적 생성
    @Override
    public List<String> getAvailableTimeSlots(StoreVO store, String bookDate) {
        List<String> allSlots = generateTimeSlots(store);
        List<String> bookedTimes = storeMapper.getBookedTimes(store.getStore_id(), bookDate);
        if (bookedTimes != null && !bookedTimes.isEmpty()) {
            allSlots.removeAll(bookedTimes);
        }
        return allSlots;
    }

    // 14. 기초 시간 슬롯 생성 로직 (영업시간 및 단위 기반)
    @Override
    public List<String> generateTimeSlots(StoreVO store) {
        List<String> slots = new ArrayList<>();
        if (store == null || store.getOpen_time() == null || store.getClose_time() == null) {
            return slots;
        }

        try {
            DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("HH:mm[:ss]");
            DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("HH:mm");

            LocalTime open = LocalTime.parse(store.getOpen_time(), inputFormatter);
            LocalTime close = LocalTime.parse(store.getClose_time(), inputFormatter);
            int unit = (store.getRes_unit() <= 0) ? 30 : store.getRes_unit();

            LocalTime current = open;
            while (current.isBefore(close)) {
                slots.add(current.format(outputFormatter));
                current = current.plusMinutes(unit);
            }
        } catch (Exception e) {
            System.err.println("TimeSlot Generation Error: " + e.getMessage());
        }
        return slots;
    }

    // 15. 파일 업로드 처리
    @Override
    public String uploadFile(MultipartFile file, String realPath) {
        File dir = new File(realPath);
        if (!dir.exists()) dir.mkdirs();

        String originalName = file.getOriginalFilename();
        String savedName = System.currentTimeMillis() + "_" + originalName;

        try {
            file.transferTo(new File(realPath, savedName));
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
        return savedName;
    }
}