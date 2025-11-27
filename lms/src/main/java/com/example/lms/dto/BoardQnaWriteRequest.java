package com.example.lms.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class BoardQnaWriteRequest {
    // ✅ [추가] MyBatis가 생성된 키(postId)를 주입할 수 있도록 필드 추가
    private Long postId; 

    // Controller에서 요청 본문을 받을 때 사용
    private String title;
    private String content;
    
    // Controller에서 세션/PathVariable을 통해 주입
    private Long userId;
    private Long courseId;
    
    private LocalDateTime createdate; // 사용하지 않을 수 있으나 DTO에 포함
}