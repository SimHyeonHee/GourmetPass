package com.uhi.gourmet.store;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class StoreServiceImpl implements StoreService {

    @Autowired
    private StoreMapper storeMapper;

    @Override
    public List<StoreVO> getStoreList(String category, String region, String keyword) {
        // 3개의 인자(category, region, keyword)를 모두 mapper에 전달
        return storeMapper.getListStore(category, region, keyword);
    }

    @Override
    @Transactional
    public StoreVO getStoreDetail(int storeId) {
        return storeMapper.getStoreDetail(storeId);
    }

    @Override
    public List<MenuVO> getMenuList(int storeId) {
        return storeMapper.getMenuList(storeId);
    }

    @Override
    public void plusViewCount(int storeId) {
        storeMapper.updateViewCount(storeId);
    }

    @Override
    @Transactional
    public void registerStore(StoreVO vo, String userId) {
        vo.setUser_id(userId); // 점주 ID 세팅
        storeMapper.insertStore(vo);
    }

    @Override
    @Transactional
    public void modifyStore(StoreVO vo, String userId) {
        // 소유권 확인
        StoreVO check = storeMapper.getStoreDetail(vo.getStore_id());
        if (check != null && check.getUser_id().equals(userId)) {
            vo.setUser_id(userId);
            storeMapper.updateStore(vo);
        }
    }

    @Override
    public StoreVO getMyStore(int storeId, String userId) {
        StoreVO store = storeMapper.getStoreDetail(storeId);
        // 내 가게가 아니면 null 반환 (컨트롤러에서 예외 처리)
        if (store != null && store.getUser_id().equals(userId)) {
            return store;
        }
        return null;
    }

    @Override
    @Transactional
    public void addMenu(MenuVO vo, String userId) {
        StoreVO store = storeMapper.getStoreDetail(vo.getStore_id());
        if (store != null && store.getUser_id().equals(userId)) {
            if (vo.getMenu_sign() == null) vo.setMenu_sign("N");
            storeMapper.insertMenu(vo);
        }
    }

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
}