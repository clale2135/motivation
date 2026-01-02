package com.motivation.controller;

import com.motivation.model.dto.AnalysisRequest;
import com.motivation.model.dto.AnalysisResponse;
import com.motivation.model.dto.ErrorResponse;
import com.motivation.model.dto.VideoUploadResponse;
import com.motivation.service.VideoAnalysisService;
import com.motivation.service.VideoService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

/**
 * REST Controller for video upload and analysis endpoints.
 * 
 * API Endpoints:
 * - GET  /api/health - Health check
 * - POST /api/upload - Upload video file
 * - POST /api/analyze - Analyze video for productivity metrics
 */
@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class VideoController {

    @Autowired
    private VideoService videoService;

    @Autowired
    private VideoAnalysisService videoAnalysisService;

    /**
     * Health check endpoint to verify API is running.
     */
    @GetMapping("/health")
    public ResponseEntity<VideoUploadResponse> healthCheck() {
        return ResponseEntity.ok(
            new VideoUploadResponse("ok", null)
        );
    }

    /**
     * Uploads a video file to the server.
     * 
     * @param file MultipartFile containing the video
     * @return VideoUploadResponse with upload status and generated filename
     */
    @PostMapping("/upload")
    public ResponseEntity<?> uploadVideo(@RequestParam("video") MultipartFile file) {
        try {
            if (file.isEmpty()) {
                return ResponseEntity.badRequest()
                    .body(new ErrorResponse("validation_error", "No video file provided"));
            }

            String filename = videoService.saveVideo(file);
            
            return ResponseEntity.ok(
                new VideoUploadResponse("Video uploaded successfully", filename)
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(new ErrorResponse("upload_error", e.getMessage()));
        }
    }

    /**
     * Analyzes a video for productivity metrics.
     * 
     * Accepts either filename (for uploaded videos) or videoPath.
     * 
     * @param request AnalysisRequest containing video reference
     * @return AnalysisResponse with analysis status and results
     */
    @PostMapping("/analyze")
    public ResponseEntity<?> analyzeVideo(@Valid @RequestBody AnalysisRequest request) {
        try {
            String videoReference = request.getVideoReference();
            
            if (videoReference == null || videoReference.isEmpty()) {
                return ResponseEntity.badRequest()
                    .body(new ErrorResponse("validation_error", 
                        "Either 'filename' or 'videoPath' must be provided"));
            }

            AnalysisResponse response = videoAnalysisService.analyzeVideo(videoReference);
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(new ErrorResponse("analysis_error", e.getMessage()));
        }
    }
}

