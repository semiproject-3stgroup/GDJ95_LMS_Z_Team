package com.example.lms.controller;

import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.lms.dto.Course;
import com.example.lms.dto.User;
import com.example.lms.mapper.CourseRegistrationSettingMapper;
import com.example.lms.service.CourseRegistrationSettingService;
import com.example.lms.service.CourseService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/course")
public class CourseController {

    @Autowired
    private CourseService courseService;

    // 학년도/학기 선택용
    @Autowired
    private CourseRegistrationSettingMapper courseRegistrationSettingMapper;

    // 기간/수동열기 상태용
    @Autowired
    private CourseRegistrationSettingService courseRegistrationSettingService;

    private static final DateTimeFormatter DT_FMT =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    /**
     * 수강신청 화면
     */
    @GetMapping("/register")
    public String showRegisterPage(@RequestParam(required = false) Integer year,
                                   @RequestParam(required = false) String semester,
                                   HttpSession session,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            redirectAttributes.addFlashAttribute("message", "로그인이 필요합니다.");
            redirectAttributes.addFlashAttribute("messageType", "error");
            return "redirect:/login";
        }

        if (!"STUDENT".equalsIgnoreCase(loginUser.getRole())) {
            redirectAttributes.addFlashAttribute("message", "학생만 수강신청을 할 수 있습니다.");
            redirectAttributes.addFlashAttribute("messageType", "error");
            return "redirect:/home";
        }

        Long studentId = loginUser.getUserId();

        // 1) 사용 가능한 학년도/학기 목록
        List<Integer> yearList = courseRegistrationSettingMapper.selectAvailableYears();
        List<String> semesterList = null;

        if (year == null && yearList != null && !yearList.isEmpty()) {
            year = yearList.get(yearList.size() - 1); // 가장 최신 연도
        }

        if (year != null) {
            semesterList = courseRegistrationSettingMapper.selectAvailableSemesters(year);
        }

        if ((semester == null || semester.isBlank())
                && semesterList != null && !semesterList.isEmpty()) {
            semester = semesterList.get(semesterList.size() - 1); // 최신 학기
        }

        // 2) 신청가능 강의목록
        List<Course> openCourses =
                courseService.getOpenCoursesForRegister(studentId, year, semester);

        // 3) 주간 예상 시간표
        var weeklyTimetable =
                courseService.getWeeklyTimetable(studentId, year, semester);

        // 4) 수강신청 기간/수동 상태 배너용
        var regStatus = courseRegistrationSettingService.getRegisterStatus(year, semester);

        String registerBannerText = null;
        String registerBannerType = "info";

        if (!regStatus.isSettingExists()) {
            registerBannerText =
                    "해당 학기의 수강신청 기간 설정이 없어, 기간 제한 없이 신청할 수 있습니다.";
            registerBannerType = "info";
        } else {
            var s = regStatus.getSetting();
            String periodText = "";
            if (s.getRegisterStart() != null && s.getRegisterEnd() != null) {
                periodText = s.getRegisterStart().format(DT_FMT)
                        + " ~ "
                        + s.getRegisterEnd().format(DT_FMT);
            } else {
                periodText = "기간 미설정";
            }

            if (regStatus.isManualOpen()) {
                registerBannerType = "success";
                registerBannerText =
                        String.format("현재 %d년 %s 수강신청은 '수동 항상 열기' 상태입니다. (설정된 기간: %s)",
                                year, semester, periodText);
            } else if (regStatus.isAllowed()) {
                registerBannerType = "success";
                registerBannerText =
                        String.format("지금은 %d년 %s 수강신청 기간입니다. (%s 동안 신청 가능)",
                                year, semester, periodText);
            } else {
                registerBannerType = "error";
                registerBannerText =
                        String.format("현재는 %d년 %s 수강신청 기간이 아닙니다. (%s 동안만 신청 가능)",
                                year, semester, periodText);
            }
        }

        model.addAttribute("openCourses", openCourses);
        model.addAttribute("weeklyTimetable", weeklyTimetable);
        model.addAttribute("year", year);
        model.addAttribute("semester", semester);
        model.addAttribute("yearList", yearList);
        model.addAttribute("semesterList", semesterList);

        model.addAttribute("registerBannerText", registerBannerText);
        model.addAttribute("registerBannerType", registerBannerType);

        return "course/course_register";
    }

    /**
     * 내 수강목록 화면
     */
    @GetMapping("/my")
    public String showMyCourses(@RequestParam(required = false) Integer year,
                                @RequestParam(required = false) String semester,
                                HttpSession session,
                                Model model,
                                RedirectAttributes redirectAttributes) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            redirectAttributes.addFlashAttribute("message", "로그인이 필요합니다.");
            redirectAttributes.addFlashAttribute("messageType", "error");
            return "redirect:/login";
        }

        if (!"STUDENT".equalsIgnoreCase(loginUser.getRole())) {
            redirectAttributes.addFlashAttribute("message", "학생만 수강목록을 조회할 수 있습니다.");
            redirectAttributes.addFlashAttribute("messageType", "error");
            return "redirect:/home";
        }

        Long studentId = loginUser.getUserId();

        // 학년도/학기 셀렉트 박스 (수강신청 화면과 동일)
        List<Integer> yearList = courseRegistrationSettingMapper.selectAvailableYears();
        List<String> semesterList = null;

        if (year == null && yearList != null && !yearList.isEmpty()) {
            year = yearList.get(yearList.size() - 1);
        }

        if (year != null) {
            semesterList = courseRegistrationSettingMapper.selectAvailableSemesters(year);
        }

        if ((semester == null || semester.isBlank())
                && semesterList != null && !semesterList.isEmpty()) {
            semester = semesterList.get(semesterList.size() - 1);
        }

        List<Course> myCourses =
                courseService.getMyRegisteredCourses(studentId, year, semester);

        // 수강취소 기간/수동 상태 배너용
        var cancelStatus = courseRegistrationSettingService.getCancelStatus(year, semester);
        String cancelBannerText = null;
        String cancelBannerType = "info";

        if (!cancelStatus.isSettingExists()) {
            cancelBannerText =
                    "해당 학기의 수강취소 기간 설정이 없어, 기간 제한 없이 수강취소가 가능합니다.";
            cancelBannerType = "info";
        } else {
            var s = cancelStatus.getSetting();
            String cancelText;
            if (s.getCancelEnd() != null) {
                cancelText = s.getCancelEnd().format(DT_FMT) + " 까지";
            } else {
                cancelText = "취소 마감일 미설정 (제한 없음)";
            }

            if (cancelStatus.isManualOpen()) {
                cancelBannerType = "success";
                cancelBannerText =
                        String.format("현재 %d년 %s는 '수동 항상 열기' 상태로, 언제든지 수강취소가 가능합니다. (취소 마감 설정: %s)",
                                year, semester, cancelText);
            } else if (cancelStatus.isAllowed()) {
                cancelBannerType = "success";
                cancelBannerText =
                        String.format("지금은 %d년 %s 수강취소 가능 기간입니다. (취소 가능: %s)",
                                year, semester, cancelText);
            } else {
                cancelBannerType = "error";
                cancelBannerText =
                        String.format("현재는 %d년 %s 수강취소 기간이 아닙니다. (취소 가능 기간: %s)",
                                year, semester, cancelText);
            }
        }

        model.addAttribute("myCourses", myCourses);
        model.addAttribute("year", year);
        model.addAttribute("semester", semester);
        model.addAttribute("yearList", yearList);
        model.addAttribute("semesterList", semesterList);

        model.addAttribute("cancelBannerText", cancelBannerText);
        model.addAttribute("cancelBannerType", cancelBannerType);

        return "course/course_my";
    }

    /**
     * 수강신청 처리
     */
    @PostMapping("/register")
    public String registerCourse(@RequestParam("courseId") Long courseId,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            redirectAttributes.addFlashAttribute("message", "로그인이 필요합니다.");
            redirectAttributes.addFlashAttribute("messageType", "error");
            return "redirect:/login";
        }

        Long studentId = loginUser.getUserId();

        try {
            courseService.registerCourse(studentId, courseId);
            redirectAttributes.addFlashAttribute("message", "수강신청이 완료되었습니다.");
            redirectAttributes.addFlashAttribute("messageType", "success");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("message", e.getMessage());
            redirectAttributes.addFlashAttribute("messageType", "error");
        } catch (Exception e) {
            log.error("수강신청 중 오류", e);
            redirectAttributes.addFlashAttribute("message", "수강신청 처리 중 오류가 발생했습니다.");
            redirectAttributes.addFlashAttribute("messageType", "error");
        }

        return "redirect:/course/register";
    }

    /**
     * 수강취소 처리
     */
    @PostMapping("/cancel")
    public String cancelCourse(@RequestParam("courseId") Long courseId,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            redirectAttributes.addFlashAttribute("message", "로그인이 필요합니다.");
            redirectAttributes.addFlashAttribute("messageType", "error");
            return "redirect:/login";
        }

        Long studentId = loginUser.getUserId();

        try {
            courseService.cancelCourse(studentId, courseId);
            redirectAttributes.addFlashAttribute("message", "수강 취소가 완료되었습니다.");
            redirectAttributes.addFlashAttribute("messageType", "success");
        } catch (Exception e) {
            log.error("수강취소 중 오류", e);
            redirectAttributes.addFlashAttribute("message", "수강취소 처리 중 오류가 발생했습니다.");
            redirectAttributes.addFlashAttribute("messageType", "error");
        }

        return "redirect:/course/my";
    }
}
