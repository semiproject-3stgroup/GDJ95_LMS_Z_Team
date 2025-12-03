package com.example.lms.service;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.Course;
import com.example.lms.dto.EnrolledCourseSummary;
import com.example.lms.mapper.CourseMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CourseServiceImpl implements CourseService {
	
	@Autowired
	//순표: 서희님 제 부분 기능 구현때문에 추가좀 했습니다. 
    private CourseMapper courseMapper;   

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

    @Override
	//순표: 서희님 제 부분 기능 구현때문에 추가좀 했습니다. 
    public List<EnrolledCourseSummary> getEnrolledCoursesForHome(Long studentId, int limit) {

        log.debug("### [Service] getEnrolledCoursesForHome() 호출");
        log.debug("### [Service] studentId = {}, limit = {}", studentId, limit);

        if (studentId == null) {
            log.debug("### [Service] studentId null → 빈 리스트 반환");
            return List.of();
        }

        List<EnrolledCourseSummary> list =
                courseMapper.selectEnrolledCoursesForHome(studentId, limit);

        if (list == null) {
            log.debug("### [Service] Mapper 결과 = null");
        } else {
            log.debug("### [Service] Mapper 결과 size = {}", list.size());
        }

        return list;
    }
}