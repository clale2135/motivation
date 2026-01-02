import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoService {
  // Replace with your actual upload endpoint
  static const String uploadUrl = 'YOUR_UPLOAD_ENDPOINT_HERE';

  Future<bool> uploadVideo(String videoPath) async {
    try {
      final file = File(videoPath);
      if (!await file.exists()) {
        return false;
      }

      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.files.add(
        await http.MultipartFile.fromPath('video', videoPath),
      );

      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      print('Upload error: $e');
      return false;
    }
  }
}

