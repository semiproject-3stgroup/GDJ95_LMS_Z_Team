package com.example.lms.service;

import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.lms.dto.BoardNotice;
import com.example.lms.dto.BoardNoticeFile;
import com.example.lms.mapper.BoardNoticeFileMapper;
import com.example.lms.mapper.BoardNoticeMapper;

@Slf4j
@Service
@Transactional
public class BoardNoticeService {

    @Autowired
    private BoardNoticeMapper boardNoticeMapper;

    @Autowired
    private BoardNoticeFileMapper boardNoticeFileMapper;

    // 실제 파일이 저장될 경로 (application.properties 에서 주입)
    @Value("${upload.notice.dir}")
    private String uploadDir;

    /**
     * 업로드된 파일 다운로드용 메타데이터 조회
     */
    public BoardNoticeFile getNoticeFile(Long fileId) {
        return boardNoticeFileMapper.selectFileOne(fileId);
    }

    /**
     * 공지 등록 + 파일 업로드 (로그인 유저)
     */
    public int addNotice(BoardNotice notice,
                         Long loginUserId,
                         List<MultipartFile> files) throws IOException {

        // 작성자 세팅
        notice.setUserId(loginUserId);

        // pinnedYn 기본값 보정
        if (notice.getPinnedYn() == null || notice.getPinnedYn().isBlank()) {
            notice.setPinnedYn("N");
        }

        // 상단 고정이 아닐 경우 기간 null 처리
        if (!"Y".equals(notice.getPinnedYn())) {
            notice.setPinStart(null);
            notice.setPinEnd(null);
        }

        // 공지게시글 먼저 저장
        int row = boardNoticeMapper.insertNotice(notice);
        Long noticeId = notice.getNoticeId();
        log.debug("★ addNotice noticeId = {}", noticeId);
        log.debug("★ addNotice files = {}", files);

        // 첨부파일이 있으면 저장
        saveFiles(noticeId, files);

        return row;
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
        int lastPage;
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
     * (예전 버전) 파일 없이 내용만 수정할 때 사용 가능
     */
    public void modifyNotice(BoardNotice notice) {

        if (notice.getPinnedYn() == null || notice.getPinnedYn().isBlank()) {
            notice.setPinnedYn("N");
        }

        if (!"Y".equals(notice.getPinnedYn())) {
            notice.setPinStart(null);
            notice.setPinEnd(null);
        }

        boardNoticeMapper.updateNotice(notice);
    }

    /**
     * 공지 수정 + 파일 삭제 + 새 파일 업로드
     */
    public void modifyNoticeWithFiles(BoardNotice notice,
                                      Long[] deleteFileIds,
                                      List<MultipartFile> newFiles) throws IOException {

        // pinnedYn 처리
        if (notice.getPinnedYn() == null || notice.getPinnedYn().isBlank()) {
            notice.setPinnedYn("N");
        }
        if (!"Y".equals(notice.getPinnedYn())) {
            notice.setPinStart(null);
            notice.setPinEnd(null);
        }

        // 공지 기본 정보 수정
        boardNoticeMapper.updateNotice(notice);

        Long noticeId = notice.getNoticeId();

        // 삭제 체크된 첨부파일 있으면 DB + 물리파일 삭제
        if (deleteFileIds != null && deleteFileIds.length > 0) {
            for (Long fileId : deleteFileIds) {
                if (fileId == null) continue;

                BoardNoticeFile file = boardNoticeFileMapper.selectFileOne(fileId);
                if (file != null) {
                    // 실제 파일 삭제
                    File f = new File(uploadDir, file.getFileName());
                    if (f.exists()) {
                        boolean deleted = f.delete();
                        log.debug("modifyNoticeWithFiles - delete fileId={} deleted={}", fileId, deleted);
                    }
                    // 메타데이터 삭제
                    boardNoticeFileMapper.deleteFileById(fileId);
                }
            }
        }

        // 새 파일 업로드
        saveFiles(noticeId, newFiles);
    }

    /**
     * 공지 삭제 (파일 메타 + 실제 파일 같이 삭제)
     */
    public void removeNotice(Long noticeId) {

        // 파일 목록 먼저 조회
        List<BoardNoticeFile> files = boardNoticeFileMapper.selectFilesByNoticeId(noticeId);

        if (files != null) {
            for (BoardNoticeFile file : files) {
                File f = new File(uploadDir, file.getFileName());
                if (f.exists()) {
                    boolean deleted = f.delete();
                    log.debug("removeNotice - delete fileId={} deleted={}", file.getFileId(), deleted);
                }
            }
        }

        // 파일 메타데이터 삭제 (FK CASCADE라도 안전하게 한 번 더)
        boardNoticeFileMapper.deleteFilesByNoticeId(noticeId);

        // 공지 삭제
        boardNoticeMapper.deleteNotice(noticeId);
    }

    /**
     * 특정 공지의 첨부파일 리스트 조회
     */
    public List<BoardNoticeFile> getNoticeFileList(Long noticeId) {
        return boardNoticeFileMapper.selectFilesByNoticeId(noticeId);
    }

    // ====================== private 공통 메서드 ======================

    /**
     * 첨부파일 저장 공통 로직 (등록/수정에서 같이 사용)
     */
    private void saveFiles(Long noticeId, List<MultipartFile> files) throws IOException {
        if (files == null || noticeId == null) return;

        log.debug("★ saveFiles noticeId={}, fileCount={}", noticeId, files.size());

        for (MultipartFile mf : files) {
            if (mf == null || mf.isEmpty()) continue;

            String originName = mf.getOriginalFilename();
            String uuid = UUID.randomUUID().toString();
            String ext = "";

            if (originName != null && originName.lastIndexOf(".") != -1) {
                ext = originName.substring(originName.lastIndexOf("."));
            }
            String saveName = uuid + ext; // 서버에 저장될 실제 파일명

            // 실제 디렉토리 없으면 생성
            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            // 파일 저장
            File dest = new File(dir, saveName);
            mf.transferTo(dest);

            // 메타데이터 DB 저장
            BoardNoticeFile file = new BoardNoticeFile();
            file.setNoticeId(noticeId);
            file.setFileName(saveName);             // 서버 파일명
            file.setOriginName(originName);         // 원본 파일명
            file.setFileSize(mf.getSize());         // 크기
            file.setFileType(mf.getContentType());  // MIME 타입

            boardNoticeFileMapper.insertNoticeFile(file);
        }
    }
}
