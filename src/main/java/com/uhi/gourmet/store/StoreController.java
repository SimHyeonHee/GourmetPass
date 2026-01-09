package com.uhi.gourmet.store;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.io.File;
import java.io.IOException;
import java.security.Principal;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/store")
public class StoreController {

    @Autowired
    private StoreService storeService; // [수정] Mapper 대신 Service 주입

    @Value("${kakao.js.key}")
    private String kakaoJsKey;

    // ================= [맛집 조회 (Public)] =================

    // 1. 맛집 목록 조회
    @GetMapping("/list")
    public String storeList(
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "region", required = false) String region,
            @RequestParam(value = "keyword", required = false) String keyword, // 추가
            Model model) {
        
        // 서비스 호출 시 keyword 포함
        List<StoreVO> storeList = storeService.getStoreList(category, region, keyword);
        
        model.addAttribute("storeList", storeList); 
        model.addAttribute("category", category);
        model.addAttribute("region", region);
        model.addAttribute("keyword", keyword); // 검색창에 입력값 유지를 위해 추가
        
        return "store/store_list";
    }

    // 2. 맛집 상세 정보 조회
    @GetMapping("/detail")
    public String storeDetail(@RequestParam("storeId") int storeId, Model model) {
        // 조회수 증가 및 상세 데이터 로드 (Service에서 처리)
        storeService.plusViewCount(storeId);
        
        StoreVO store = storeService.getStoreDetail(storeId);
        List<MenuVO> menuList = storeService.getMenuList(storeId);
        
        model.addAttribute("store", store);
        model.addAttribute("menuList", menuList);
        model.addAttribute("kakaoJsKey", kakaoJsKey);
        
        return "store/store_detail";
    }
    
    // 3. [AJAX] 예약 타임슬롯 생성
    @GetMapping(value = "/api/timeSlots", produces = "application/json; charset=UTF-8")
    @ResponseBody 
    public List<String> getTimeSlots(@RequestParam("store_id") int storeId) {
        List<String> slots = new ArrayList<>();
        try {
            StoreVO store = storeService.getStoreDetail(storeId);
            if (store == null || store.getOpen_time() == null || store.getClose_time() == null) {
                return slots;
            }

            LocalTime open = LocalTime.parse(store.getOpen_time());
            LocalTime close = LocalTime.parse(store.getClose_time());
            int unit = store.getRes_unit() == 0 ? 30 : store.getRes_unit();

            LocalTime current = open;
            while (current.isBefore(close)) {
                slots.add(current.toString());
                current = current.plusMinutes(unit);
            }
        } catch (Exception e) {
            System.err.println("타임슬롯 생성 에러: " + e.getMessage());
        }
        return slots; 
    }
    
    // ================= [가게 정보 관리 (Owner Only)] =================

    // 0. 내 가게 등록 페이지 이동
    @GetMapping("/register")
    public String registerStorePage() {
        return "store/store_register";
    }

    // 0. 내 가게 등록 처리
    @PostMapping("/register")
    public String registerStoreProcess(@ModelAttribute StoreVO vo, 
                                     @RequestParam(value="file", required=false) MultipartFile file,
                                     HttpServletRequest request,
                                     Principal principal) {
        if (file != null && !file.isEmpty()) {
            vo.setStore_img(uploadFile(file, request));
        }
        
        // 서비스에서 user_id 세팅 및 insert 수행
        storeService.registerStore(vo, principal.getName());
        return "redirect:/member/mypage";
    }

    // 1. 가게 수정 페이지 이동
    @GetMapping("/update")
    public String updateStorePage(@RequestParam("store_id") int storeId, Model model, Principal principal) {
        // 서비스에서 소유권 검증 후 데이터 반환
        StoreVO store = storeService.getMyStore(storeId, principal.getName());
        
        if (store == null) {
            return "redirect:/member/mypage"; // 혹은 에러 페이지
        }
        
        model.addAttribute("store", store);
        return "store/store_update";
    }

    // 2. 가게 수정 처리
    @PostMapping("/update")
    public String updateStoreProcess(@ModelAttribute StoreVO vo, 
                                     @RequestParam(value="file", required=false) MultipartFile file, 
                                     HttpServletRequest request,
                                     Principal principal) {
        if (file != null && !file.isEmpty()) {
            vo.setStore_img(uploadFile(file, request));
        }
        
        // 서비스에서 소유권 재검증 후 업데이트 수행
        storeService.modifyStore(vo, principal.getName());
        return "redirect:/member/mypage";
    }

    // ================= [메뉴 관리 (CRUD)] =================

    // 1. 메뉴 등록 페이지 이동
    @GetMapping("/menu/register")
    public String menuRegisterPage(@RequestParam("store_id") int storeId, Model model, Principal principal) {
        // 내 가게가 맞는지 확인 (가게 정보 조회 로직 활용)
        StoreVO store = storeService.getMyStore(storeId, principal.getName());
        if (store == null) {
            return "redirect:/member/mypage";
        }
        
        model.addAttribute("store_id", storeId);
        return "store/menu_register";
    }

    // 2. 메뉴 등록 처리
    @PostMapping("/menu/register")
    public String menuRegisterProcess(@ModelAttribute("menuVO") MenuVO menuVO, 
                                      @RequestParam(value="file", required=false) MultipartFile file,
                                      HttpServletRequest request,
                                      Principal principal) {
        
        if (file != null && !file.isEmpty()) {
            menuVO.setMenu_img(uploadFile(file, request));
        }
        
        // 서비스에서 소유권 확인 후 등록
        storeService.addMenu(menuVO, principal.getName());
        return "redirect:/member/mypage"; 
    }

    // 3. 메뉴 삭제 처리
    @GetMapping("/menu/delete")
    public String deleteMenu(@RequestParam("menu_id") int menuId, Principal principal) {
        // 서비스에서 메뉴-가게 소유권 연쇄 확인 후 삭제
        storeService.removeMenu(menuId, principal.getName());
        return "redirect:/member/mypage";
    }
    
    // 4. 메뉴 수정 페이지 이동
    @GetMapping("/menu/update")
    public String menuUpdatePage(@RequestParam("menu_id") int menuId, Model model, Principal principal) {
        // 서비스에서 소유권 검증 후 메뉴 단건 정보 반환
        MenuVO menu = storeService.getMenuDetail(menuId, principal.getName());
        
        if (menu == null) {
            return "redirect:/member/mypage";
        }
        
        model.addAttribute("menu", menu);
        return "store/menu_update";
    }
    
    // 5. 메뉴 수정 처리
    @PostMapping("/menu/update")
    public String menuUpdateProcess(@ModelAttribute("vo") MenuVO vo, 
                                    @RequestParam(value="file", required=false) MultipartFile file,
                                    HttpServletRequest request,
                                    Principal principal) {
        if (file != null && !file.isEmpty()) {
            vo.setMenu_img(uploadFile(file, request));
        }
        
        // 서비스에서 소유권 확인 후 수정
        storeService.modifyMenu(vo, principal.getName());
        return "redirect:/member/mypage";
    }

    // [공통] 파일 업로드 로직
    private String uploadFile(MultipartFile file, HttpServletRequest request) {
        String uploadPath = request.getSession().getServletContext().getRealPath("/resources/upload");
        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        String originalName = file.getOriginalFilename();
        String savedName = System.currentTimeMillis() + "_" + originalName;

        try {
            file.transferTo(new File(uploadPath, savedName));
        } catch (IOException e) {
            e.printStackTrace();
        }
        return savedName;
    }
}