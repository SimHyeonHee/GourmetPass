package com.uhi.gourmet.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.uhi.gourmet.member.MemberMapper;
import com.uhi.gourmet.member.MemberVO;

import java.util.Collections;

@Service("customUserDetailsService")
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private MemberMapper memberMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // [수정] MemberMapper에 정의된 "아이디로 회원정보 가져오는 메서드" 이름을 확인하세요.
        // 보통 login 보다는 selectMember 또는 getMember 등의 이름을 사용합니다.
        // 만약 Mapper에 해당 기능이 없다면 MemberMapper.java에 MemberVO selectMember(String user_id); 를 추가해야 합니다.
        MemberVO vo = memberMapper.selectMember(username); 

        if (vo == null) {
            throw new UsernameNotFoundException("해당 아이디를 찾을 수 없습니다: " + username);
        }

        return new User(
            vo.getUser_id(),
            vo.getUser_pw(),
            Collections.singletonList(new SimpleGrantedAuthority(vo.getUser_role()))
        );
    }
}
