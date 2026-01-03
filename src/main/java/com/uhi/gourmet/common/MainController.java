package com.uhi.gourmet.common; // 패키지 경로 통일

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.uhi.gourmet.store.StoreMapper;
import com.uhi.gourmet.store.StoreVO;

@Controller
public class MainController {

    @Autowired
    private StoreMapper storeMapper;

    // 루트 경로(/) 접속 시 메인 페이지 호출
    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String mainPage(Model model) {
        
        // [1] 인기 맛집 조회 (Store팀이 만든 Mapper 활용)
        List<StoreVO> storeList = storeMapper.selectPopularStore();
        
        // [2] JSP로 전달
        model.addAttribute("storeList", storeList);
        
        // [3] views/main.jsp 호출
        return "main"; 
    }
}