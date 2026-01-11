package com.uhi.gourmet.review;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ReviewServiceImpl implements ReviewService {

    @Autowired
    private ReviewMapper review_mapper;

    @Override
    public void addReview(ReviewVO vo) {
        review_mapper.insertReview(vo);
    }

    @Override
    public List<ReviewVO> getStoreReviews(int store_id) {
        return review_mapper.selectStoreReviews(store_id);
    }

    @Override
    public List<ReviewVO> getMyReviews(String user_id) {
        return review_mapper.selectMyReviews(user_id);
    }

    @Override
    public Map<String, Object> getReviewStats(int store_id) {
        return review_mapper.selectReviewStats(store_id);
    }

    @Override
    public void removeReview(int review_id) {
        review_mapper.deleteReview(review_id);
    }

    // [추가] 방문 완료 건수가 0보다 크면 리뷰 작성 가능
    @Override
    public boolean checkReviewEligibility(String user_id, int store_id) {
        int count = review_mapper.countFinishedVisits(user_id, store_id);
        return count > 0;
    }
}