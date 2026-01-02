import 'dart:io';
import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'openai_service.dart';

class VideoAnalysisService {
  final OpenAIService openAIService;

  VideoAnalysisService({required this.openAIService});

  Future<int?> analyzeVideoProductivity(String videoPath) async {
    try {
      // Extract frames from video
      final frames = await _extractVideoFrames(videoPath);
      if (frames.isEmpty) {
        return null;
      }

      // Analyze frames with OpenAI
      return await openAIService.analyzeVideoProductivity(frames);
    } catch (e) {
      print('Error in video analysis: $e');
      return null;
    }
  }

  Future<List<String>> _extractVideoFrames(String videoPath) async {
    final List<String> frameBase64List = [];
    
    try {
      // Extract frames at different timestamps (0%, 33%, 66% of video duration)
      final tempDir = await getTemporaryDirectory();
      
      for (int i = 0; i < 3; i++) {
        try {
          final thumbnailData = await VideoThumbnail.thumbnailData(
            video: videoPath,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 512,
            quality: 75,
            timeMs: i * 1000, // Sample at 0s, 1s, 2s (will be adjusted based on duration)
          );

          if (thumbnailData != null) {
            final base64String = base64Encode(thumbnailData);
            frameBase64List.add(base64String);
          }
        } catch (e) {
          print('Error extracting frame $i: $e');
        }
      }

      // If we didn't get frames with time-based extraction, try getting thumbnail
      if (frameBase64List.isEmpty) {
        final thumbnailData = await VideoThumbnail.thumbnailData(
          video: videoPath,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 512,
          quality: 75,
        );

        if (thumbnailData != null) {
          final base64String = base64Encode(thumbnailData);
          frameBase64List.add(base64String);
        }
      }
    } catch (e) {
      print('Error extracting video frames: $e');
    }

    return frameBase64List;
  }
}

