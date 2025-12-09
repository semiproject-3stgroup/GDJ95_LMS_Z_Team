package com.example.lms.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.CourseRegistrationSetting;

@Mapper
public interface CourseRegistrationSettingMapper {

    // 학년도/학기로 조회 (course_year, course_semester 기준)
    CourseRegistrationSetting selectByYearAndSemester(
            @Param("year") Integer year,
            @Param("semester") String semester);

    // 현재 시점 기준 수강신청 설정 1건 조회(대시보드용)
    CourseRegistrationSetting selectCurrentSetting();

    // 가장 최근 설정(관리자가 제일 마지막으로 만든 것) 하나 가져오기 (fallback 용)
    CourseRegistrationSetting selectLatest();

    int insertSetting(CourseRegistrationSetting setting);

    int updateSetting(CourseRegistrationSetting setting);

    // 관리자 수동 ON/OFF 전용
    int updateManualOpenFlag(
            @Param("settingId") Long settingId,
            @Param("manualOpenYn") String manualOpenYn);

    // 수강신청 화면용: 설정에 존재하는 학년도 리스트
    List<Integer> selectAvailableYears();

    // 특정 학년에서 사용 중인 학기 리스트 (예: 1학기 / 2학기)
    List<String> selectAvailableSemesters(@Param("year") Integer year);
}
