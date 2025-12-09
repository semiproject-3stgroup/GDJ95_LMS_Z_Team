package com.example.lms.service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.CourseRegistrationSetting;
import com.example.lms.mapper.CourseRegistrationSettingMapper;

import lombok.Data;

@Service
public class CourseRegistrationSettingService {

    @Autowired
    private CourseRegistrationSettingMapper settingMapper;

    /**
     * 수강신청/취소 상태 공통 DTO
     */
    @Data
    public static class RegistrationStatus {
        private boolean settingExists;               // 해당 학기 설정 존재 여부
        private boolean allowed;                     // 지금 허용되는지 여부 (신청/취소 공통)
        private boolean manualOpen;                  // 수동 항상 열기 여부
        private CourseRegistrationSetting setting;   // 원본 설정
    }

    /**
     * 수강신청 가능 여부 + 상태 정보
     */
    public RegistrationStatus getRegisterStatus(Integer year, String semester) {
        RegistrationStatus status = new RegistrationStatus();

        CourseRegistrationSetting setting =
                settingMapper.selectByYearAndSemester(year, semester);

        status.setSetting(setting);
        status.setSettingExists(setting != null);

        // 설정이 없으면 제약 없는 상태로 간주 
        if (setting == null) {
            status.setAllowed(true);
            status.setManualOpen(false);
            return status;
        }

        boolean manual = "Y".equalsIgnoreCase(setting.getManualOpenYn());
        status.setManualOpen(manual);

        if (manual) {
            status.setAllowed(true);
        } else {
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime start = setting.getRegisterStart();
            LocalDateTime end   = setting.getRegisterEnd();

            // 기간 미설정이면 제한 없음
            if (start == null || end == null) {
                status.setAllowed(true);
            } else {
                status.setAllowed(!now.isBefore(start) && !now.isAfter(end));
            }
        }

        return status;
    }

    /**
     * 수강취소 가능 여부 + 상태 정보
     */
    public RegistrationStatus getCancelStatus(Integer year, String semester) {
        RegistrationStatus status = new RegistrationStatus();

        CourseRegistrationSetting setting =
                settingMapper.selectByYearAndSemester(year, semester);

        status.setSetting(setting);
        status.setSettingExists(setting != null);

        if (setting == null) {
            status.setAllowed(true);
            status.setManualOpen(false);
            return status;
        }

        boolean manual = "Y".equalsIgnoreCase(setting.getManualOpenYn());
        status.setManualOpen(manual);

        if (manual) {
            status.setAllowed(true);
        } else {
            LocalDateTime now = LocalDateTime.now();

            // cancel_end 가 없으면 취소는 기간 제한 없음
            if (setting.getCancelEnd() == null) {
                status.setAllowed(true);
            } else {
                status.setAllowed(!now.isAfter(setting.getCancelEnd()));
            }
        }

        return status;
    }

    // 기존 서비스에서 쓰는 canRegister / canCancel 편의 메서드
    public boolean canRegister(Integer year, String semester) {
        return getRegisterStatus(year, semester).isAllowed();
    }

    public boolean canCancel(Integer year, String semester) {
        return getCancelStatus(year, semester).isAllowed();
    }
}
