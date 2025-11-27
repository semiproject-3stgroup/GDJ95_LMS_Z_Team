package com.example.lms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.lms.dto.BoardNotice;
import com.example.lms.mapper.BoardNoticeMapper;

@Service
@Transactional
public class BoardNoticeService {

    @Autowired
    private BoardNoticeMapper boardNoticeMapper;

    /**
     * 공지사항 전체 목록 조회
     * (공지 목록 화면 /notice/list 에서 사용 예정)
     */
    public List<BoardNotice> getNoticeList() {
        return boardNoticeMapper.selectNoticeList();
    }

    /**
     * 공지사항 1건 상세 조회
     * (공지 상세 화면 /notice/detail 에서 사용 예정)
     */
    public BoardNotice getNoticeOne(Long noticeId) {
        return boardNoticeMapper.selectNoticeOne(noticeId);
    }

    /**
     * 메인 페이지용 최신 공지 N건
     * (home.jsp 대시보드 카드에 사용)
     */
    public List<BoardNotice> getRecentNotices(int limit) {
        return boardNoticeMapper.selectRecentNoticeList(limit);
    }
}
