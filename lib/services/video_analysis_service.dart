import 'dart:io';
import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'openai_service.dart';

class VideoAnalysisService {
  final OpenAIService openAIService;

  VideoAnalysisService({required this.openAIService});

  Future<int?> analyzeVideoProductivity(String videoPath) async {
    try {
      print('Starting video analysis for: $videoPath');
      // Extract frames from video
      final frames = await _extractVideoFrames(videoPath);
      print('Extracted ${frames.length} frames from video');
      if (frames.isEmpty) {
        print('No frames extracted from video');
        return null;
      }

      // Analyze frames with OpenAI
      print('Sending frames to OpenAI for analysis...');
      final score = await openAIService.analyzeVideoProductivity(frames);
      print('Received productivity score: $score');
      return score;
    } catch (e, stackTrace) {
      print('Error in video analysis: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<List<String>> _extractVideoFrames(String videoPath) async {
    final List<String> frameBase64List = [];
    
    try {
      // Get video duration first
      final videoDuration = await _getVideoDuration(videoPath);
      print('Video duration: ${videoDuration.inSeconds} seconds');
      
      // Calculate timestamps at 0%, 33%, and 66% of video duration
      final timestamps = [
        0, // Start
        (videoDuration.inMilliseconds * 0.33).round(), // 33%
        (videoDuration.inMilliseconds * 0.66).round(), // 66%
      ];
      
      print('Extracting frames at timestamps: $timestamps ms');
      
      // Extract frames at calculated timestamps
      for (final timeMs in timestamps) {
        try {
          final thumbnailData = await VideoThumbnail.thumbnailData(
            video: videoPath,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 512,
            quality: 75,
            timeMs: timeMs,
          );

          if (thumbnailData != null) {
            final base64String = base64Encode(thumbnailData);
            frameBase64List.add(base64String);
            print('Successfully extracted frame at ${timeMs}ms');
          } else {
            print('No thumbnail data at ${timeMs}ms');
          }
        } catch (e) {
          print('Error extracting frame at ${timeMs}ms: $e');
        }
      }

      // Fallback: If we didn't get frames with time-based extraction, try getting default thumbnail
      if (frameBase64List.isEmpty) {
        print('No frames extracted, trying default thumbnail...');
        final thumbnailData = await VideoThumbnail.thumbnailData(
          video: videoPath,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 512,
          quality: 75,
        );

        if (thumbnailData != null) {
          final base64String = base64Encode(thumbnailData);
          frameBase64List.add(base64String);
          print('Extracted default thumbnail');
        }
      }
    } catch (e) {
      print('Error extracting video frames: $e');
    }

    return frameBase64List;
  }

  /// Get the duration of the video file
  Future<Duration> _getVideoDuration(String videoPath) async {
    try {
      final controller = VideoPlayerController.file(File(videoPath));
      await controller.initialize();
      final duration = controller.value.duration;
      await controller.dispose();
      return duration;
    } catch (e) {
      print('Error getting video duration: $e');
      // Return a default duration if we can't get it (fallback to old behavior)
      return const Duration(seconds: 2);
    }
  }
}

