package com.example.lms.mapper;

import com.example.lms.dto.BoardQna;
import com.example.lms.dto.BoardQnaListResponse;
import com.example.lms.dto.BoardQnaWriteRequest;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BoardQnaMapper {

    // 🚨 [수정] 페이징을 위한 offset과 limit 파라미터 추가
    List<BoardQna> selectBoardQnaList(
        @Param("courseId") Long courseId, 
        @Param("searchKeyword") String searchKeyword,
        @Param("offset") int offset,   // 페이징 시작 위치
        @Param("limit") int limit);    // 페이지당 항목 수

    // 🚨 [추가] 전체 게시글 수를 조회하는 메서드
    int getBoardQnaCount(@Param("courseId") Long courseId, @Param("searchKeyword") String searchKeyword);

    // BoardQnaListResponse DTO를 사용하는 메서드는 현재 사용되지 않는 것으로 보입니다.
    List<BoardQnaListResponse> findQnaListByCourseId(@Param("courseId") Long courseId);

    BoardQna selectBoardQnaDetail(Long postId);
    
    /**
     * Q&A 게시글 등록 메서드 (추가된 기능)
     */
    void saveQnaPost(BoardQnaWriteRequest requestDto);

    void insertBoardQna(BoardQna boardQna);

    // ✅ [수정] updateBoardQna는 DTO를 받음
    int updateBoardQna(BoardQna boardQna);

    // ✅ [추가] deleteBoardQna 추가
    int deleteBoardQna(Long postId);
}