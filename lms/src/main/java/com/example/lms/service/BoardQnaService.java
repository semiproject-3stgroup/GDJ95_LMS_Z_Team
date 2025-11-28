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

    // 이 메서드가 BoardQnaMapper.xml에 매핑될 쿼리가 없어 오류가 발생했습니다.
    public int getBoardQnaCount(Long courseId, String searchKeyword) {
        return boardQnaMapper.getBoardQnaCount(courseId, searchKeyword);
    }

    @Transactional
    public void saveQnaPost(BoardQnaWriteRequest requestDto) {
        boardQnaMapper.saveQnaPost(requestDto); 
    }

    @Transactional
    public BoardQna getBoardQnaDetail(Long postId) {
        // 1. 게시글 상세 정보 조회
        BoardQna qna = boardQnaMapper.selectBoardQnaDetail(postId);
        
        if (qna != null) {
            // 2. 조회수 증가 (BoardQnaMapper.xml의 updateHitCount ID를 호출)
            boardQnaMapper.updateHitCount(postId); 
            
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

    @Transactional
    public int updateBoardQna(BoardQna qna) {
        // Mapper.xml에서 postId와 userId를 모두 조건으로 사용하여 본인 글만 수정되도록 보안 적용
        return boardQnaMapper.updateBoardQna(qna);
    }

    @Transactional
    public int deleteBoardQna(Long postId) {
        // Mapper는 postId만 받아서 삭제 (Controller에서 이미 작성자 권한 검증 완료)
        return boardQnaMapper.deleteBoardQna(postId);
    }
}