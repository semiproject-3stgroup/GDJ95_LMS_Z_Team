package com.example.lms.controller;

import java.time.format.DateTimeFormatter;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.lms.dto.BoardNotice;
import com.example.lms.dto.User;
import com.example.lms.service.BoardNoticeService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/notice")
public class BoardNoticeController {

    @Autowired
    private BoardNoticeService boardNoticeService;

    @GetMapping("/list")
    public String list(
            @RequestParam(name = "page", defaultValue = "1") int currentPage,
            @RequestParam(required = false) String searchType,
            @RequestParam(required = false) String searchWord,
            Model model) {

        Map<String, Object> result = boardNoticeService.getNoticeList(currentPage, searchType, searchWord);

        model.addAttribute("noticeList", result.get("list"));
        model.addAttribute("currentPage", result.get("currentPage"));
        model.addAttribute("lastPage", result.get("lastPage"));
        model.addAttribute("startPage", result.get("startPage"));
        model.addAttribute("endPage", result.get("endPage"));
        model.addAttribute("searchType", searchType);
        model.addAttribute("searchWord", searchWord);

        return "notice/list";
    }
    
    @GetMapping("/detail")
    public String detail(@RequestParam("noticeId") Long noticeId,
			            @RequestParam(name = "page", defaultValue = "1") int page,
			            @RequestParam(required = false) String searchType,
			            @RequestParam(required = false) String searchWord,
			            Model model) {

        BoardNotice notice = boardNoticeService.getNoticeDetail(noticeId);

        model.addAttribute("notice", notice);
        model.addAttribute("currentPage", page);      // 페이지 번호 유지
        model.addAttribute("searchType", searchType); // 검색 조건 유지
        model.addAttribute("searchWord", searchWord);

        return "notice/detail";
    }
    
    
    /**
     * 공지 등록 폼 이동
     */
    @GetMapping("/add")
    public String addNoticeForm() {
        return "notice/add";   // /WEB-INF/views/notice/add.jsp
    }
    
    /**
     * 공지 등록 액션
     * - 로그인된 유저(session.loginUser)의 userId로 공지 작성
     * - 등록 후 목록으로 redirect
     */
    @PostMapping("/add")
    public String addNotice(BoardNotice notice,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {

        // 세션에서 로그인 유저 정보 꺼내기
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        // 로그인 유저 userId 사용
        Long loginUserId = loginUser.getUserId();

        boardNoticeService.addNotice(notice, loginUserId);

        redirectAttributes.addFlashAttribute("msg", "공지사항이 등록되었습니다.");

        return "redirect:/notice/list";
    }
    
    /**
     * 공지 수정 폼
     * - noticeId로 1건 조회 (조회수 증가 없음)
     * - datetime-local 입력 형식에 맞게 날짜 문자열도 모델에 전달
     */
    @GetMapping("/edit")
    public String editNoticeForm(@RequestParam("noticeId") Long noticeId,
                                 Model model,
                                 HttpSession session) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        BoardNotice notice = boardNoticeService.getNoticeOne(noticeId);
        if (notice == null) {
            return "redirect:/notice/list";
        }

        // 작성자 본인만 수정 폼 진입 가능
        if (!loginUser.getUserId().equals(notice.getUserId())) {
            return "redirect:/notice/detail?noticeId=" + noticeId;
        }

        model.addAttribute("notice", notice);

        // datetime-local 용 문자열 포맷
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        if (notice.getPinStart() != null) {
            model.addAttribute("pinStartStr", notice.getPinStart().format(dtf));
        }
        if (notice.getPinEnd() != null) {
            model.addAttribute("pinEndStr", notice.getPinEnd().format(dtf));
        }

        return "notice/edit";   // /WEB-INF/views/notice/edit.jsp
    }

    /**
     * 공지 수정 액션
     * - 로그인 여부 확인 후 수정
     * - 수정 완료 후 해당 공지 상세 페이지로 redirect
     */
    @PostMapping("/edit")
    public String editNotice(BoardNotice notice,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        // DB에서 원본 글 다시 조회
        BoardNotice dbNotice = boardNoticeService.getNoticeOne(notice.getNoticeId());
        if (dbNotice == null) {
            return "redirect:/notice/list";
        }

        // 작성자 본인이 아니면 수정 불가
        if (!loginUser.getUserId().equals(dbNotice.getUserId())) {
            return "redirect:/notice/detail?noticeId=" + notice.getNoticeId();
        }

        boardNoticeService.modifyNotice(notice);

        redirectAttributes.addFlashAttribute("msg", "공지사항이 수정되었습니다.");

        return "redirect:/notice/detail?noticeId=" + notice.getNoticeId();
    }
    
    /**
     * 공지 삭제 액션
     * - 로그인 유저가 있는 경우에만 삭제 가능
     * - 삭제 후 목록 페이지로 redirect
     * - 삭제 후에도 원래 보고 있던 페이지(page) 번호 유지
     */
    @PostMapping("/delete")
    public String deleteNotice(@RequestParam("noticeId") Long noticeId,
                               @RequestParam(name = "page", defaultValue = "1") int page,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        BoardNotice notice = boardNoticeService.getNoticeOne(noticeId);
        if (notice == null) {
            return "redirect:/notice/list?page=" + page;
        }

        // 작성자 본인만 삭제 가능
        if (!loginUser.getUserId().equals(notice.getUserId())) {
            return "redirect:/notice/detail?noticeId=" + noticeId + "&page=" + page;
        }

        boardNoticeService.removeNotice(noticeId);

        redirectAttributes.addFlashAttribute("msg", "공지사항이 삭제되었습니다.");

        return "redirect:/notice/list?page=" + page;
    }
    
}

    
