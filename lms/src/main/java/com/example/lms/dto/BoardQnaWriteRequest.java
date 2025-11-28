package com.example.lms.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class BoardQnaWriteRequest {
    private Long postId; 
    private String title;
    private String content;
    private Long userId;
    private Long courseId; 
    private LocalDateTime createdate;
}