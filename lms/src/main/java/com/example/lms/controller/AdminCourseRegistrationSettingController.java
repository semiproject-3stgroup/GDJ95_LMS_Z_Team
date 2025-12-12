package com.example.lms.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.lms.dto.CourseRegistrationSetting;
import com.example.lms.mapper.CourseRegistrationSettingMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin/course-register-setting")
public class AdminCourseRegistrationSettingController {

    @Autowired
    private CourseRegistrationSettingMapper settingMapper;

    /**
     * 수강신청 설정 조회/입력 화면
     */
    @GetMapping
    public String showSettingPage(@RequestParam(required = false) Integer year,
                                  @RequestParam(required = false) String semester,
                                  Model model) {
    	
    	model.addAttribute("menu", "adminCourseRegisterSetting");

        log.debug("[AdminCourseRegistrationSetting] GET year={}, semester={}", year, semester);

        CourseRegistrationSetting setting = null;

        if (year != null && semester != null) {
            // 특정 학기 조회
            setting = settingMapper.selectByYearAndSemester(year, semester);
        } else {
            // 파라미터 없으면 가장 최근 설정 하나
            setting = settingMapper.selectLatest();
            if (setting != null) {
                year = setting.getYear();
                semester = setting.getSemester();
            }
        }

        model.addAttribute("year", year);
        model.addAttribute("semester", semester);
        model.addAttribute("setting", setting);

        // /WEB-INF/views/admin/courseRegistrationSetting.jsp
        return "admin/courseRegistrationSetting";
    }

    /**
     * 수강신청 설정 저장(신규 / 수정)
     */
    @PostMapping("/save")
    public String saveSetting(@ModelAttribute CourseRegistrationSetting form,
                              RedirectAttributes rttr) {

        if (form.getYear() == null || form.getSemester() == null) {
            rttr.addFlashAttribute("message", "학년도와 학기를 입력해 주세요.");
            rttr.addFlashAttribute("messageType", "error");
            return "redirect:/admin/course-register-setting";
        }

        // manual_open_yn 방어 로직: Y가 아니면 전부 N 처리
        String manualYn = form.getManualOpenYn();
        if ("Y".equalsIgnoreCase(manualYn)) {
            form.setManualOpenYn("Y");
        } else {
            form.setManualOpenYn("N");
        }

        log.debug("[AdminCourseRegistrationSetting] SAVE form={}", form);

        CourseRegistrationSetting existing =
                settingMapper.selectByYearAndSemester(form.getYear(), form.getSemester());

        if (existing == null) {
            // 신규
            settingMapper.insertSetting(form);
            rttr.addFlashAttribute("message", "수강신청 설정이 등록되었습니다.");
        } else {
            // 수정
            form.setSettingId(existing.getSettingId());
            settingMapper.updateSetting(form);
            rttr.addFlashAttribute("message", "수강신청 설정이 수정되었습니다.");
        }
        rttr.addFlashAttribute("messageType", "success");

        // 한글 학기 파라미터 인코딩
        String encodedSemester = URLEncoder.encode(
                form.getSemester(), StandardCharsets.UTF_8);

        return "redirect:/admin/course-register-setting?year="
                + form.getYear()
                + "&semester="
                + encodedSemester;
    }

    /**
     * 수동 열기 플래그만 ON/OFF
     */
    @PostMapping("/manual-open")
    public String changeManualOpen(@RequestParam Long settingId,
                                   @RequestParam Integer year,
                                   @RequestParam String semester,
                                   @RequestParam(defaultValue = "N") String manualOpenYn,
                                   RedirectAttributes rttr) {

        // 방어: Y만 인정, 나머지는 N
        if (!"Y".equalsIgnoreCase(manualOpenYn)) {
            manualOpenYn = "N";
        } else {
            manualOpenYn = "Y";
        }

        log.debug("[AdminCourseRegistrationSetting] MANUAL OPEN settingId={}, yn={}",
                settingId, manualOpenYn);

        settingMapper.updateManualOpenFlag(settingId, manualOpenYn);

        rttr.addFlashAttribute("message", "수동 열기 설정이 변경되었습니다.");
        rttr.addFlashAttribute("messageType", "success");

        String encodedSemester = URLEncoder.encode(
                semester, StandardCharsets.UTF_8);

        return "redirect:/admin/course-register-setting?year="
                + year
                + "&semester="
                + encodedSemester;
    }
}
