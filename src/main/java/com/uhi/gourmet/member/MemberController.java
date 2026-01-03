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

/*
 * @Controller: 이 클래스가 웹 요청(URL)을 받아 처리하는 '컨트롤러'임을 스프링에게 알립니다.
 * @RequestMapping("/member"): 이 클래스 안의 모든 기능은 주소 앞에 '/member'가 자동으로 붙습니다.
 *   예) loginPage() 메서드는 '/login'이지만, 실제 호출은 '/member/login'으로 해야 합니다.
 */
@Controller
@RequestMapping("/member") 
public class MemberController {

    /*
     * @Autowired: 스프링이 미리 만들어둔 객체(Bean)를 자동으로 가져와서 연결해줍니다.
     * (new MemberMapper()를 할 필요가 없습니다.)
     */
    @Autowired
    private MemberMapper memberMapper; // DB 회원 테이블 작업용

    @Autowired
    private StoreMapper storeMapper;   // DB 가게 테이블 작업용

    /*
     * [Spring Security 핵심 1] 비밀번호 암호화 도구
     * - 사용자가 입력한 비밀번호(예: "1234")를 그대로 DB에 저장하면 보안 사고 시 다 털립니다.
     * - 이 도구는 "1234"를 "$2a$10$..." 같은 알 수 없는 문자로 변환(암호화)해줍니다.
     * - security-context.xml에 설정된 빈(Bean)을 주입받습니다.
     */
    @Autowired
    private BCryptPasswordEncoder pwEncoder;

    /*
     * @Value: 설정 파일(api.properties)에 적어둔 값을 가져옵니다.
     * - 소스 코드에 비밀 키를 직접 적으면 해킹 위험이 있어, 별도 파일로 분리한 것입니다.
     */
    @Value("${kakao.js.key}")
    private String kakaoJsKey;

    /**
     * [0] 공통 기능: JSP 화면에 카카오 지도 API 키 전달하기
     * - 회원가입 화면 등에서 지도를 띄울 때 이 키가 필요합니다.
     * - Model 객체에 담으면 JSP에서 ${kakaoJsKey}로 꺼내 쓸 수 있습니다.
     */
    private void addKakaoKeyToModel(Model model) {
        model.addAttribute("kakaoJsKey", kakaoJsKey);
    }

    // ================= [로그인 & 로그아웃] =================
    
    /*
     * [1] 로그인 페이지 이동
     * - URL: /member/login (GET 방식)
     * - 역할: 단순히 로그인 입력 화면(JSP)만 보여줍니다.
     * 
     * [Q. 로그인 검사(ID/PW 확인) 코드는 어디 있나요?]
     * -> 컨트롤러에 없습니다! Spring Security가 '낚아채서' 자동으로 처리합니다.
     * -> 사용자가 폼에 ID/PW를 적고 제출(submit)하면, 
     *    security-context.xml에 설정된 <form-login> 설정에 따라
     *    Security가 자동으로 DB 조회 및 암호 비교를 수행합니다.
     */
    @GetMapping("/login") 
    public String loginPage() {
        return "member/login"; // /WEB-INF/views/member/login.jsp 로 이동
    }
    
    // [참고] 로그아웃 메서드도 만들 필요가 없습니다. 
    // /member/logout URL을 호출하면 Security가 알아서 세션을 지우고 로그아웃 시킵니다.
    
    // ================= [회원가입 공통/일반] =================

    // [2] 회원가입 유형 선택 페이지 (일반회원 vs 점주회원 고르는 화면)
    @GetMapping("/signup/select") 
    public String joinSelect() {
        return "member/signup_select";
    }

    // [3] 일반 회원가입 페이지 이동
    @GetMapping("/signup/general") 
    public String joinGeneralPage(Model model) {
        addKakaoKeyToModel(model); // 지도 사용을 위해 API 키 전달
        return "member/signup_general";
    }

    /*
     * [4] 일반 회원가입 처리 (실제 DB 저장)
     * - URL: /member/joinProcess (POST 방식) - (메서드에 매핑 어노테이션이 빠져있어서 아래처럼 수정 필요)
     * - 사용자가 입력한 정보가 MemberVO 객체에 자동으로 담겨서 들어옵니다.
     */
    @PostMapping("/joinProcess") // (@PostMapping 추가함)
    public String joinProcess(MemberVO vo) {
        // 1. 비밀번호 암호화 (필수!)
        // 사용자가 입력한 "1234" -> 암호화된 "$2a$..."로 변경
        String encodePw = pwEncoder.encode(vo.getUser_pw()); 
        vo.setUser_pw(encodePw); // 암호화된 비번을 VO에 다시 넣음
        
        // 2. 권한 부여 (Spring Security 필수!)
        // Security는 로그인한 사람이 'ROLE_USER'인지 'ROLE_ADMIN'인지 권한(Role)을 보고 출입을 통제합니다.
        // 이게 없으면 로그인은 되는데 "페이지 접근 권한이 없습니다(403)" 에러가 뜹니다.
        vo.setUser_role("ROLE_USER"); 
        
        // 3. DB에 저장
        memberMapper.join(vo);
        
        // 4. 로그인 페이지로 이동 (회원가입 완료 후)
        return "redirect:/member/login"; 
    }

    // ================= [점주 회원가입: 멀티 페이지 방식 (1단계 -> 2단계)] =================
    // 점주 가입은 정보가 많아서(개인정보 + 가게정보) 페이지를 나눴습니다.

    // [5] 점주 가입 1단계: 개인 정보 입력 화면 보여주기
    @GetMapping("/signup/owner1") 
    public String ownerStep1(Model model) {
        addKakaoKeyToModel(model);
        return "member/signup_owner1";
    }

    /*
     * [6] 1단계 처리: 입력한 개인정보를 잠시 '세션'에 보관
     * - DB에 바로 넣지 않는 이유: 2단계(가게정보)까지 다 입력해야 완성되기 때문입니다.
     * - HttpSession: 서버에 데이터를 잠시 저장해두는 사물함 같은 공간입니다.
     */
    @PostMapping("/signup/ownerStep1")
    public String ownerStep1Process(MemberVO memberVo, HttpSession session) {
        // "tempMember"라는 이름표를 붙여서 사물함(Session)에 넣어둠
        session.setAttribute("tempMember", memberVo);
        
        // 2단계 페이지로 강제 이동
        return "redirect:/member/signup/owner2";
    }

    // [7] 점주 가입 2단계: 가게 정보 입력 화면 보여주기
    @GetMapping("/signup/owner2")
    public String ownerStep2(HttpSession session, Model model) {
        // [보안] 1단계를 거치지 않고 주소창에 바로 쳐서 들어온 경우 막아버림
        if (session.getAttribute("tempMember") == null) {
            return "redirect:/member/signup/owner1";
        }
        
        addKakaoKeyToModel(model);
        return "member/signup_owner2";
    }

    /*
     * [8] 최종 가입 처리: (1단계 정보 + 2단계 정보) 모두 DB 저장
     */
    @PostMapping("/signup/ownerFinal")
    public String ownerFinalProcess(StoreVO storeVo, HttpSession session) {
        // 1. 사물함(Session)에 넣어뒀던 개인정보(1단계)를 꺼냄
        MemberVO memberVo = (MemberVO) session.getAttribute("tempMember");
        
        // 세션 만료 등으로 정보가 없으면 처음으로 돌려보냄
        if (memberVo == null) return "redirect:/member/signup/owner1";

        // --- [A] 회원 정보(Member) 저장 ---
        String encodePw = pwEncoder.encode(memberVo.getUser_pw()); // 비번 암호화
        memberVo.setUser_pw(encodePw);
        
        // [중요] 점주는 'ROLE_OWNER' 권한을 줍니다.
        // 나중에 Security 설정에서 "/owner/**" 페이지는 ROLE_OWNER만 들어갈 수 있게 막을 수 있습니다.
        memberVo.setUser_role("ROLE_OWNER"); 
        
        memberMapper.join(memberVo); // 회원 테이블 insert

        // --- [B] 가게 정보(Store) 저장 ---
        // 방금 가입한 회원의 ID(PK)를 가게 정보에도 넣어줘야 연결이 됩니다.
        storeVo.setUser_id(memberVo.getUser_id());
        storeMapper.insertStore(storeVo); // 가게 테이블 insert

        // --- [C] 뒷정리 ---
        // 가입 끝났으니 임시 저장했던 정보 삭제 (메모리 절약)
        session.removeAttribute("tempMember");
        
        return "redirect:/member/login";
    }

    // ================= [AJAX 공통 기능] =================

    /*
     * [9] 아이디 중복 확인 (AJAX 요청)
     * - @ResponseBody: 화면(JSP)을 이동하는 게 아니라, 데이터(글자)만 그대로 응답하겠다는 뜻입니다.
     * - 결과값이 "fail"이면 JS에서 "이미 사용 중입니다"라고 띄우고, "success"면 통과시킵니다.
     */
    @PostMapping("/idCheck")
    @ResponseBody
    public String idCheck(@RequestParam("user_id") String user_id) {
        int count = memberMapper.idCheck(user_id);
        
        // count가 1 이상이면 이미 있다는 뜻 -> 실패(fail)
        return (count > 0) ? "fail" : "success";
    }
}
