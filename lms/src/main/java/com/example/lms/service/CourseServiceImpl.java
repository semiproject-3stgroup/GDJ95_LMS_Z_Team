package com.example.lms.service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.lms.dto.Course;
import com.example.lms.dto.CourseRegistration;
import com.example.lms.dto.CourseRegistrationSetting;
import com.example.lms.dto.CourseTimeSlot;
import com.example.lms.dto.EnrolledCourseSummary;
import com.example.lms.dto.WeeklyTimetableSlot;
import com.example.lms.mapper.CourseMapper;
import com.example.lms.mapper.CourseRegistrationSettingMapper;

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

        // 1) 이 학생이 ENROLLED 상태인 과목들 중 가장 최근 학년/학기 1건 가져오기
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

        // 2) 그 학년/학기에 해당하는 과목만 가져오기 (없으면 전체)
        List<EnrolledCourseSummary> list =
                courseMapper.selectEnrolledCoursesForHome(studentId, limit, year, semester);

        log.debug("### [Service] Mapper 결과 size={}",
                (list == null ? null : list.size()));

        return list;
    }

    // 수강신청 화면용 조회
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

    // 수강 신청
    @Override
    @Transactional
    public void registerCourse(Long studentId, Long courseId) {

        if (studentId == null || courseId == null) {
            throw new IllegalArgumentException("학생/강의 정보가 올바르지 않습니다.");
        }

        // 0. 이미 신청한 과목인지 체크
        int already = courseMapper.countAlreadyRegistered(studentId, courseId);
        if (already > 0) {
            throw new IllegalStateException("이미 수강 신청한 강의입니다.");
        }

        // 1. 과목 기본 정보 조회
        Course course = courseMapper.selectCourseBasicById(courseId);
        if (course == null) {
            throw new IllegalStateException("존재하지 않는 강의입니다.");
        }

        Integer year = course.getCourseYear();
        String  semester = course.getCourseSemester();

        // 1-1. [권순표] 수강신청 가능 기간 / 관리자 수동제어 체크
        if (!courseRegistrationSettingService.canRegister(year, semester)) {
            throw new IllegalStateException("현재는 수강신청 기간이 아닙니다.");
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
                throw new IllegalStateException("정원이 초과된 강의입니다.");
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

    // 수강 취소
    @Override
    @Transactional
    public void cancelCourse(Long studentId, Long courseId) {

        if (studentId == null || courseId == null) {
            return;
        }

        // [권순표] 취소도 학기별 기간/수동제어 체크
        Course course = courseMapper.selectCourseBasicById(courseId);
        if (course == null) {
            // 강의가 없으면 그냥 아무 것도 안 하고 리턴
            return;
        }

        Integer year = course.getCourseYear();
        String  semester = course.getCourseSemester();

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
    public List<CourseTimeSlot> getWeeklyTimetable(Long studentId, Long previewCourseId) {
        if (studentId == null) return List.of();
        return courseMapper.selectWeeklyTimetable(studentId, previewCourseId);
    }
    
    /**
     * 메인 대시보드용 "현재 학기" 조회
     * - selectCurrentSetting() 먼저 시도
     * - 없으면 selectLatest() 로 fallback
     */
    
}
