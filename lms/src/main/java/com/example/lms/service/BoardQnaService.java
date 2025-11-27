package com.example.lms.service;

import com.example.lms.dto.BoardQna;
import com.example.lms.dto.BoardQnaWriteRequest;
import com.example.lms.mapper.BoardQnaMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class BoardQnaService {

    private final BoardQnaMapper boardQnaMapper;
    
    @Autowired
    public BoardQnaService(BoardQnaMapper boardQnaMapper) {
        this.boardQnaMapper = boardQnaMapper;
    }

    public List<BoardQna> getBoardQnaList(Long courseId, String searchKeyword, int page, int pageSize) {
        
        int offset = (page - 1) * pageSize; // OFFSET 계산
        
        // Mapper 호출 시 offset과 pageSize 전달
        List<BoardQna> qnaList = boardQnaMapper.selectBoardQnaList(courseId, searchKeyword, offset, pageSize);
        
        // 핵심 로직: LocalDateTime을 "yyyy-MM-dd" 문자열로 변환하여 DTO에 저장
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        for (BoardQna qna : qnaList) {
            if (qna.getCreatedate() != null) {
                // formattedCreatedate 필드에 포맷된 String 값을 설정
                qna.setFormattedCreatedate(qna.getCreatedate().format(formatter));
            } else {
                // createdate가 null인 경우 안전하게 빈 문자열 설정
                qna.setFormattedCreatedate("");
            }
        }
        
        return qnaList;
    }

    public int getBoardQnaCount(Long courseId, String searchKeyword) {
        return boardQnaMapper.getBoardQnaCount(courseId, searchKeyword);
    }
    
    /**
     * QnA 게시글을 저장하는 메서드 (추가된 기능)
     * @param requestDto 게시글 작성 요청 DTO
     */
    @Transactional
    public void saveQnaPost(BoardQnaWriteRequest requestDto) {
        // BoardQnaWriteRequest DTO를 Mapper로 전달. 
        // Mapper.xml의 <insert id="saveQnaPost">가 이 요청을 처리합니다.
        boardQnaMapper.saveQnaPost(requestDto); 
    }

    /**
     * ✅ [수정] 게시글 상세 조회 및 조회수 증가, 날짜 포맷팅 처리
     */
    @Transactional
    public BoardQna getBoardQnaDetail(Long postId) {
        // 1. 게시글 상세 정보 조회
        BoardQna qna = boardQnaMapper.selectBoardQnaDetail(postId);
        
        if (qna != null) {
            // 2. 조회수 증가 (실제 구현 필요: mapper에 updateBoardQnaHitCount(postId) 호출 필요)
            // boardQnaMapper.incrementHitCount(postId); 
            
            // 3. 날짜 포맷팅 (상세 페이지는 시/분까지 포함)
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            if (qna.getCreatedate() != null) {
                qna.setFormattedCreatedate(qna.getCreatedate().format(formatter));
            }
            // 업데이트 날짜 포맷팅
            if (qna.getUpdatedate() != null) {
                qna.setFormattedUpdatedate(qna.getUpdatedate().format(formatter));
            } else {
                qna.setFormattedUpdatedate("N/A");
            }
        }
        
        return qna;
    }
    
    /**
     * ✅ [추가] 게시글 수정 처리
     * @param qna 수정 데이터 (postId, userId, title, content 포함)
     * @return 수정된 행의 수
     */
    @Transactional
    public int updateBoardQna(BoardQna qna) {
        // Mapper.xml에서 postId와 userId를 모두 조건으로 사용하여 본인 글만 수정되도록 보안 적용
        return boardQnaMapper.updateBoardQna(qna);
    }
    
    /**
     * ✅ [추가] 게시글 삭제 처리
     * @param postId 삭제할 게시글 ID
     * @return 삭제된 행의 수
     */
    @Transactional
    public int deleteBoardQna(Long postId) {
        // Mapper는 postId만 받아서 삭제 (Controller에서 이미 작성자 권한 검증 완료)
        return boardQnaMapper.deleteBoardQna(postId);
    }
}