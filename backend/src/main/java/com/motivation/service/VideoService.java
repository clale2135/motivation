package com.motivation.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 * Service layer for video file operations.
 * Handles video file storage and retrieval.
 */
@Service
public class VideoService {

    @Value("${app.upload.dir:uploads}")
    private String uploadDir;

    /**
     * Saves an uploaded video file to disk.
     * 
     * @param file MultipartFile from the upload request
     * @return Unique filename generated for the stored video
     * @throws IOException if file cannot be saved
     */
    public String saveVideo(MultipartFile file) throws IOException {
        // Create upload directory if it doesn't exist
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Generate unique filename to prevent collisions
        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        String filename = UUID.randomUUID().toString() + extension;

        // Save file to disk
        Path filePath = uploadPath.resolve(filename);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return filename;
    }

    // Method to retrieve video path by filename - uncomment and implement when needed
    // public Path getVideoPath(String filename) throws IOException {
    //     Path filePath = Paths.get(uploadDir).resolve(filename);
    //     if (!Files.exists(filePath)) {
    //         throw new IOException("Video file not found: " + filename);
    //     }
    //     return filePath;
    // }
}

