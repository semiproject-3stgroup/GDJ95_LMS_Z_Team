package com.example.lms.service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.lms.dto.Course;
import com.example.lms.dto.CourseRegistration;
import com.example.lms.dto.CourseTimeSlot;
import com.example.lms.dto.EnrolledCourseSummary;
import com.example.lms.dto.WeeklyTimetableSlot;
import com.example.lms.mapper.CourseMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CourseServiceImpl implements CourseService {

    @Autowired
    private CourseMapper courseMapper;

    // 수강신청 기간/취소 기간 + 관리자 수동제어용
    @Autowired
    private CourseRegistrationSettingService courseRegistrationSettingService;

    @Override
    public List<Course> getMyCourses(Long userId) {
        // TODO: 나중에 실제 DB 조회로 교체
        Course course1 = new Course();
        course1.setCourseId(1L);
        course1.setCourseName("데이터베이스 설계");

        Course course2 = new Course();
        course2.setCourseId(2L);
        course2.setCourseName("웹 프로그래밍");

        return Arrays.asList(course1, course2);
    }

    @Override
    public List<EnrolledCourseSummary> getEnrolledCoursesForHome(Long studentId, int limit) {

        log.debug("### [Service] getEnrolledCoursesForHome() 호출 studentId={}, limit={}",
                studentId, limit);

        if (studentId == null) {
            log.debug("### [Service] studentId null → 빈 리스트 반환");
            return List.of();
        }

        Integer year = null;
        String semester = null;

        Map<String, Object> latest = courseMapper.selectLatestYearSemesterForStudent(studentId);
        if (latest != null) {
            year = (Integer) latest.get("courseYear");
            semester = (String) latest.get("courseSemester");
            log.debug("### [Service] 대시보드용 최신 학기 year={}, semester={}", year, semester);
        } else {
            log.debug("### [Service] 수강중인 과목이 없어 전체 학기 기준으로 조회");
        }

        List<EnrolledCourseSummary> list =
                courseMapper.selectEnrolledCoursesForHome(studentId, limit, year, semester);

        log.debug("### [Service] Mapper 결과 size={}",
                (list == null ? null : list.size()));

        return list;
    }

    @Override
    public List<Course> getOpenCoursesForRegister(Long studentId,
                                                  Integer year,
                                                  String semester) {
        if (studentId == null) {
            return List.of();
        }

        return courseMapper.selectOpenCoursesForRegister(studentId, year, semester);
    }

    @Override
    public List<Course> getMyRegisteredCourses(Long studentId,
                                               Integer year,
                                               String semester) {
        if (studentId == null) {
            return List.of();
        }

        return courseMapper.selectMyRegisteredCourses(studentId, year, semester);
    }

    /**
     * 실제 수강신청 로직 (단건)
     */
    private void doRegisterCourse(Long studentId, Long courseId) {

        if (studentId == null || courseId == null) {
            throw new IllegalArgumentException("학생/강의 정보가 올바르지 않습니다.");
        }

        // 0. 이미 신청한 과목인지 체크
        // Mapper: countAlreadyRegistered(@Param("courseId"), @Param("userId"))
        int already = courseMapper.countAlreadyRegistered(courseId, studentId);
        log.debug("### [Service] alreadyRegistered? studentId={}, courseId={}, count={}",
                studentId, courseId, already);

        if (already > 0) {
            throw new IllegalStateException("이미 수강 신청한 강의입니다.");
        }

        // 1. 과목 기본 정보 조회
        Course course = courseMapper.selectCourseBasicById(courseId);
        if (course == null) {
            throw new IllegalStateException("존재하지 않는 강의입니다.");
        }

        Integer year = course.getCourseYear();
        String semester = course.getCourseSemester();

        // 1-1. 수강신청 가능 기간 / 관리자 수동제어 체크
        if (!courseRegistrationSettingService.canRegister(year, semester)) {
            throw new IllegalStateException("수강신청 기간이 아닙니다.");
        }

        // 2. 학기당 최대 6과목 제한
        int registeredCount =
                courseMapper.countRegisteredCoursesInSemester(studentId, year, semester);

        if (registeredCount >= 6) {
            throw new IllegalStateException("한 학기에 최대 6과목까지만 수강신청할 수 있습니다.");
        }

        // 3. 시간 중복 체크
        int conflictCount = courseMapper.countTimeConflict(studentId, courseId);
        if (conflictCount > 0) {
            throw new IllegalStateException("이미 신청한 강의와 시간이 겹쳐 수강신청이 불가합니다.");
        }

        // 4. 정원 체크
        Integer maxCapacity = course.getMaxCapacity();
        if (maxCapacity != null) {
            int currentEnrolled = courseMapper.countEnrolledStudentsInCourse(courseId);
            if (currentEnrolled >= maxCapacity) {
                throw new IllegalStateException("정원 초과입니다.");
            }
        }

        // 5. 실제 INSERT
        CourseRegistration reg = new CourseRegistration();
        reg.setCourseId(courseId);
        reg.setUserId(studentId);
        reg.setStatus("ENROLLED");

        int rows = courseMapper.insertCourseRegistration(reg);
        log.debug("### [Service] 수강신청 insert rows={}, regId={}", rows, reg.getRegistrationId());
    }

    @Override
    @Transactional
    public void registerCourse(Long studentId, Long courseId) {
        doRegisterCourse(studentId, courseId);
    }

    @Override
    @Transactional
    public Map<Long, String> registerCoursesBulk(Long studentId, List<Long> courseIds) {

        Map<Long, String> failReasons = new java.util.LinkedHashMap<>();

        if (studentId == null || courseIds == null || courseIds.isEmpty()) {
            return failReasons;
        }

        for (Long courseId : courseIds) {
            try {
                doRegisterCourse(studentId, courseId);
            } catch (IllegalStateException e) {
                // 비즈니스 로직 에러(기간, 정원, 중복 등)
                Course course = courseMapper.selectCourseBasicById(courseId);
                String courseName = (course != null ? course.getCourseName() : "해당 강의");
                String msg = "'" + courseName + "'은(는) " + e.getMessage();
                failReasons.put(courseId, msg);
            } catch (Exception e) {
                log.error("수강신청(bulk) 중 알 수 없는 오류 courseId={}", courseId, e);
                Course course = courseMapper.selectCourseBasicById(courseId);
                String courseName = (course != null ? course.getCourseName() : "해당 강의");
                failReasons.put(courseId, "'" + courseName + "'은(는) 알 수 없는 오류가 발생했습니다.");
            }
        }

        return failReasons;
    }

    @Override
    @Transactional
    public void cancelCourse(Long studentId, Long courseId) {

        if (studentId == null || courseId == null) {
            return;
        }

        Course course = courseMapper.selectCourseBasicById(courseId);
        if (course == null) {
            return;
        }

        Integer year = course.getCourseYear();
        String semester = course.getCourseSemester();

        if (!courseRegistrationSettingService.canCancel(year, semester)) {
            throw new IllegalStateException("현재는 수강취소 기간이 아닙니다.");
        }

        int rows = courseMapper.cancelCourseRegistration(studentId, courseId);
        log.debug("### [Service] 수강취소 rows={}", rows);
    }

    @Override
    public List<WeeklyTimetableSlot> getWeeklyTimetable(Long studentId,
                                                        Integer year,
                                                        String semester) {
        if (studentId == null) {
            return List.of();
        }
        return courseMapper.selectWeeklyTimetableByStudent(studentId, year, semester);
    }

    @Override
    public List<CourseTimeSlot> getWeeklyTimetable(Long studentId, List<Long> previewCourseIds) {
        if (studentId == null) return List.of();
        return courseMapper.selectWeeklyTimetable(studentId, previewCourseIds);
    }
    
    @Override
    public List<Course> getProfessorCourses(Long profId,
                                            Integer year,
                                            String semester) {
        if (profId == null) {
            return List.of();
        }
        return courseMapper.selectCoursesByProfessor(profId, year, semester);
    }

    @Override
    public Course getCourseBasic(Long courseId) {
        if (courseId == null) return null;
        return courseMapper.selectCourseBasicById(courseId);
    }

    @Override
    public List<com.example.lms.dto.CourseStudent> getCourseStudents(Long courseId) {
        if (courseId == null) return List.of();
        return courseMapper.selectCourseStudents(courseId);
    }
}
