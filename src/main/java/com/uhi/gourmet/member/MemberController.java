package com.uhi.gourmet.member;

import java.security.Principal;
import java.util.List; // 추가

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.uhi.gourmet.store.StoreMapper;
import com.uhi.gourmet.store.StoreVO;

@Controller
@RequestMapping("/member") 
public class MemberController {

    @Autowired
    private MemberMapper memberMapper;

    @Autowired
    private StoreMapper storeMapper;

    @Autowired
    private BCryptPasswordEncoder pwEncoder;

    @Value("${kakao.js.key}")
    private String kakaoJsKey;

    private void addKakaoKeyToModel(Model model) {
        model.addAttribute("kakaoJsKey", kakaoJsKey);
    }

    // ================= [로그인 & 로그아웃] =================
    
    @GetMapping("/login") 
    public String loginPage() {
        return "member/login";
    }
    
    // ================= [회원가입] =================

    @GetMapping("/signup/select") 
    public String joinSelect() {
        return "member/signup_select";
    }

    @GetMapping("/signup/general") 
    public String joinGeneralPage(Model model) {
        addKakaoKeyToModel(model);
        return "member/signup_general";
    }

    @PostMapping("/joinProcess")
    public String joinProcess(MemberVO vo) {
        vo.setUser_pw(pwEncoder.encode(vo.getUser_pw()));
        vo.setUser_role("ROLE_USER"); 
        memberMapper.join(vo);
        return "redirect:/member/login"; 
    }

    @GetMapping("/signup/owner1") 
    public String ownerStep1(Model model) {
        addKakaoKeyToModel(model);
        return "member/signup_owner1";
    }

    @PostMapping("/signup/ownerStep1")
    public String ownerStep1Process(MemberVO memberVo, HttpSession session) {
        session.setAttribute("tempMember", memberVo);
        return "redirect:/member/signup/owner2";
    }

    @GetMapping("/signup/owner2")
    public String ownerStep2(HttpSession session, Model model) {
        if (session.getAttribute("tempMember") == null) {
            return "redirect:/member/signup/owner1";
        }
        addKakaoKeyToModel(model);
        return "member/signup_owner2";
    }

    @Transactional
    @PostMapping("/signup/ownerFinal")
    public String ownerFinalProcess(StoreVO storeVo, HttpSession session) {
        MemberVO memberVo = (MemberVO) session.getAttribute("tempMember");
        if (memberVo == null) return "redirect:/member/signup/owner1";

        memberVo.setUser_pw(pwEncoder.encode(memberVo.getUser_pw()));
        memberVo.setUser_role("ROLE_OWNER"); 
        
        memberMapper.join(memberVo);
        storeVo.setUser_id(memberVo.getUser_id());
        storeMapper.insertStore(storeVo);

        session.removeAttribute("tempMember");
        return "redirect:/member/login";
    }

    // ================= [마이페이지 & 수정 & 탈퇴] =================

    @GetMapping("/mypage")
    public String mypage(Principal principal, Model model, HttpServletRequest request) {
        String userId = principal.getName();
        
        // 1. 회원 기본 정보 로드
        MemberVO member = memberMapper.getMemberById(userId);
        model.addAttribute("member", member);

        // 2. 점주 권한인 경우 (1:1 구조 반영)
        if (request.isUserInRole("ROLE_OWNER")) {
            // 단건 조회로 변경
            StoreVO store = storeMapper.getStoreByUserId(userId);
            model.addAttribute("store", store); // 변수명을 'store'로 복구
            
            if (store != null) {
                model.addAttribute("menuList", storeMapper.getMenuList(store.getStore_id()));
            }
            
            return "member/mypage_owner";
        }
        
        return "member/mypage";
    }

    @GetMapping("/edit")
    public String editPage(Principal principal, Model model) {
        String userId = principal.getName();
        MemberVO member = memberMapper.getMemberById(userId);
        model.addAttribute("member", member);
        addKakaoKeyToModel(model);
        return "member/member_edit"; 
    }
    
    @PostMapping("/edit")
    public String updateProcess(MemberVO vo, RedirectAttributes rttr) {
        memberMapper.updateMember(vo);
        rttr.addFlashAttribute("msg", "회원 정보가 수정되었습니다.");
        return "redirect:/member/mypage";
    }

    @PostMapping("/delete")
    public String deleteMember(@RequestParam("user_id") String user_id, HttpSession session, RedirectAttributes rttr) {
        memberMapper.deleteMember(user_id);
        SecurityContextHolder.clearContext();
        if (session != null) {
            session.invalidate();
        }
        rttr.addFlashAttribute("msg", "정상적으로 탈퇴되었습니다.");
        return "redirect:/";
    }

    // ================= [AJAX] =================

    @PostMapping("/idCheck")
    @ResponseBody
    public String idCheck(@RequestParam("user_id") String user_id) {
        int count = memberMapper.idCheck(user_id);
        return (count > 0) ? "fail" : "success";
    }
}