# Study Video Upload App

A Flutter app for uploading study videos.

## Setup

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Update the upload endpoint in `lib/services/video_service.dart`:
   - Replace `YOUR_UPLOAD_ENDPOINT_HERE` with your actual backend URL

3. Run the app:
```bash
flutter run
```

## Features

- Record videos using device camera
- Select videos from gallery
- Preview videos before uploading
- Upload videos to backend server

## iOS Permissions

The app requires the following permissions (already configured in Info.plist):
- Camera access
- Microphone access
- Photo library access

