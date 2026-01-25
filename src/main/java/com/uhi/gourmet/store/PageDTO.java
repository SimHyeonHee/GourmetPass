/* com/uhi/gourmet/store/PageDTO.java */
package com.uhi.gourmet.store;

import lombok.Getter;
import lombok.ToString;

/**
 * [DTO] PageDTO (페이징 UI 제어 및 계산 객체)
 * * 1. VO(Value Object)와의 차이점:
 * - StoreVO가 DB 테이블(STORE)의 데이터를 그대로 옮겨담는 '그릇'이라면, 
 * - PageDTO는 화면(JSP) 하단에 [PREV] [1] [2] ... [10] [NEXT] 버튼을 
 * 어떻게 그릴지 결정하는 '계산기' 역할을 합니다.
 * - DB에는 저장되지 않는 오직 화면 출력을 위한 비즈니스 로직(수학적 계산)이 포함됩니다.
 * * 2. 주요 역할:
 * - 사용자가 보낸 페이지 번호(Criteria)와 DB의 전체 데이터 개수(total)를 비교하여
 * 시작 페이지와 끝 페이지 번호를 실시간으로 계산합니다.
 */
@Getter
@ToString
public class PageDTO {

    private int startPage;    // 화면 하단에 보여줄 시작 페이지 번호 (예: 1, 11, 21...)
    private int endPage;      // 화면 하단에 보여줄 끝 페이지 번호 (예: 10, 20, 30...)
    private boolean prev;     // [이전] 버튼 활성화 여부
    private boolean next;     // [다음] 버튼 활성화 여부

    private int total;        // DB에서 조회된 검색 조건에 맞는 전체 게시물 수
    private Criteria cri;     // 현재 페이지 번호와 한 페이지당 출력량이 담긴 객체

    /**
     * 페이징 계산 생성자
     * @param cri 현재 페이지 정보
     * @param total 전체 게시물 수
     */
    public PageDTO(Criteria cri, int total) {
        this.cri = cri;
        this.total = total;

        // 1. 끝 페이지 계산 (현재 페이지를 기준으로 일단 10개 단위로 끊음)
        // 공식: (int)(Math.ceil(현재페이지 / 10.0)) * 10
        this.endPage = (int) (Math.ceil(cri.getPageNum() / 10.0)) * 10;

        // 2. 시작 페이지 계산
        // 공식: 끝 페이지 - 9
        this.startPage = this.endPage - 9;

        // 3. 실제 마지막 페이지(realEnd) 계산
        // 전체 데이터가 125개이고 한 페이지에 12개씩 보여준다면 실제 끝은 11페이지임
        int realEnd = (int) (Math.ceil((total * 1.0) / cri.getAmount()));

        // 4. 끝 페이지 보정
        // 위에서 계산한 10단위 endPage가 실제 데이터 끝(realEnd)보다 크면 실제 끝으로 맞춤
        if (realEnd < this.endPage) {
            this.endPage = realEnd;
        }

        // 5. 이전/다음 버튼 활성화 판단
        // 시작 페이지가 1보다 크면 [PREV] 버튼 활성화
        this.prev = this.startPage > 1;
        // 보정된 끝 페이지보다 실제 데이터 끝 페이지가 더 많으면 [NEXT] 버튼 활성화
        this.next = this.endPage < realEnd;
    }
}