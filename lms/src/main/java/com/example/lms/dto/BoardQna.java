// BoardQna.java
package com.example.lms.dto;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class BoardQna {

    private Long postId; 
    private Long courseId;
    private Long userId;
    private String title;
    private String content;
    private Integer hitCount; 
    private LocalDateTime createdate;
    private LocalDateTime updatedate;
    private String userName; 
    private Integer commentCount;
    private String formattedCreatedate;
    private String formattedUpdatedate;
}