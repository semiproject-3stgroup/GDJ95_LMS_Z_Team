package com.example.lms.service;

import com.example.lms.dto.Course;
import java.util.List;

public interface CourseService {
    List<Course> getMyCourses(Long userId);
}