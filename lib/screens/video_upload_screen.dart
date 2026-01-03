import 'package:flutter/material.dart';
import '../services/permission_service.dart';
import '../services/video_service.dart';
import '../services/video_analysis_service.dart';
import '../services/openai_service.dart';
import '../services/config_service.dart';
import '../widgets/video_picker_widget.dart';
import '../widgets/video_preview_widget.dart';
import '../widgets/productivity_score_widget.dart';

class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({super.key});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  String? _videoPath;
  bool _isUploading = false;
  bool _isAnalyzing = false;
  int? _productivityScore;
  final VideoService _videoService = VideoService();
  final PermissionService _permissionService = PermissionService();
  VideoAnalysisService? _analysisService;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    final apiKey = ConfigService.getOpenAIApiKey();
    if (apiKey != null) {
      final openAIService = OpenAIService(apiKey: apiKey);
      _analysisService = VideoAnalysisService(openAIService: openAIService);
    }
  }

  Future<void> _checkPermissions() async {
    await _permissionService.requestPermissions();
  }

  Future<void> _onVideoSelected(String? videoPath) async {
    if (videoPath != null) {
      setState(() {
        _videoPath = videoPath;
        _productivityScore = null;
      });
      _analyzeVideo(videoPath);
    }
  }

  Future<void> _analyzeVideo(String videoPath) async {
    if (_analysisService == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OpenAI API key not configured. Video analysis is disabled.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }
    
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final score = await _analysisService!.analyzeVideoProductivity(videoPath);
      if (mounted) {
        setState(() {
          _productivityScore = score;
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error analyzing video: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _uploadVideo() async {
    if (_videoPath == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final success = await _videoService.uploadVideo(_videoPath!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success 
              ? 'Video uploaded successfully!' 
              : 'Upload failed. Please try again.'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );

        if (success) {
          setState(() {
            _videoPath = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Study Video'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            if (_videoPath != null) ...[
              VideoPreviewWidget(videoPath: _videoPath!),
              const SizedBox(height: 16),
              if (_isAnalyzing)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Analyzing productivity...'),
                      ],
                    ),
                  ),
                )
              else if (_productivityScore != null)
                ProductivityScoreWidget(score: _productivityScore!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isUploading ? null : _uploadVideo,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isUploading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Uploading...'),
                        ],
                      )
                    : const Text('Upload Video'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _isUploading
                    ? null
                    : () {
                        setState(() {
                          _videoPath = null;
                        });
                      },
                child: const Text('Select Different Video'),
              ),
            ] else
              VideoPickerWidget(onVideoSelected: _onVideoSelected),
            ],
          ),
        ),
      ),
    );
  }
}

