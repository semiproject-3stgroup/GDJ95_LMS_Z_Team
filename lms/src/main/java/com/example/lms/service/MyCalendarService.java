package com.example.lms.service;

import java.time.LocalDateTime;
import java.util.List;

import com.example.lms.dto.MyCalendarEvent;
import com.example.lms.dto.User;

public interface MyCalendarService {
    
    List<MyCalendarEvent> getMyCalendarEvents(User loginUser,
                                              LocalDateTime start,
                                              LocalDateTime end);
}
