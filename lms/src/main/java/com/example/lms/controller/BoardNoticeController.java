package com.example.lms.controller;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.lms.dto.BoardNotice;
import com.example.lms.dto.BoardNoticeFile;
import com.example.lms.dto.User;
import com.example.lms.service.BoardNoticeService;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/notice")
public class BoardNoticeController {

    @Autowired
    private BoardNoticeService boardNoticeService;

    // 파일 저장 경로 (Service랑 동일한 설정값)
    @Value("${upload.notice.dir}")
    private String uploadDir;

    /**
     * 공지 목록
     */
    @GetMapping("/list")
    public String list(
            @RequestParam(name = "page", defaultValue = "1") int currentPage,
            @RequestParam(required = false) String searchType,
            @RequestParam(required = false) String searchWord,
            Model model) {

        Map<String, Object> result =
                boardNoticeService.getNoticeList(currentPage, searchType, searchWord);

        model.addAttribute("noticeList", result.get("list"));
        model.addAttribute("currentPage", result.get("currentPage"));
        model.addAttribute("lastPage", result.get("lastPage"));
        model.addAttribute("startPage", result.get("startPage"));
        model.addAttribute("endPage", result.get("endPage"));
        model.addAttribute("searchType", searchType);
        model.addAttribute("searchWord", searchWord);

        return "notice/list";
    }

    /**
     * 공지 상세
     */
    @GetMapping("/detail")
    public String detail(@RequestParam("noticeId") Long noticeId,
                         @RequestParam(name = "page", defaultValue = "1") int page,
                         @RequestParam(required = false) String searchType,
                         @RequestParam(required = false) String searchWord,
                         Model model) {

        // 공지 상세 (조회수 증가 포함)
        BoardNotice notice = boardNoticeService.getNoticeDetail(noticeId);

        // 첨부파일 목록
        List<BoardNoticeFile> fileList = boardNoticeService.getNoticeFileList(noticeId);

        // 모델에 담기
        model.addAttribute("notice", notice);
        model.addAttribute("fileList", fileList);

        model.addAttribute("currentPage", page);
        model.addAttribute("searchType", searchType);
        model.addAttribute("searchWord", searchWord);

        return "notice/detail";
    }

    /**
     * 공지 등록 폼
     */
    @GetMapping("/add")
    public String addNoticeForm() {
        return "notice/add";
    }

    /**
     * 공지 등록 액션
     */
    @PostMapping("/add")
    public String addNotice(BoardNotice notice,
                            HttpSession session,
                            RedirectAttributes redirectAttributes,
                            @RequestParam(name = "files", required = false)
                            List<MultipartFile> files) throws Exception {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        Long loginUserId = loginUser.getUserId();

        // 서비스로 공지 + 파일 업로드 처리
        boardNoticeService.addNotice(notice, loginUserId, files);

        redirectAttributes.addFlashAttribute("msg", "공지사항이 등록되었습니다.");

        return "redirect:/notice/list";
    }

    /**
     * 공지 수정 폼
     */
    @GetMapping("/edit")
    public String editNoticeForm(@RequestParam("noticeId") Long noticeId,
                                 HttpSession session,
                                 Model model,
                                 RedirectAttributes redirectAttributes) {

        // 로그인 체크
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        // 공지 1건 조회
        BoardNotice notice = boardNoticeService.getNoticeOne(noticeId);
        if (notice == null) {
            redirectAttributes.addFlashAttribute("msg", "존재하지 않는 공지입니다.");
            return "redirect:/notice/list";
        }

        // 작성자 본인만 수정 가능
        if (!loginUser.getUserId().equals(notice.getUserId())) {
            redirectAttributes.addFlashAttribute("msg", "본인이 작성한 글만 수정할 수 있습니다.");
            return "redirect:/notice/detail?noticeId=" + noticeId;
        }

        // 기존 첨부파일 목록 조회해서 모델에 담기
        List<BoardNoticeFile> fileList = boardNoticeService.getNoticeFileList(noticeId);
        model.addAttribute("fileList", fileList);

        // 5. 상단 고정 기간을 datetime-local 형식으로 변환
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

        String pinStartStr = "";
        String pinEndStr   = "";

        if (notice.getPinStart() != null) {
            pinStartStr = notice.getPinStart().format(fmt);
        }
        if (notice.getPinEnd() != null) {
            pinEndStr = notice.getPinEnd().format(fmt);
        }

        model.addAttribute("pinStartStr", pinStartStr);
        model.addAttribute("pinEndStr", pinEndStr);

        // 공지 자체도 모델에 담기
        model.addAttribute("notice", notice);

        return "notice/modify";
    }

    /**
     * 공지 수정 액션
     */
    @PostMapping("/edit")
    public String editNotice(BoardNotice notice,
                             @RequestParam(value = "deleteFileIds", required = false) Long[] deleteFileIds,
                             @RequestParam(value = "files", required = false) List<MultipartFile> newFiles,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) throws Exception {

        // 로그인 검사
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        // 원본 글 조회
        BoardNotice dbNotice = boardNoticeService.getNoticeOne(notice.getNoticeId());
        if (dbNotice == null) {
            return "redirect:/notice/list";
        }

        // 작성자 본인 확인
        if (!loginUser.getUserId().equals(dbNotice.getUserId())) {
            return "redirect:/notice/detail?noticeId=" + notice.getNoticeId();
        }

        // 수정 + 파일 삭제 + 새 파일 업로드 처리
        boardNoticeService.modifyNoticeWithFiles(
                notice,
                deleteFileIds,
                newFiles
        );

        redirectAttributes.addFlashAttribute("msg", "공지사항이 수정되었습니다.");

        return "redirect:/notice/detail?noticeId=" + notice.getNoticeId();
    }

    /**
     * 공지 삭제 액션
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

    /**
     * 📎 첨부파일 다운로드
     * /notice/file/download?fileId=10
     */
    @GetMapping("/file/download")
    public void downloadFile(@RequestParam("fileId") Long fileId,
                             HttpServletResponse response) throws IOException {

        // 1) 파일 메타데이터 조회
        BoardNoticeFile file = boardNoticeService.getNoticeFile(fileId);

        if (file == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 2) 실제 파일 객체
        String filePath = uploadDir + File.separator + file.getFileName();
        File realFile = new File(filePath);

        if (!realFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 3) 헤더 설정 (파일명 인코딩 포함)
        String encodedName = URLEncoder.encode(file.getOriginName(), "UTF-8")
                                       .replaceAll("\\+", "%20");

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" + encodedName + "\"");
        response.setHeader("Content-Length", String.valueOf(realFile.length()));

        // 4) 파일 스트림으로 내보내기
        java.nio.file.Files.copy(realFile.toPath(), response.getOutputStream());
        response.flushBuffer();
    }
}
