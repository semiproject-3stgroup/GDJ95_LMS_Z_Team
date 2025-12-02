package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.lms.dto.BoardNoticeFile;

@Mapper
public interface BoardNoticeFileMapper {

    // 파일 등록
    int insertNoticeFile(BoardNoticeFile file);

    // 특정 공지의 첨부파일 목록
    List<BoardNoticeFile> selectFilesByNoticeId(Long noticeId);

    // 파일 1개 조회
    BoardNoticeFile selectFileOne(Long fileId);

    // 파일 1개 삭제 (file_id 기준)
    int deleteFileById(Long fileId);

    // 해당 공지에 달린 모든 파일 삭제 (notice_id 기준)
    int deleteFilesByNoticeId(Long noticeId);
}
