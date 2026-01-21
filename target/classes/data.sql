---------테스트용 추가코드----------------------

-- ========================================================
-- [1] 데이터 초기화 (DELETE) 초기화  순서 중요함 안그러면 무결성 에러
-- ========================================================
DELETE FROM BOOK;
DELETE FROM PAY;
DELETE FROM REVIEW;
DELETE FROM WAIT;
DELETE FROM MENU;
DELETE FROM STORE;
DELETE FROM MEMBERS;

-- 시퀀스 초기화가 필요하다면 DROP/CREATE 하거나, 현재 값을 확인해야 합니다.
-- 테스트 편의를 위해 테이블 데이터만 삭제하고 시퀀스는 그대로 진행(NEXTVAL)하거나
-- 아래처럼 시퀀스도 초기화하고 싶다면 주석을 해제하세요.

DROP SEQUENCE SEQ_STORE; CREATE SEQUENCE SEQ_STORE START WITH 1 INCREMENT BY 1;
DROP SEQUENCE SEQ_MENU;  CREATE SEQUENCE SEQ_MENU  START WITH 1 INCREMENT BY 1;
DROP SEQUENCE SEQ_BOOK;  CREATE SEQUENCE SEQ_BOOK  START WITH 1 INCREMENT BY 1;
DROP SEQUENCE SEQ_WAIT;  CREATE SEQUENCE SEQ_WAIT  START WITH 1 INCREMENT BY 1;


COMMIT;

-- ========================================================
-- [2] 회원 데이터 생성 (총 20명)
-- 비밀번호는 모두 '1324' ($2a$10$...) 로 통일
-- ========================================================

-- 2-1. 점주 회원 (10명: owner01 ~ owner10)
-- owner01: 강남 (한식)
INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_zip, user_addr1, user_lat, user_lon)
VALUES ('owner01', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '김점주', 'owner01@example.com', '010-1001-0001', 'ROLE_OWNER', '06232', '서울 강남구 테헤란로 1', 37.497952, 127.027619);

-- owner02: 분당 (고기)
INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_zip, user_addr1, user_lat, user_lon)
VALUES ('owner02', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '이점주', 'owner02@example.com', '010-1002-0002', 'ROLE_OWNER', '13547', '경기 성남시 분당구 동원동 1', 37.352251, 127.082965);

-- owner03: 홍대 (일식)
INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_zip, user_addr1, user_lat, user_lon)
VALUES ('owner03', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '박점주', 'owner03@example.com', '010-1003-0003', 'ROLE_OWNER', '04038', '서울 마포구 양화로 160', 37.556886, 126.923761);

-- owner04: 성수 (카페)
INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_zip, user_addr1, user_lat, user_lon)
VALUES ('owner04', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '최점주', 'owner04@example.com', '010-1004-0004', 'ROLE_OWNER', '04769', '서울 성동구 아차산로 100', 37.544569, 127.056044);

-- owner05: 이태원 (양식)
INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_zip, user_addr1, user_lat, user_lon)
VALUES ('owner05', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '정점주', 'owner05@example.com', '010-1005-0005', 'ROLE_OWNER', '04390', '서울 용산구 이태원로 170', 37.534887, 126.993425);

-- owner06: 종로 (중식)
INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_zip, user_addr1, user_lat, user_lon)
VALUES ('owner06', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '강점주', 'owner06@example.com', '010-1006-0006', 'ROLE_OWNER', '03131', '서울 종로구 삼일대로 380', 37.569588, 126.985929);

-- owner07: 잠실 (분식)
INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_zip, user_addr1, user_lat, user_lon)
VALUES ('owner07', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '조점주', 'owner07@example.com', '010-1007-0007', 'ROLE_OWNER', '05551', '서울 송파구 올림픽로 300', 37.513261, 127.100130);

-- owner08: 여의도 (아시안)
INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_zip, user_addr1, user_lat, user_lon)
VALUES ('owner08', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '윤점주', 'owner08@example.com', '010-1008-0008', 'ROLE_OWNER', '07336', '서울 영등포구 국제금융로 10', 37.525542, 126.924874);

-- owner09: 판교 (한식)
INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_zip, user_addr1, user_lat, user_lon)
VALUES ('owner09', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '장점주', 'owner09@example.com', '010-1009-0009', 'ROLE_OWNER', '13529', '경기 성남시 분당구 판교역로 146', 37.394760, 127.111195);

-- owner10: 을지로 (펍/주점)
INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_zip, user_addr1, user_lat, user_lon)
VALUES ('owner10', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '임점주', 'owner10@example.com', '010-1010-0010', 'ROLE_OWNER', '04544', '서울 중구 을지로 100', 37.566085, 126.990886);

-- 2-2. 일반 회원 (10명: user01 ~ user10)
INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_lat, user_lon) 
VALUES ('user01', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '강회원', 'user01@example.com', '010-2001-0001', 'ROLE_USER', 37.498, 127.028);

INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_lat, user_lon) 
VALUES ('user02', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '나회원', 'user02@example.com', '010-2002-0002', 'ROLE_USER', 37.353, 127.083);

INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_lat, user_lon) 
VALUES ('user03', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '도회원', 'user03@example.com', '010-2003-0003', 'ROLE_USER', 37.557, 126.924);

INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_lat, user_lon) 
VALUES ('user04', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '류회원', 'user04@example.com', '010-2004-0004', 'ROLE_USER', 37.545, 127.057);

INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_lat, user_lon) 
VALUES ('user05', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '마회원', 'user05@example.com', '010-2005-0005', 'ROLE_USER', 37.535, 126.994);

INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_lat, user_lon) 
VALUES ('user06', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '바회원', 'user06@example.com', '010-2006-0006', 'ROLE_USER', 37.570, 126.986);

INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_lat, user_lon) 
VALUES ('user07', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '사회원', 'user07@example.com', '010-2007-0007', 'ROLE_USER', 37.514, 127.101);

INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_lat, user_lon) 
VALUES ('user08', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '아회원', 'user08@example.com', '010-2008-0008', 'ROLE_USER', 37.526, 126.925);

INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_lat, user_lon) 
VALUES ('user09', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '자회원', 'user09@example.com', '010-2009-0009', 'ROLE_USER', 37.395, 127.112);

INSERT INTO MEMBERS (user_id, user_pw, user_nm, user_email, user_tel, user_role, user_lat, user_lon) 
VALUES ('user10', '$2a$10$9ClY.rWiE9xjhkBV/ClGCO1yD3X.fGOcCl./CAybHi34hmIx4ZUDW', '차회원', 'user10@example.com', '010-2010-0010', 'ROLE_USER', 37.567, 126.991);


-- ========================================================
-- [3] 가게 데이터 생성 (점주 1명당 1개 = 총 10개)
-- ========================================================

-- Store 1: 강남 (한식)
INSERT INTO STORE (store_id, user_id, store_name, store_category, store_addr1, store_lat, store_lon, open_time, close_time, res_unit) 
VALUES (SEQ_STORE.NEXTVAL, 'owner01', '강남 수라상', '한식', '서울 강남구 테헤란로 1', 37.497952, 127.027619, '11:00', '21:00', 30);

-- Store 2: 분당 (일식) - user_id 수정된 좌표 반영
INSERT INTO STORE (store_id, user_id, store_name, store_category, store_addr1, store_lat, store_lon, open_time, close_time, res_unit) 
VALUES (SEQ_STORE.NEXTVAL, 'owner02', '동원동 스시', '일식', '경기 성남시 분당구 동원동 1', 37.352251, 127.082965, '11:30', '22:00', 60);

-- Store 3: 홍대 (라멘)
INSERT INTO STORE (store_id, user_id, store_name, store_category, store_addr1, store_lat, store_lon, open_time, close_time, res_unit) 
VALUES (SEQ_STORE.NEXTVAL, 'owner03', '홍대 멘야', '일식', '서울 마포구 양화로 160', 37.556886, 126.923761, '11:00', '21:00', 30);

-- Store 4: 성수 (카페)
INSERT INTO STORE (store_id, user_id, store_name, store_category, store_addr1, store_lat, store_lon, open_time, close_time, res_unit) 
VALUES (SEQ_STORE.NEXTVAL, 'owner04', '카페 성수', '카페', '서울 성동구 아차산로 100', 37.544569, 127.056044, '09:00', '23:00', 60);

-- Store 5: 이태원 (양식/파스타)
INSERT INTO STORE (store_id, user_id, store_name, store_category, store_addr1, store_lat, store_lon, open_time, close_time, res_unit) 
VALUES (SEQ_STORE.NEXTVAL, 'owner05', '이태원 비스트로', '양식', '서울 용산구 이태원로 170', 37.534887, 126.993425, '12:00', '22:00', 60);

-- Store 6: 종로 (중식)
INSERT INTO STORE (store_id, user_id, store_name, store_category, store_addr1, store_lat, store_lon, open_time, close_time, res_unit) 
VALUES (SEQ_STORE.NEXTVAL, 'owner06', '종로 만리장성', '중식', '서울 종로구 삼일대로 380', 37.569588, 126.985929, '10:30', '21:30', 30);

-- Store 7: 잠실 (분식)
INSERT INTO STORE (store_id, user_id, store_name, store_category, store_addr1, store_lat, store_lon, open_time, close_time, res_unit) 
VALUES (SEQ_STORE.NEXTVAL, 'owner07', '잠실 떡볶이', '기타', '서울 송파구 올림픽로 300', 37.513261, 127.100130, '11:00', '20:00', 30);

-- Store 8: 여의도 (아시안)
INSERT INTO STORE (store_id, user_id, store_name, store_category, store_addr1, store_lat, store_lon, open_time, close_time, res_unit) 
VALUES (SEQ_STORE.NEXTVAL, 'owner08', '여의도 쌀국수', '양식', '서울 영등포구 국제금융로 10', 37.525542, 126.924874, '10:00', '21:00', 30);

-- Store 9: 판교 (한식/고기)
INSERT INTO STORE (store_id, user_id, store_name, store_category, store_addr1, store_lat, store_lon, open_time, close_time, res_unit) 
VALUES (SEQ_STORE.NEXTVAL, 'owner09', '판교 갈비', '한식', '경기 성남시 분당구 판교역로 146', 37.394760, 127.111195, '16:00', '23:00', 60);

-- Store 10: 을지로 (술집)
INSERT INTO STORE (store_id, user_id, store_name, store_category, store_addr1, store_lat, store_lon, open_time, close_time, res_unit) 
VALUES (SEQ_STORE.NEXTVAL, 'owner10', '을지로 노가리', '기타', '서울 중구 을지로 100', 37.566085, 126.990886, '17:00', '02:00', 60);


-- ========================================================
-- [4] 메뉴 데이터 생성 (가게당 2~3개)
-- ========================================================

-- Store 1 (강남 수라상: 1, 2)
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner01'), '불고기 정식', 15000, 'food1.jpg', 'Y');
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner01'), '비빔밥', 10000, 'food2.jpg', 'N');

-- Store 2 (동원동 스시: 3, 4, 5)
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner02'), '특초밥 세트', 25000, 'sushi1.jpg', 'Y');
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner02'), '연어 덮밥', 18000, 'sushi2.jpg', 'N');
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner02'), '냉모밀', 9000, 'noodle.jpg', 'N');

-- Store 3 (홍대 멘야: 6, 7)
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner03'), '돈코츠 라멘', 11000, 'ramen1.jpg', 'Y');
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner03'), '교자 만두', 5000, 'gyoza.jpg', 'N');

-- Store 4 (카페 성수: 8, 9, 10)
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner04'), '아메리카노', 4500, 'coffee1.jpg', 'Y');
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner04'), '시그니처 라떼', 6000, 'coffee2.jpg', 'N');
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner04'), '치즈 케이크', 7000, 'cake.jpg', 'N');

-- Store 5 (이태원 비스트로: 11, 12)
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner05'), '알리오 올리오', 16000, 'pasta.jpg', 'Y');
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner05'), '채끝 스테이크', 35000, 'steak.jpg', 'Y');

-- Store 6 (종로 만리장성: 13, 14, 15)
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner06'), '짜장면', 8000, 'jjajang.jpg', 'N');
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner06'), '짬뽕', 9000, 'jjamppong.jpg', 'Y');
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner06'), '탕수육(소)', 18000, 'tangsuyuk.jpg', 'Y');

-- Store 7 (잠실 떡볶이: 16, 17)
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner07'), '국물 떡볶이', 6000, 'tteok.jpg', 'Y');
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner07'), '모듬 튀김', 5000, 'fry.jpg', 'N');

-- Store 8 (여의도 쌀국수: 18, 19)
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner08'), '양지 쌀국수', 12000, 'pho.jpg', 'Y');
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner08'), '스프링롤', 6000, 'roll.jpg', 'N');

-- Store 9 (판교 갈비: 20, 21, 22)
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner09'), '양념 돼지갈비', 18000, 'pork.jpg', 'Y');
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner09'), '생 삼겹살', 19000, 'samgyupsal.jpg', 'N');
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner09'), '된장찌개', 5000, 'stew.jpg', 'N');

-- Store 10 (을지로 노가리: 23, 24)
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner10'), '생맥주 500cc', 4500, 'beer.jpg', 'Y');
INSERT INTO MENU VALUES (SEQ_MENU.NEXTVAL, (SELECT store_id FROM STORE WHERE user_id='owner10'), '반건조 노가리', 12000, 'nogari.jpg', 'Y');

COMMIT;