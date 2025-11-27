// BoardQna.java
package com.example.lms.dto;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class BoardQna {

    private Long postId;        // DB: post_id (번호)
    private Long courseId;
    private Long userId;
    private String title;
    private String content;
    private Integer hitCount;   // DB: hit_count (조회수)
    private LocalDateTime createdate; // DB에서 가져오는 원본 날짜/시간
    private LocalDateTime updatedate; // ✅ [추가] 수정일 필드

    // JOIN을 통해 가져오는 필드
    private String userName;    // DB: u.user_name (작성자)

    // 서브 쿼리로 가져오는 필드
    private Integer commentCount;

    // 🚨 핵심: Service에서 포맷팅한 날짜 문자열을 저장하는 필드
    private String formattedCreatedate;
    private String formattedUpdatedate; // ✅ [추가] 포맷된 수정일 필드
}