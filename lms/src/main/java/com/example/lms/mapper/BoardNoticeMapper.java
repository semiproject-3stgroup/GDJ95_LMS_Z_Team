package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.BoardNotice;

@Mapper
public interface BoardNoticeMapper {

    // 1) 공지 목록 (전체 목록 화면용)
    List<BoardNotice> selectNoticeList();

    // 2) 공지 상세
    BoardNotice selectNoticeOne(Long noticeId);

    // 3) 메인 페이지용: 최신 공지 N건
    List<BoardNotice> selectRecentNoticeList(int limit);
}
