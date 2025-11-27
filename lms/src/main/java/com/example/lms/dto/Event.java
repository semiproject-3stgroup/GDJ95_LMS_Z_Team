package com.example.lms.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Event {
    private Long eventId;        
    private String eventName;    
    private LocalDateTime eventFromdate;
    private LocalDateTime eventTodate;
    private String eventContext; 
    private Long userId;         
    private String createdate;   
    private String updatedate;   
}
