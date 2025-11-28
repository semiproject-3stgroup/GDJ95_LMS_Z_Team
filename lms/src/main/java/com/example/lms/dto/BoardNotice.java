package com.example.lms.dto;

import java.time.LocalDateTime;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class BoardNotice {

    private Long noticeId;       // PK
    private Long userId;         // 작성자 ID (관리자)

    private String title;        // 제목
    private String content;      // 내용

    private String pinnedYn;     // 상단 고정 여부 (Y/N)
    
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime pinStart; // 상단고정기간 시작일

    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime pinEnd; // 상단고정기간 종료일
    
    private int hitCount;        // 조회수

    private LocalDateTime createdate;  // 등록일
    private LocalDateTime updatedate;  // 수정일
    
    private String writerName; // 작성자이름(관리자)
    
    
}
