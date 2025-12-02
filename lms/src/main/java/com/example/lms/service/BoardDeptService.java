package com.example.lms.service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.lms.dto.BoardDepartment;
import com.example.lms.dto.BoardDepartmentFile;
import com.example.lms.dto.BoardDepartmentForm;
import com.example.lms.mapper.BoardDeptMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class BoardDeptService {
	@Autowired
	BoardDeptMapper boardDeptMapper;
	// 게시물 목록
	public List<BoardDepartment> getDeptBoardList(
			@Param("currentPage") int currentPage
			,@Param("rowPerPage") int rowPerPage
			,@Param("departmentId") int departmentId) {
				
		int startRow = (currentPage-1)*rowPerPage;								 
						
		return boardDeptMapper.selectBoardDeptListRowPerPage(departmentId, startRow, rowPerPage);
	}
	// 게시물 갯수
	public int cntDeptBoardListPage(int departmentId, int rowPerPage) {
		
		return (boardDeptMapper.selectCountBoardDeptList(departmentId)+rowPerPage-1)/rowPerPage;
	}
	// 게시물 추가
	public void addDeptBoard(BoardDepartmentForm bf, String path) {
		BoardDepartment boardDept = new BoardDepartment();
		boardDept.setDepartmentId(bf.getDepartmentId());
		boardDept.setUserId(bf.getUserId());
		boardDept.setCategory(bf.getCategory());
		boardDept.setTitle(bf.getTitle());
		boardDept.setContent(bf.getContent());
		
		int row1 = boardDeptMapper.insertBoardDept(boardDept);
		log.debug("row: " + row1);
		if(row1!=1) {
			throw new RuntimeException("학과 게시판 글등록 실패!");
		}
		
		if(bf.getBoardDeptFile().get(0).getSize() > 0 && !(bf.getBoardDeptFile().get(0).getOriginalFilename().equals(""))) {
			for(MultipartFile mf : bf.getBoardDeptFile()) {
				
				int idx = mf.getOriginalFilename().lastIndexOf(".");
				String extension = mf.getOriginalFilename().substring(idx+1);
				String originName = mf.getOriginalFilename().substring(0, idx);
				String fileName = UUID.randomUUID().toString().replace("-", "");
				
				BoardDepartmentFile boardDeptFile = new BoardDepartmentFile();
				boardDeptFile.setPostId(boardDept.getPostId());
				boardDeptFile.setFileName(fileName);
				boardDeptFile.setOriginName(originName);
				boardDeptFile.setFileExtension(extension);
				boardDeptFile.setFileSize(mf.getSize());
				
				int row2 = boardDeptMapper.insertBoardDeptFile(boardDeptFile);
				
				if(row2!=1) {
					throw new RuntimeException("학과 게시판 파일 DB 업로드 실패!");
				}
				
				try {
					mf.transferTo(new File(path+fileName+"."+extension));
				} catch (Exception e) {
					throw new RuntimeException("학과 게시판 파일 업로드 실패!");
				}								
			}
		}
	}
	
	// 게시물 상세
	public Map<String, Object> getDeptBoardPost(int postId) {
				
		Map<String, Object> bo = boardDeptMapper.selectBaordDeptPost(postId);
		List<BoardDepartmentFile> fl = boardDeptMapper.selectBoardDeptPostFileList(postId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("bo", bo);
		map.put("fl", fl);
		
		log.debug(fl+"");
		log.debug(bo+"");
		
		return map;
	}

	// 게시물 삭제
	public void removeDeptBoardPost(int postId, String path) {
		
		List<BoardDepartmentFile> list = boardDeptMapper.selectBoardDeptPostFileList(postId);
				
		for(BoardDepartmentFile b : list) {
			File file = new File(path + b.getFileName()+"."+b.getFileExtension());
			
			if(file.exists()) {
				boolean deleted = file.delete();
				
				if(!deleted) {						
					throw new RuntimeException("파일 삭제 실패: " + b.getOriginName());
				}
			} else {
				log.debug("파일이 존재하지 않습니다:" + b.getOriginName());
			}					
		}		
		
		boardDeptMapper.deleteBoardDeptPostFile(postId);
		int row = boardDeptMapper.deleteBoardDeptPost(postId);
		if (row != 1) {
			throw new RuntimeException("게시판 DB 삭제 실패:" + postId);
		}
	}
	
	// 게시물 수정(첨부파일 삭제)
	public void removeDeptBoardUploadedFile(int fileId, String path) {
		
		BoardDepartmentFile bf = boardDeptMapper.selectBoardDeptPostFile(fileId);
		File file = new File(path + bf.getFileName()+"."+bf.getFileExtension());
		
		if(file.exists()) {
			boolean deleted = file.delete(); 
			
			if(!deleted) {
				log.debug("파일 삭제 실패");
			}
			
			log.debug("파일 삭제");
			
		} else {
			log.debug("파일이 존재하지 않습니다");
		}
		
		int row1 = boardDeptMapper.deleteBoardDeptUploadedFile(fileId);
		if(row1!=1) {
			throw new RuntimeException("게시판 DB 삭제 실패:" + fileId);
		} else {
			log.debug("게시판 파일 DB 삭제:" + fileId);
		}			
	}
	
	// 게시물 수정(첨부파일 추가)
	public void saveDeptBoardFile(BoardDepartment boardDepartment, List<String> uploadedFileIds, List<String> uploadedFileNames, String path) {
				
		int row1 = boardDeptMapper.updateBaordDeptPost(boardDepartment);
		if(row1 != 1) {
			throw new RuntimeException("학과 게시판 글 수정 실패!");
		}		
		if(uploadedFileIds==null) return;
		for(int i=0; i<uploadedFileIds.size(); i++) {
			String fileName = uploadedFileIds.get(i);
			int idx = uploadedFileNames.get(i).lastIndexOf(".");
			String originName = uploadedFileNames.get(i).substring(0, idx);
			String extension = uploadedFileNames.get(i).substring(idx+1);
			
			
			File tempFile = new File(path+"temp/"+fileName);
			BoardDepartmentFile boardDepartmentFile = new BoardDepartmentFile();
			boardDepartmentFile.setPostId(boardDepartment.getPostId());
			boardDepartmentFile.setFileName(fileName);
			boardDepartmentFile.setOriginName(originName);
			boardDepartmentFile.setFileExtension(extension);
			boardDepartmentFile.setFileSize(tempFile.length());
			
			int row2 = boardDeptMapper.insertBoardDeptFile(boardDepartmentFile);
			
			if(row2!=1) {
				throw new RuntimeException("학과 게시판 파일 DB 업로드 실패!");
			}
									
			File file = new File(path + fileName + "." + extension);
			
			try {
				tempFile.renameTo(file);
			} catch (Exception e) {
				throw new RuntimeException("파일 전환 실패");
			}			
		}							
	}		
	
	// 파일 임시저장
	public String saveTempFile(MultipartFile file, String path) {
		
		String tempFileId = UUID.randomUUID().toString().replace("-", "");				
		
		try {
			file.transferTo(new File(path + "temp/" + tempFileId));
		} catch(Exception e) {
			throw new RuntimeException("파일 임시저장 실패!");
		}
						
		return tempFileId;
	}
	
	// 임시파일 삭제
	public void deleteTempFile(String tempFileId, String path) {
		File file = new File(path + "temp/" + tempFileId);
		
		if(file.exists()) {
			boolean deleted = file.delete();
			
			if(!deleted) {
				log.debug("임시파일 삭제 실패");
			}
		} else {
			log.debug("임시파일이 존재하지 않습니다");
		}
	}	
}
