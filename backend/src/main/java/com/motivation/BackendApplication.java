package com.motivation;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Main Spring Boot application entry point.
 * 
 * Project Structure:
 * - controller/ : REST API endpoints
 * - service/    : Business logic layer
 * - model/dto/  : Data Transfer Objects for requests/responses
 */
@SpringBootApplication
public class BackendApplication {
    public static void main(String[] args) {
        SpringApplication.run(BackendApplication.class, args);
    }
}

