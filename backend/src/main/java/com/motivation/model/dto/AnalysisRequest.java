package com.motivation.model.dto;

/**
 * Request DTO for video analysis operations.
 * Accepts either a filename (for uploaded videos) or a video path reference.
 */
public class AnalysisRequest {
    private String filename;
    private String videoPath;

    public AnalysisRequest() {
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public String getVideoPath() {
        return videoPath;
    }

    public void setVideoPath(String videoPath) {
        this.videoPath = videoPath;
    }

    /**
     * Returns the video reference (filename takes precedence over videoPath).
     * This is the identifier that will be used to locate the video for analysis.
     */
    public String getVideoReference() {
        return filename != null && !filename.isEmpty() ? filename : videoPath;
    }
}

