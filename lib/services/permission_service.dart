import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();
    final photosStatus = await Permission.photos.request();

    return cameraStatus.isGranted &&
        microphoneStatus.isGranted &&
        photosStatus.isGranted;
  }

  Future<bool> checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final microphoneStatus = await Permission.microphone.status;
    final photosStatus = await Permission.photos.status;

    return cameraStatus.isGranted &&
        microphoneStatus.isGranted &&
        photosStatus.isGranted;
  }
}

