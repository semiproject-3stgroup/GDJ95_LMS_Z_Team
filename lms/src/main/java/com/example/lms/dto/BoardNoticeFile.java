package com.example.lms.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class BoardNoticeFile {

    private Long fileId;      // PK
    private Long noticeId;    // FK

    private String fileName;      // 서버 저장 파일명 (UUID)
    private String originName;    // 원본 파일명
    private Long fileSize;        // 파일 크기
    private String fileType;      // MIME 타입

    private LocalDateTime createdate;
}
