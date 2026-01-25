/* com/uhi/gourmet/store/Criteria.java */
package com.uhi.gourmet.store;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {
    private int pageNum;
    private int amount; 
    
    private String category;
    private String region;
    private String keyword;

    public Criteria() {
        // [수정] 기본 페이징 단위를 12에서 6으로 변경
        this(1, 6); 
    }

    public Criteria(int pageNum, int amount) {
        this.pageNum = pageNum;
        this.amount = amount;
    }
}