package com.example.lms.controller;

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
import com.example.lms.service.CourseService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/course")
public class CourseController {

    @Autowired
    private CourseService courseService;

    /**
     * 수강신청 화면
     * - 신청 가능 강의 목록
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

        // year / semester가 없으면 전체 조회 (Mapper에서 null 허용)
        List<Course> openCourses =
                courseService.getOpenCoursesForRegister(studentId, year, semester);

        model.addAttribute("openCourses", openCourses);
        model.addAttribute("year", year);
        model.addAttribute("semester", semester);

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

        List<Course> myCourses =
                courseService.getMyRegisteredCourses(studentId, year, semester);

        model.addAttribute("myCourses", myCourses);
        model.addAttribute("year", year);
        model.addAttribute("semester", semester);

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
            // 비즈니스 룰 위반(정원, 중복시간, 6과목 초과 등)
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
