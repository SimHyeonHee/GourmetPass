package com.uhi.gourmet.member;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.uhi.gourmet.store.StoreMapper;
import com.uhi.gourmet.store.StoreVO;

@Controller
@RequestMapping("/member") // 기본 경로를 /member 로 잡아서 체계화
public class MemberController {

    @Autowired
    private MemberMapper memberMapper;

    @Autowired
    private StoreMapper storeMapper;

    @Autowired
    private BCryptPasswordEncoder pwEncoder;

    // api.properties에서 카카오 API 키 주입
    @Value("${kakao.js.key}")
    private String kakaoJsKey;

    /**
     * [0] 공통: 카카오 키 주입 헬퍼
     */
    private void addKakaoKeyToModel(Model model) {
        model.addAttribute("kakaoJsKey", kakaoJsKey);
    }

    // ================= [로그인 & 로그아웃] =================
    // Spring Security가 가로채서 처리하므로, 여기서는 페이지만 보여주면 됨.
    
    // [1] 로그인 페이지 이동
    @GetMapping("/login") // 호출경로: /member/login
    public String loginPage() {
        return "member/login";
    }
    
    // [주의] 로그인 처리(POST)와 로그아웃 처리는 컨트롤러에 만들지 않습니다.
    // security-context.xml 설정에 따라 스프링 시큐리티 필터가 자동으로 처리합니다.
    
    // ================= [회원가입 공통/일반] =================

    // [2] 회원가입 유형 선택 페이지
    @GetMapping("/signup/select") // 호출경로: /member/signup/select
    public String joinSelect() {
        return "member/signup_select";
    }

    // [3] 일반 회원가입 페이지 이동
    @GetMapping("/signup/general") // 호출경로: /member/signup/general
    public String joinGeneralPage(Model model) {
        addKakaoKeyToModel(model); 
        return "member/signup_general";
    }

    // [4] 일반 회원가입 처리 (DB 저장)
    public String joinProcess(MemberVO vo) {
        String encodePw = pwEncoder.encode(vo.getUser_pw()); 
        vo.setUser_pw(encodePw);
        
        // [보완] 일반 회원가입 시에도 권한을 명시적으로 넣어줘야 합니다.
        // 이 코드가 없으면 나중에 로그인해도 ROLE_USER 권한이 없어서 마이페이지 접근이 안 됩니다.
        vo.setUser_role("ROLE_USER"); 
        
        memberMapper.join(vo);
        return "redirect:/member/login"; 
    }

    // ================= [점주 회원가입: 멀티 페이지 방식] =================

    // [5] 점주 가입 1단계: 개인 정보 입력
    @GetMapping("/signup/owner1") // 호출경로: /member/signup/owner1
    public String ownerStep1(Model model) {
        addKakaoKeyToModel(model);
        return "member/signup_owner1";
    }

    // [6] 1단계 처리 -> 세션 저장 -> 2단계 이동
    @PostMapping("/signup/ownerStep1")
    public String ownerStep1Process(MemberVO memberVo, HttpSession session) {
        session.setAttribute("tempMember", memberVo);
        return "redirect:/member/signup/owner2";
    }

    // [7] 점주 가입 2단계: 가게 정보 입력
    @GetMapping("/signup/owner2")
    public String ownerStep2(HttpSession session, Model model) {
        if (session.getAttribute("tempMember") == null) {
            return "redirect:/member/signup/owner1";
        }
        addKakaoKeyToModel(model);
        return "member/signup_owner2";
    }

    // [8] 최종 가입 처리 (회원정보 + 가게정보)
    @PostMapping("/signup/ownerFinal")
    public String ownerFinalProcess(StoreVO storeVo, HttpSession session) {
        MemberVO memberVo = (MemberVO) session.getAttribute("tempMember");
        if (memberVo == null) return "redirect:/member/signup/owner1";

        // 1. 회원 정보 저장 (암호화 + 권한 설정)
        String encodePw = pwEncoder.encode(memberVo.getUser_pw());
        memberVo.setUser_pw(encodePw);
        memberVo.setUser_role("ROLE_OWNER"); // 점주 권한 부여
        memberMapper.join(memberVo);

        // 2. 가게 정보 저장
        storeVo.setUser_id(memberVo.getUser_id());
        storeMapper.insertStore(storeVo); // StoreMapper 필요

        // 3. 임시 세션 제거
        session.removeAttribute("tempMember");
        
        return "redirect:/member/login";
    }

    // ================= [AJAX 공통 기능] =================

    // [9] 아이디 중복 확인
    @PostMapping("/idCheck")
    @ResponseBody
    public String idCheck(@RequestParam("user_id") String user_id) {
        int count = memberMapper.idCheck(user_id);
        return (count > 0) ? "fail" : "success";
    }
}