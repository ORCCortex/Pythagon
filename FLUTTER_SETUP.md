# ORCCortex - Flutter Mobile App

A powerful Flutter mobile application for extracting and solving mathematical problems from PDF documents using OCR technology.

## 🚀 Features

- **📄 PDF Upload**: Upload PDF documents containing math problems
- **📸 Camera Capture**: Take photos of math problems
- **🖼️ Gallery Import**: Import images from device gallery
- **🔍 OCR Text Extraction**: Extract text and mathematical expressions from PDFs
- **🧮 Automatic Solving**: Solve math problems using SymPy backend
- **📊 Problem Management**: View, track, and manage all your math problems
- **🔄 Real-time Status**: Live updates on processing and solving status
- **✨ Beautiful UI**: Modern Material Design 3 interface

## 📋 Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- iOS Simulator / Android Emulator / Physical Device
- Backend API running (FastAPI from detail.md)

## 🛠️ Installation

### 1. Clone the repository
```bash
cd /Users/thanh/Workspace/ORC/Pythagon-main
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Configure Backend URL

Edit `lib/utils/app_config.dart` and update the API URL:

```dart
static const String apiBaseUrl = 'http://YOUR_BACKEND_URL/api/v1';
```

**Important URL configurations:**
- **iOS Simulator**: `http://localhost:8000/api/v1`
- **Android Emulator**: `http://10.0.2.2:8000/api/v1`
- **Physical Device**: `http://YOUR_COMPUTER_IP:8000/api/v1`

### 4. Run the app
```bash
# For iOS
flutter run -d ios

# For Android
flutter run -d android

# For web (development)
flutter run -d chrome
```

## 📱 App Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   └── math_problem.dart         # Data models for problems and solutions
├── screens/
│   ├── home_screen.dart          # Main screen with problem list
│   ├── camera_screen.dart        # Camera capture screen
│   ├── problem_viewer_screen.dart # Basic problem viewer
│   └── problem_detail_screen.dart # Detailed problem view with solutions
├── services/
│   ├── api_service.dart          # Backend API integration
│   └── problem_service.dart      # Problem management & state
├── utils/
│   ├── app_config.dart           # App configuration
│   ├── constants.dart            # Constants
│   └── image_utils.dart          # Image utilities
└── widgets/
    └── problem_card.dart         # Reusable problem card widget
```

## 🔄 API Integration

The app integrates with the FastAPI backend described in `detail.md`:

### Endpoints Used:
- `POST /api/v1/upload` - Upload PDF files
- `GET /api/v1/upload/status/{problem_id}` - Check processing status
- `GET /api/v1/problems/{user_id}` - Get user's problems
- `GET /api/v1/problems/{user_id}/{problem_id}` - Get specific problem
- `DELETE /api/v1/problems/{user_id}/{problem_id}` - Delete problem
- `POST /api/v1/solve/{problem_id}` - Solve problem
- `POST /api/v1/solve/expression` - Solve single expression
- `GET /api/v1/solve/{problem_id}/solutions` - Get solutions
- `GET /api/v1/solve/solution/{solution_id}` - Get solution details

## 🎯 How to Use

### Upload PDF:
1. Tap the red PDF button (floating action button)
2. Select a PDF file from your device
3. Wait for processing (OCR extraction)
4. View extracted text and math expressions
5. Tap "Solve" to get solutions

### Capture Photo:
1. Tap the blue camera button
2. Take a photo of math problems
3. Save and view the problem

### Gallery Import:
1. Tap the purple gallery button
2. Select an image
3. View the imported problem

### View Solutions:
1. Open any completed problem
2. Tap "Solve Problem" button
3. View step-by-step solutions
4. See final answers for each expression

## 🔧 Configuration

### Backend URL Configuration
Edit `lib/utils/app_config.dart`:

```dart
class AppConfig {
  // Update for your environment
  static const String apiBaseUrl = 'http://localhost:8000/api/v1';
  
  // Timeout settings
  static const int uploadTimeoutSeconds = 60;
  static const int maxPollAttempts = 30;
  static const int pollIntervalSeconds = 3;
}
```

### Firebase Configuration (for web)
If using web version with Firebase auth, update:
- `web/index.html` - Firebase config
- `lib/utils/app_config.dart` - Firebase credentials

## 📦 Dependencies

Key packages used:
- `provider` - State management
- `go_router` - Navigation
- `dio` - HTTP client for API calls
- `file_picker` - PDF file selection
- `image_picker` - Camera & gallery access
- `camera` - Camera functionality
- `path_provider` - File system access

## 🐛 Troubleshooting

### Backend Connection Issues:
1. Ensure backend is running: `uvicorn main:app --reload`
2. Check API URL in `app_config.dart`
3. For Android emulator, use `10.0.2.2` instead of `localhost`
4. For physical devices, use computer's IP address

### PDF Upload Fails:
1. Check file size (max 50MB)
2. Ensure PDF is not corrupted
3. Check backend logs for errors
4. Verify internet connection

### Solutions Not Appearing:
1. Wait for processing to complete
2. Check problem status (should be "Completed")
3. Tap "Solve Problem" button
4. Check backend logs

## 🚀 Building for Production

### iOS:
```bash
flutter build ios --release
```

### Android:
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### Web:
```bash
flutter build web --release
```

## 📝 Notes

- The app requires an active internet connection to communicate with the backend
- PDF processing may take a few seconds depending on file size
- Math expressions are extracted using OCR and may require manual verification
- Solutions are generated using SymPy on the backend

## 🤝 Backend Setup

This Flutter app requires the FastAPI backend described in `detail.md`. Make sure to:

1. Set up Python environment
2. Install backend dependencies
3. Configure Firebase (if using authentication)
4. Run the backend server: `uvicorn main:app --reload`

## 📄 License

This project is part of the ORCCortex system.

## 🔗 Related Files

- `detail.md` - Backend API specifications
- `index.html` - Web frontend template (reference)
- `backend_example.py` - Backend implementation example
