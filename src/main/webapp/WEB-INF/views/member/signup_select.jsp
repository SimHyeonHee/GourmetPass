<%-- 
    [1] 페이지 설정 지시어 (Directive)
    - language="java": 이 페이지는 자바 언어를 기반으로 한다고 선언.
    - contentType: 브라우저에게 "이건 HTML 문서고, 글자는 UTF-8 방식(한글 지원)이야"라고 알려줌.
    - pageEncoding: 이 파일 자체를 저장할 때 쓰는 인코딩 방식.
    
    이 줄이 없으면 브라우저에서 한글이 '믜휄' 처럼 깨져 보일 수 있습니다.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html> <!-- HTML5 표준 문서임을 선언 (최신 웹 표준) -->
<html>
<head>
<meta charset="UTF-8"> <!-- 한글 깨짐 방지 2차 안전장치 -->
<title>회원가입 유형 선택</title> <!-- 브라우저 탭에 표시될 제목 -->

<%-- 
    [2] 스타일(CSS): 화면을 예쁘게 꾸미는 화장품 역할
    - 보통은 .css 파일로 따로 빼지만, 간단한 페이지라 여기에 직접 적었습니다.
--%>
<style>
    /* .container: 전체 내용을 감싸는 큰 박스 */
    .container { 
        text-align: center; /* 글자랑 박스들을 가운데 정렬 */
        margin-top: 100px;  /* 천장에서 100px만큼 떨어뜨림 (너무 위에 붙으면 답답하니까) */
    }

    /* .select-box: '일반회원', '점주회원' 네모 박스 모양 */
    .select-box { 
        display: inline-block; /* 박스 두 개를 옆으로 나란히 배치함 (이거 없으면 위아래로 쌓임) */
        width: 250px; height: 300px; /* 박스 크기 지정 */
        border: 1px solid #ddd; /* 테두리: 1픽셀 굵기, 옅은 회색(#ddd) */
        margin: 20px; /* 박스끼리 서로 20px 떨어뜨림 */
        border-radius: 10px; /* 모서리를 둥글게 깎음 (아이폰 앱 아이콘처럼) */
        padding: 30px; /* 박스 안쪽 내용물과 테두리 사이의 여백 */
        vertical-align: middle; /* 옆 박스랑 높이 중심 맞추기 */
        cursor: pointer; /* 마우스를 올리면 손가락 모양(👆)으로 변하게 함 */
        transition: 0.3s; /* 애니메이션 속도: 변화가 생길 때 0.3초 동안 부드럽게 바뀜 */
    }

    /* .select-box:hover: 마우스를 '올렸을 때'의 스타일 */
    .select-box:hover { 
        background-color: #f9f9f9; /* 배경색이 아주 연한 회색으로 변함 */
        border-color: #ff3d00;     /* 테두리가 주황색(#ff3d00)으로 변함 (강조 효과!) */
    }

    /* .icon: 이모지(😊, 👨‍🍳) 스타일 */
    .icon { 
        font-size: 50px; /* 글자 크기 50픽셀 (크게) */
        margin-bottom: 20px; /* 아래 글자랑 간격 벌림 */
    }

    /* .title: '일반 회원' 같은 제목 스타일 */
    .title { 
        font-size: 20px; 
        font-weight: bold; /* 글자 굵게(Bold) */
        margin-bottom: 10px; 
    }

    /* .desc: 설명글 스타일 */
    .desc { 
        font-size: 14px; /* 글자 작게 */
        color: #666; /* 글자색 진한 회색 (검정보다 부드러워 보임) */
    }

    /* a 태그(링크) 스타일: 밑줄 없애고 검정색으로 */
    a { 
        text-decoration: none; /* 파란 밑줄 제거 */
        color: black; /* 클릭해도 보라색으로 안 변하게 검정 고정 */
    }
</style>
</head>
<body>

<%-- [3] 본문 내용 시작 --%>
<div class="container">
    <h2>회원가입 유형을 선택해주세요</h2>
    <p>어떤 목적으로 Gourmet Pass를 이용하시나요?</p>
    
    <%-- 
        [핵심 1] 일반 회원가입 경로 이동
        - <a> 태그는 클릭하면 다른 페이지로 이동하는 하이퍼링크입니다.
        
        - href 속성의 의미:
          ${pageContext.request.contextPath} : 우리 프로젝트의 '뿌리 경로' (예: /gourmet)
          /member/signup/general : 컨트롤러(@Controller)에 만들어둔 일반 가입 메서드 주소
          
          결국 합치면: "http://localhost:8080/gourmet/member/signup/general" 로 이동합니다.
    --%>
    <a href="${pageContext.request.contextPath}/member/signup/general">
        <!-- 이 div 박스 전체가 클릭 가능한 버튼이 됩니다 -->
        <div class="select-box">
            <div class="icon">😊</div> <!-- 이모지 아이콘 -->
            <div class="title">일반 회원</div>
            <div class="desc">
                맛집을 예약하고<br>웨이팅을 신청하고 싶어요. <!-- <br>은 줄바꿈 태그 -->
            </div>
        </div>
    </a>

    <%-- 
        [핵심 2] 점주 회원가입 경로 이동
        - 위와 똑같은 원리지만, 도착지 주소만 다릅니다.
        - 도착지: /member/signup/owner1 (점주 가입 1단계 페이지)
    --%>
    <a href="${pageContext.request.contextPath}/member/signup/owner1">
        <div class="select-box">
            <div class="icon">👨‍🍳</div>
            <div class="title">점주 회원</div>
            <div class="desc">
                우리 가게를 등록하고<br>손님을 받고 싶어요.
            </div>
        </div>
    </a>
</div>

</body>
</html>
