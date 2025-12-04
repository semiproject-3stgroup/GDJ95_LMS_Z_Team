package com.example.lms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.HomeAssignmentSummary;
import com.example.lms.mapper.AssignmentHomeMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AssignmentHomeService {

    @Autowired
    private AssignmentHomeMapper assignmentHomeMapper;

    public List<HomeAssignmentSummary> getUpcomingAssignmentsForHome(Long userId) {
        log.debug("[AssignmentHomeService] getUpcomingAssignmentsForHome userId={}", userId);
        return assignmentHomeMapper.selectUpcomingAssignmentsForHome(userId);
    }
}
