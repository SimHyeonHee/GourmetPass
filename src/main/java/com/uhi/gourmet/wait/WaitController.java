package com.uhi.gourmet.wait;

import java.security.Principal;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.uhi.gourmet.book.BookService;
import com.uhi.gourmet.book.BookVO;

@Controller
@RequestMapping("/wait")
public class WaitController {

    @Autowired
    private WaitService wait_service;

    @Autowired
    private BookService book_service; // [추가] 예약 내역 조회를 위해 주입

    @Autowired
    private SimpMessagingTemplate messaging_template;

    /**
     * 일반 회원: 내 이용현황 페이지 조회
     * - 현재 진행 중인 예약/웨이팅 '만' 상단에 노출
     * - 하단에 전체 내역으로 가는 버튼 제공
     */
    @GetMapping("/myStatus")
    public String my_status(Principal principal, Model model) {
        if (principal == null) {
            return "redirect:/member/login";
        }
        
        String user_id = principal.getName();
        
        // 1. 모든 내역 가져오기
        List<WaitVO> my_wait_list = wait_service.get_my_wait_list(user_id);
        List<BookVO> my_book_list = book_service.get_my_book_list(user_id);
        
        // 2. 진행 중인 내역 필터링 (웨이팅: WAITING, CALLED / 예약: RESERVED)
        // 가장 최근의 진행 중인 건 1건만 별도로 전달
        WaitVO activeWait = my_wait_list.stream()
                .filter(w -> "WAITING".equals(w.getWait_status()) || "CALLED".equals(w.getWait_status()))
                .findFirst().orElse(null);
        
        BookVO activeBook = my_book_list.stream()
                .filter(b -> "RESERVED".equals(b.getBook_status()))
                .findFirst().orElse(null);

        // 3. 리뷰 작성이 가능한 최근 완료 내역 (FINISH) 추출
        List<WaitVO> finishedWaits = my_wait_list.stream()
                .filter(w -> "FINISH".equals(w.getWait_status()))
                .collect(Collectors.toList());
        
        List<BookVO> finishedBooks = my_book_list.stream()
                .filter(b -> "FINISH".equals(b.getBook_status()))
                .collect(Collectors.toList());

        // 모델에 데이터 담기
        model.addAttribute("activeWait", activeWait);
        model.addAttribute("activeBook", activeBook);
        model.addAttribute("finishedWaits", finishedWaits);
        model.addAttribute("finishedBooks", finishedBooks);
        
        // 전체 내역 보기를 위한 원본 리스트도 유지
        model.addAttribute("my_wait_list", my_wait_list);
        model.addAttribute("my_book_list", my_book_list);
        
        return "wait/myStatus";
    }

    @PostMapping("/register")
    public String register_wait(WaitVO vo, Principal principal) {
        if (principal == null) {
            return "redirect:/member/login";
        }
        vo.setUser_id(principal.getName());
        wait_service.register_wait(vo);
        messaging_template.convertAndSend("/topic/store/" + vo.getStore_id(), "새로운 웨이팅이 접수되었습니다! 번호: " + vo.getWait_num());
        
        // 등록 후 바로 이용현황 페이지로 이동하여 내 상태를 확인하게 함
        return "redirect:/wait/myStatus";
    }

    @PostMapping("/updateStatus")
    public String update_status(@RequestParam("wait_id") int wait_id, 
                                @RequestParam(value="user_id", required=false) String user_id,
                                @RequestParam("status") String status) {
        wait_service.update_wait_status(wait_id, status);
        if ("CALLED".equals(status) && user_id != null) {
            messaging_template.convertAndSend("/topic/wait/" + user_id, "입장하실 순서입니다! 매장으로 방문해주세요.");
        }
        return "redirect:/book/manage";
    }

    @PostMapping("/cancel")
    public String cancel_wait(@RequestParam("wait_id") int wait_id) {
        wait_service.update_wait_status(wait_id, "CANCELLED");
        return "redirect:/wait/myStatus";
    }
}