package com.example.lms.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class BoardQnaComment {
    private Long commentId;     // 댓글 ID (PK)
    private Long postId;        // 게시글 ID (FK)
    private Long userId;        // 댓글 작성자 ID (FK)
    private String content;     // 댓글 내용
    private LocalDateTime createdate; // 작성일
    private LocalDateTime updatedate; // 수정일

    // 댓글 작성자 이름 (JOIN을 통해 가져올 필드)
    private String userName;

    // View에서 사용할 포맷된 날짜 문자열
    private String formattedCreatedate;
}