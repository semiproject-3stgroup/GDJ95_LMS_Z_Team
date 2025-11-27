package com.example.lms.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class BoardNotice {

    private Long noticeId;       // PK
    private Long userId;         // 작성자 ID (관리자)

    private String title;        // 제목
    private String content;      // 내용

    private String pinnedYn;     // 상단 고정 여부 (Y/N)
    private int hitCount;        // 조회수

    private LocalDateTime createdate;  // 등록일
    private LocalDateTime updatedate;  // 수정일
}
