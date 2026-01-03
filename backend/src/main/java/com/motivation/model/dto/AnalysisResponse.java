package com.motivation.model.dto;

/**
 * Response DTO for video analysis operations.
 */
public class AnalysisResponse {
    private String status;
    private String message;
    private String videoReference;

    public AnalysisResponse() {
    }

    public AnalysisResponse(String status, String message, String videoReference) {
        this.status = status;
        this.message = message;
        this.videoReference = videoReference;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getVideoReference() {
        return videoReference;
    }

    public void setVideoReference(String videoReference) {
        this.videoReference = videoReference;
    }
}

