# Backend API

Spring Boot Java backend for handling video uploads and OpenAI analysis.

## Prerequisites

- Java 17 or higher
- Maven 3.6+

## Setup

1. Install dependencies:
```bash
mvn clean install
```

2. Set environment variable for OpenAI API key:
```bash
export OPENAI_API_KEY=your_actual_api_key_here
```

Or create `application-local.properties`:
```properties
openai.api.key=your_actual_api_key_here
```

3. Run the server:
```bash
mvn spring-boot:run
```

Or build and run:
```bash
mvn clean package
java -jar target/backend-1.0.0.jar
```

The API will run on `http://localhost:5000`

## Endpoints

- `GET /api/health` - Health check
- `POST /api/upload` - Upload video file (multipart/form-data, field name: "video")
- `POST /api/analyze` - Analyze video (to be implemented)

## Project Structure

```
src/main/java/com/motivation/
├── BackendApplication.java    # Main Spring Boot application
├── controller/
│   └── VideoController.java   # REST API endpoints
└── service/
    └── VideoService.java      # Business logic for video handling
```

