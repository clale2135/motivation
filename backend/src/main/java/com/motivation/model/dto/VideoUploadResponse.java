package com.motivation.model.dto;

/**
 * Response DTO for video upload operations.
 * Contains metadata about the uploaded video file.
 */
public class VideoUploadResponse {
    private String message;
    private String filename;

    public VideoUploadResponse() {
    }

    public VideoUploadResponse(String message, String filename) {
        this.message = message;
        this.filename = filename;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }
}

