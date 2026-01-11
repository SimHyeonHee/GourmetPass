package com.uhi.gourmet.review;

import java.security.Principal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.uhi.gourmet.store.StoreService; // [추가] 가게 정보 조회를 위해
import com.uhi.gourmet.store.StoreVO;

@Controller
@RequestMapping("/review")
public class ReviewController {

    @Autowired
    private ReviewService review_service;

    @Autowired
    private StoreService store_service; // [추가]

    /**
     * 1. 리뷰 작성 페이지 이동 (GET)
     * - 어떤 방문 건에 대한 리뷰인지 ID를 받아 페이지를 구성합니다.
     */
    @GetMapping("/write")
    public String writePage(@RequestParam("store_id") int storeId,
                            @RequestParam(value="book_id", required=false) Integer bookId,
                            @RequestParam(value="wait_id", required=false) Integer waitId,
                            Principal principal, Model model) {
        
        if (principal == null) return "redirect:/member/login";

        // 방문 여부 최종 검증
        boolean canWrite = review_service.checkReviewEligibility(principal.getName(), storeId);
        if (!canWrite) return "redirect:/wait/myStatus";

        // 화면에 보여줄 가게 정보 가져오기
        StoreVO store = store_service.getStoreDetail(storeId);
        
        model.addAttribute("store", store);
        model.addAttribute("book_id", bookId);
        model.addAttribute("wait_id", waitId);
        
        return "review/review_write";
    }

    /**
     * 2. 리뷰 등록 프로세스 (POST)
     * - [수정] 사진(File) 업로드 로직 완전 제거
     * - [수정] 방문 완료 여부 서버 측 재검증
     */
    @PostMapping("/write")
    public String writeProcess(ReviewVO vo, Principal principal, RedirectAttributes rttr) {
        
        if (principal == null) return "redirect:/member/login";
        
        String userId = principal.getName();
        vo.setUser_id(userId);

        // 서버 측 최종 권한 검증
        boolean canWrite = review_service.checkReviewEligibility(userId, vo.getStore_id());
        if (!canWrite) {
            rttr.addFlashAttribute("msg", "방문 완료 후에만 리뷰를 작성할 수 있습니다.");
            return "redirect:/wait/myStatus";
        }

        // DB 등록 (사진 정보 없음)
        review_service.addReview(vo);
        rttr.addFlashAttribute("msg", "소중한 리뷰가 등록되었습니다.");
        
        // 작성 완료 후 해당 가게 상세페이지로 이동하여 내가 쓴 글 확인
        return "redirect:/store/detail?storeId=" + vo.getStore_id();
    }

    /**
     * 3. 리뷰 삭제 프로세스
     */
    @PostMapping("/delete")
    public String deleteProcess(@RequestParam("review_id") int review_id, 
                                @RequestParam("store_id") int store_id,
                                RedirectAttributes rttr) {
        
        review_service.removeReview(review_id);
        rttr.addFlashAttribute("msg", "리뷰가 삭제되었습니다.");
        
        return "redirect:/store/detail?storeId=" + store_id;
    }
}