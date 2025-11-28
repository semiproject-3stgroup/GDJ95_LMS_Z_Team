package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.BoardNotice;

@Mapper
public interface BoardNoticeMapper {
	
	// 공지 등록
    int insertNotice(BoardNotice notice);

    // 공지 목록 (페이징, 검색)
    List<BoardNotice> selectNoticeList(Map<String, Object> param);

    // 전체 공지 개수
    int selectNoticeCount();

    // 검색 일치 공지 개수
    int selectNoticeCount(Map<String, Object> param);
    
    // 공지 상세
    BoardNotice selectNoticeOne(@Param("noticeId") Long noticeId);

    // 메인 페이지용: 최신 공지 N건
    List<BoardNotice> selectRecentNoticeList(@Param("limit") int limit);
    
    // 조회수 + 1
    int updateNoticeHit(@Param("noticeId") Long noticeId);
    
    // 공지 수정
    int updateNotice(BoardNotice notice);
    
    // 공지 삭제
    int deleteNotice(Long noticeId);

    
}
