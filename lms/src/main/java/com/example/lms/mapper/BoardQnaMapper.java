package com.example.lms.mapper;

import com.example.lms.dto.BoardQna;
import com.example.lms.dto.BoardQnaListResponse;
import com.example.lms.dto.BoardQnaWriteRequest;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BoardQnaMapper {

    List<BoardQna> selectBoardQnaList(
        @Param("courseId") Long courseId, 
        @Param("searchKeyword") String searchKeyword,
        @Param("offset") int offset,   // 페이징 시작 위치
        @Param("limit") int limit);    // 페이지당 항목 수

    // 전체 게시글 수를 조회하는 메서드
    int getBoardQnaCount(@Param("courseId") Long courseId, @Param("searchKeyword") String searchKeyword);

    List<BoardQnaListResponse> findQnaListByCourseId(@Param("courseId") Long courseId);

    BoardQna selectBoardQnaDetail(Long postId);

    void saveQnaPost(BoardQnaWriteRequest requestDto);

    void insertBoardQna(BoardQna boardQna);

    int updateBoardQna(BoardQna boardQna);

    int deleteBoardQna(Long postId);

	void updateHitCount(Long postId);
}