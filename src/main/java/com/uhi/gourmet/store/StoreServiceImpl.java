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

    // 1. 맛집 목록 조회
    @Override
    public List<StoreVO> getStoreList(String category, String region, String keyword) {
        return storeMapper.getListStore(category, region, keyword);
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

    /**
     * [교정] 13. 실시간 예약 가능 시간 슬롯 동적 생성
     * 기능: 전체 시간표에서 이미 DB에 예약된 시간을 제외하고 반환하여 중복 예약을 원천 차단합니다.
     */
    @Override
    public List<String> getAvailableTimeSlots(StoreVO store, String bookDate) {
        // 1. 가게 설정에 기반한 전체 타임슬롯 생성
        List<String> allSlots = generateTimeSlots(store);
        
        // 2. DB에서 해당 날짜에 이미 예약된 시간 목록 조회
        // (주의: StoreMapper 인터페이스와 XML에 getBookedTimes가 정의되어야 함)
        List<String> bookedTimes = storeMapper.getBookedTimes(store.getStore_id(), bookDate);
        
        // 3. 전체 슬롯에서 이미 점유된 시간들을 제거
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