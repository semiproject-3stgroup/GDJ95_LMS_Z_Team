package com.example.lms.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class BoardQnaListResponse {
    private Long postId;
    private String title;
    private Long courseId;
    private String userName;
    private LocalDateTime createdate;
    private int hitCount;
    private int commentCount;
    private String status;
    
}
