# Future Implementation Notes

This document outlines suggested interfaces and structure for future AI analysis and scoring implementation.

## Suggested Interface Structure

### 1. VideoAIAnalyzer Interface

**Purpose**: Abstract AI video analysis to allow plugging in different providers (OpenAI, Anthropic, etc.)

**Suggested Location**: `com.motivation.service.ai.VideoAIAnalyzer`

```java
public interface VideoAIAnalyzer {
    /**
     * Analyzes a video file and returns raw analysis data.
     * 
     * @param videoPath Path to the video file to analyze
     * @return AnalysisResult containing raw AI analysis data
     * @throws AnalysisException if analysis fails
     */
    AnalysisResult analyzeVideo(Path videoPath) throws AnalysisException;
}
```

**Implementation Examples**:
- `OpenAIVideoAnalyzer` - Uses OpenAI Vision API
- `AnthropicVideoAnalyzer` - Uses Anthropic Claude
- `MockVideoAnalyzer` - For testing

### 2. ProductivityScorer Interface

**Purpose**: Abstract scoring logic to allow different scoring algorithms

**Suggested Location**: `com.motivation.service.scoring.ProductivityScorer`

```java
public interface ProductivityScorer {
    /**
     * Calculates a productivity score from AI analysis results.
     * 
     * @param analysisResult Raw analysis data from AI analyzer
     * @return ProductivityScore containing score (0-100) and breakdown
     */
    ProductivityScore calculateScore(AnalysisResult analysisResult);
}
```

**Implementation Examples**:
- `DefaultProductivityScorer` - Standard scoring algorithm
- `CustomProductivityScorer` - Customizable scoring weights
- `MLProductivityScorer` - Machine learning-based scoring

### 3. AnalysisResult Model

**Suggested Location**: `com.motivation.model.AnalysisResult`

Contains raw AI analysis data (transcriptions, frame analysis, metadata, etc.)

### 4. ProductivityScore Model

**Suggested Location**: `com.motivation.model.ProductivityScore`

Contains:
- Overall score (int, 0-100)
- Score breakdown (Map<String, Double>)
- Confidence level
- Timestamp

## Implementation Flow

When implementing AI analysis:

1. **VideoAnalysisService.analyzeVideo()** will:
   - Retrieve video file using `VideoService.getVideoPath()`
   - Call `VideoAIAnalyzer.analyzeVideo()` to get raw analysis
   - Call `ProductivityScorer.calculateScore()` to get productivity score
   - Build and return `AnalysisResponse` with results

2. **Dependency Injection**:
   - Use Spring `@Qualifier` to inject specific implementations
   - Allow switching AI providers via configuration

3. **Error Handling**:
   - Create custom exceptions: `AnalysisException`, `ScoringException`
   - Handle gracefully in controller layer

## File Organization

```
com.motivation/
├── controller/          # REST endpoints (DONE)
├── service/            # Business logic
│   ├── VideoService.java              # File operations (DONE)
│   ├── VideoAnalysisService.java      # Orchestration (DONE - placeholder)
│   ├── ai/                            # AI analysis implementations (FUTURE)
│   │   ├── VideoAIAnalyzer.java       # Interface
│   │   ├── OpenAIVideoAnalyzer.java   # OpenAI implementation
│   │   └── ...
│   └── scoring/                       # Scoring implementations (FUTURE)
│       ├── ProductivityScorer.java    # Interface
│       ├── DefaultProductivityScorer.java
│       └── ...
├── model/
│   ├── dto/                           # Request/Response DTOs (DONE)
│   ├── AnalysisResult.java            # Raw AI analysis data (FUTURE)
│   └── ProductivityScore.java        # Score model (FUTURE)
└── exception/                         # Custom exceptions (FUTURE)
    ├── AnalysisException.java
    └── ScoringException.java
```

