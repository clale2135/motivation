import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VideoPickerWidget extends StatelessWidget {
  final Function(String?) onVideoSelected;
  final ImagePicker _picker = ImagePicker();

  VideoPickerWidget({super.key, required this.onVideoSelected});

  Future<void> _pickVideoFromGallery() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      if (video != null) {
        onVideoSelected(video.path);
      }
    } catch (e) {
      print('Error picking video from gallery: $e');
    }
  }

  Future<void> _recordVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
      );
      if (video != null) {
        onVideoSelected(video.path);
      }
    } catch (e) {
      print('Error recording video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.video_library,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 24),
          const Text(
            'Upload a video of you studying',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _recordVideo,
              icon: const Icon(Icons.videocam),
              label: const Text('Record Video'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _pickVideoFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text('Choose from Gallery'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

