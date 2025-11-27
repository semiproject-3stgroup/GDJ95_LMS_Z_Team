package com.example.lms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.Event;
import com.example.lms.mapper.EventMapper;

@Service
public class EventService {

    @Autowired
    private EventMapper eventMapper;

    public List<Event> getEventList() {
        return eventMapper.selectEventList();
    }

    public List<Event> getUpcomingEvents(int limit) {
        return eventMapper.selectUpcomingEvents(limit);
    }

    public Event getEvent(Long eventId) {
        return eventMapper.selectEventOne(eventId);
    }

    public void addEvent(Event event) {
        eventMapper.insertEvent(event);
    }

    public void modifyEvent(Event event) {
        eventMapper.updateEvent(event);
    }

    public void removeEvent(Long eventId) {
        eventMapper.deleteEvent(eventId);
    }
}
