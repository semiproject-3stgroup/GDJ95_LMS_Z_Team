package com.example.lms.service;

import com.example.lms.dto.Course;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
public class CourseServiceImpl implements CourseService {

    @Override
    public List<Course> getMyCourses(Long userId) {
        Course course1 = new Course();
        course1.setCourseId(1L);
        course1.setCourseName("데이터베이스 설계");
        
        Course course2 = new Course();
        course2.setCourseId(2L);
        course2.setCourseName("웹 프로그래밍");

        return Arrays.asList(course1, course2);
    }
}