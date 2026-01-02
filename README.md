# Study Video Upload App

A Flutter app for uploading study videos.

## Setup

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. **Configure API Keys:**
   - Create a `.env` file in the root directory (copy from `.env.example` if it exists)
   - Add your OpenAI API key: `OPENAI_API_KEY=your_actual_api_key_here`
   - **Important:** The `.env` file is in `.gitignore` and will never be committed. Never commit actual API keys.

3. (Optional) Update the upload endpoint in `lib/services/video_service.dart`:
   - Replace `YOUR_UPLOAD_ENDPOINT_HERE` with your actual backend URL

4. Run the app:
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

