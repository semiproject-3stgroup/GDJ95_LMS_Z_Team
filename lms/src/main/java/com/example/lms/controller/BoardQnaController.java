package com.example.lms.controller;

import com.example.lms.dto.BoardQna;
import com.example.lms.dto.BoardQnaWriteRequest;
import com.example.lms.dto.Course;
import com.example.lms.dto.User;
import com.example.lms.service.BoardQnaService;
import com.example.lms.service.CourseService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequestMapping("/qna")
public class BoardQnaController {

    private final BoardQnaService boardQnaService;
    private final CourseService courseService;

    @Autowired
    public BoardQnaController(BoardQnaService boardQnaService, CourseService courseService) {
        this.boardQnaService = boardQnaService;
        this.courseService = courseService;
    }

    @GetMapping("/list/{courseId}")
    public String qnaList(
        @PathVariable("courseId") Long courseId, 
        @RequestParam(value = "searchKeyword", required = false, defaultValue = "") String searchKeyword, 
        @RequestParam(value = "page", defaultValue = "1") int page,
        HttpSession session, Model model) {
        
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login"; 
        }

        // 1. 수강 중인 강의 목록 조회 (사이드바 메뉴 출력을 위해 필요)
        List<Course> myCourses = courseService.getMyCourses(loginUser.getUserId()); 
        
        // 2. 페이징 설정 (페이지당 10개)
        int pageSize = 10;
        List<BoardQna> qnaList = boardQnaService.getBoardQnaList(courseId, searchKeyword, page, pageSize);
        int totalCount = boardQnaService.getBoardQnaCount(courseId, searchKeyword);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        
        // 3. 페이지 블록 계산 (5개씩)
        int pageBlockSize = 5;
        int startPage = ((page - 1) / pageBlockSize) * pageBlockSize + 1;
        int endPage = Math.min(startPage + pageBlockSize - 1, totalPages);
        
        // 4. Model에 데이터 추가
        model.addAttribute("courseId", courseId);
        model.addAttribute("qnaList", qnaList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("myCourses", myCourses);

        return "qnaList";
    }

    @GetMapping("/one/{courseId}/{postId}")
    public String qnaOne(@PathVariable("courseId") Long courseId,
                         @PathVariable("postId") Long postId,
                         HttpSession session, Model model) {
        
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login"; 
        }

        // 1. 게시글 상세 정보 조회 (조회수 증가 포함)
        BoardQna qnaPost = boardQnaService.getBoardQnaDetail(postId);
        
        // 2. 수강 중인 강의 목록 조회 (사이드바 메뉴 출력을 위해 필요)
        List<Course> myCourses = courseService.getMyCourses(loginUser.getUserId()); 

        // 3. Model에 데이터 추가
        model.addAttribute("courseId", courseId);
        model.addAttribute("qnaPost", qnaPost);
        model.addAttribute("myCourses", myCourses);
        // 현재 로그인한 사용자의 ID를 JSP로 전달 (수정/삭제 버튼 표시를 위함)
        model.addAttribute("currentUserId", loginUser.getUserId());

        return "qnaOne";
    }
    
    @GetMapping("/writeForm/{courseId}")
    public String qnaWriteForm(@PathVariable("courseId") Long courseId, Model model, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login"; 
        }
        
        // 1. 수강 중인 강의 목록 조회 (사이드바 메뉴 출력을 위해 필요)
        List<Course> myCourses = courseService.getMyCourses(loginUser.getUserId()); 

        model.addAttribute("courseId", courseId);
        model.addAttribute("currentUserId", loginUser.getUserId()); // 폼에 숨겨서 전달할 사용자 ID
        model.addAttribute("myCourses", myCourses);
        // 글쓰기 폼에서 바인딩할 빈 DTO 객체 추가
        model.addAttribute("boardQnaWriteRequest", new BoardQnaWriteRequest()); 
        
        return "qnaWrite"; 
    }

    @PostMapping("/write/{courseId}")
    public String qnaWrite(@PathVariable("courseId") Long courseId, 
                           @ModelAttribute BoardQnaWriteRequest requestDto,
                           HttpSession session) {
        
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login"; 
        }

        // 1. DTO에 PathVariable courseId를 설정
        requestDto.setCourseId(courseId);
        // 2. 실제 사용자 ID를 설정
        requestDto.setUserId(loginUser.getUserId());
        
        // 3. 게시글 저장 서비스 호출 (저장 후 requestDto에 postId가 채워짐)
        boardQnaService.saveQnaPost(requestDto);
        
        // 4. 저장된 게시글의 상세 페이지로 리다이렉트
        return "redirect:/qna/one/" + courseId + "/" + requestDto.getPostId();
    }
    
    /**
     * ✅ [추가] QnA 게시글 수정 폼 요청 (GET)
     */
    @GetMapping("/modifyForm/{courseId}/{postId}")
    public String qnaModifyForm(@PathVariable("courseId") Long courseId,
                                @PathVariable("postId") Long postId,
                                HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }
        
        // 1. 게시글 상세 정보 조회
        BoardQna qnaPost = boardQnaService.getBoardQnaDetail(postId); 
        
        // 2. 작성자 권한 확인
        if (qnaPost == null || !qnaPost.getUserId().equals(loginUser.getUserId())) {
            // 게시글이 없거나, 작성자가 아니면 상세 페이지로 리다이렉트 (에러 메시지 포함)
            return "redirect:/qna/one/" + courseId + "/" + postId + "?error=unauthorized";
        }

        // 3. 수강 중인 강의 목록 조회
        List<Course> myCourses = courseService.getMyCourses(loginUser.getUserId()); 

        // 4. Model에 데이터 추가
        model.addAttribute("courseId", courseId);
        model.addAttribute("qnaPost", qnaPost);
        model.addAttribute("currentUserId", loginUser.getUserId());
        model.addAttribute("myCourses", myCourses);

        return "qnaModify";
    }

    @PostMapping("/modify/{courseId}/{postId}")
    public String qnaModify(@PathVariable("courseId") Long courseId,
                             @PathVariable("postId") Long postId,
                             @ModelAttribute BoardQna qna, // 수정할 데이터를 BoardQna로 받음 (title, content, userId)
                             HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }
        
        // BoardQna DTO에 PathVariable 값과 세션 사용자 ID 설정
        qna.setPostId(postId);
        // 수정 시도하는 사용자의 ID를 DTO에 설정 (Mapper에서 WHERE 조건으로 사용하여 보안 강화)
        qna.setUserId(loginUser.getUserId()); 
        
        // Service 호출
        int result = boardQnaService.updateBoardQna(qna);
        
        if (result > 0) {
            // 수정 성공 시 상세 페이지로 리다이렉트
            return "redirect:/qna/one/" + courseId + "/" + postId + "?message=modifySuccess";
        } else {
            // 수정 실패 처리 (작성자 불일치 또는 DB 오류)
            return "redirect:/qna/one/" + courseId + "/" + postId + "?error=modifyFailed";
        }
    }

    @PostMapping("/delete/{courseId}/{postId}")
    public String qnaDelete(@PathVariable("courseId") Long courseId,
                            @PathVariable("postId") Long postId,
                            HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        // 1. 게시글 작성자 권한 확인 (삭제 전 보안을 위해 Controller에서 한 번 더 체크)
        // 상세 조회를 통해 작성자 ID를 가져옴.
        BoardQna qnaPost = boardQnaService.getBoardQnaDetail(postId); 
        
        if (qnaPost == null || !qnaPost.getUserId().equals(loginUser.getUserId())) {
            // 게시글이 없거나, 작성자가 아니면 접근 거부
            return "redirect:/qna/one/" + courseId + "/" + postId + "?error=unauthorized";
        }
        
        // 2. 삭제 서비스 호출
        int result = boardQnaService.deleteBoardQna(postId);
        
        if (result > 0) {
            // 삭제 성공 시 목록 페이지로 리다이렉트
            return "redirect:/qna/list/" + courseId + "?message=deleteSuccess";
        } else {
            // 삭제 실패 처리
            return "redirect:/qna/one/" + courseId + "/" + postId + "?error=deleteFailed";
        }
    }
}