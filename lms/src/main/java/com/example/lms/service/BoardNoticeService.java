package com.example.lms.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
     공지 등록 (로그인 유저)
     */ 
    public int addNotice(BoardNotice notice, Long loginUserId) {
        notice.setUserId(loginUserId);

        if (notice.getPinnedYn() == null || notice.getPinnedYn().isBlank()) {
            notice.setPinnedYn("N");
        }

        // 상단 고정이 아닐 경우 null 처리
        if (!"Y".equals(notice.getPinnedYn())) {
            notice.setPinStart(null);
            notice.setPinEnd(null);
        }

        return boardNoticeMapper.insertNotice(notice);
    }
    
    /**
     * 공지 목록 (페이징/ 검색)
     * /notice/list 에서 사용
     */
    public Map<String, Object> getNoticeList(int page, String searchType, String searchWord) {

        int rowPerPage = 10;                // 한 페이지당 게시글 수
        int pagePerGroup = 5;               // 페이지 번호 몇 개씩 보여줄지
        int beginRow = (page - 1) * rowPerPage;

        // mapper로 넘길 파라미터
        Map<String, Object> param = new HashMap<>();
        param.put("beginRow", beginRow);
        param.put("rowPerPage", rowPerPage);
        param.put("searchType", searchType);
        param.put("searchWord", searchWord);

        // 목록 + 전체 개수
        List<BoardNotice> list = boardNoticeMapper.selectNoticeList(param);
        int totalCount = boardNoticeMapper.selectNoticeCount(param);

        // 마지막 페이지 번호
        int lastPage = 0;
        if (totalCount > 0) {
            lastPage = (int) Math.ceil((double) totalCount / rowPerPage);
        } else {
            lastPage = 1; // 글 하나도 없을 때 기본값 1페이지
        }

        // 페이지 그룹 계산
        int startPage = ((page - 1) / pagePerGroup) * pagePerGroup + 1;
        int endPage = startPage + pagePerGroup - 1;
        if (endPage > lastPage) {
            endPage = lastPage;
        }

        // 결과 묶어서 리턴
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("totalCount", totalCount);
        result.put("currentPage", page);
        result.put("lastPage", lastPage);
        result.put("startPage", startPage);
        result.put("endPage", endPage);

        return result;
    }

    /**
     * 공지 1건 조회 (조회수 증가 X)
     * - 수정/삭제 화면에서 사용
     */
    public BoardNotice getNoticeOne(Long noticeId) {
        return boardNoticeMapper.selectNoticeOne(noticeId);
    }
    
    /**
     * 조회수 증가, 1건 조회
     */
    
    public BoardNotice getNoticeDetail(Long noticeId) {
        // 조회수 +1
        boardNoticeMapper.updateNoticeHit(noticeId);
        // 상세 조회
        return boardNoticeMapper.selectNoticeOne(noticeId);
    }

    /**
     * 메인 페이지용 최신 공지 N건
     * home.jsp 대시보드 카드에서 사용
     */
    public List<BoardNotice> getRecentNotices(int limit) {
        return boardNoticeMapper.selectRecentNoticeList(limit);
    }
    
    /**
     * 공지 수정
     */
    public void modifyNotice(BoardNotice notice) {

        // pinnedYn 기본값 보정
        if (notice.getPinnedYn() == null || notice.getPinnedYn().isBlank()) {
            notice.setPinnedYn("N");
        }

        // 상단 고정이 아닐 경우 기간은 의미 없으니 null 처리
        if (!"Y".equals(notice.getPinnedYn())) {
            notice.setPinStart(null);
            notice.setPinEnd(null);
        }

        boardNoticeMapper.updateNotice(notice);
    }
    
    /**
     * 공지 삭제
     */
    public void removeNotice(Long noticeId) {
        boardNoticeMapper.deleteNotice(noticeId);
    }
    
}
