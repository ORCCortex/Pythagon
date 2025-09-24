# Pythagon - Math Homework Solver

A Flutter mobile app that allows students to capture and manage their math homework problems through camera functionality and photo uploads. This is the client-side mobile application focusing on image capture, problem display, and navigation.

## Features

- 📸 **Camera Integration**: Take photos of math problems directly from the camera
- 🖼️ **Photo Upload**: Select images from the device gallery
- 📱 **Modern UI**: Clean, intuitive interface with Material Design 3
- 🔍 **Problem Viewer**: Zoom and pan through captured problem images
- 📋 **Problem Management**: View, organize, and delete captured problems
- 🎯 **Navigation**: Smooth navigation between screens using GoRouter
- 🔒 **Null Safety**: Built with Flutter 3.0+ and null safety

## Screenshots

### Home Screen
The main screen displays all captured problems with status indicators and quick access to camera functionality.

### Camera Screen
Full-screen camera interface with capture controls and camera switching functionality.

### Problem Viewer
Detailed view of individual problems with zoom capabilities and problem management options.

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- iOS Simulator / Android Emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/ORCCortex/Pythagon.git
   cd Pythagon
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate platform-specific code (if needed)**
   ```bash
   flutter create --platforms android,ios .
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: Latest
- Permissions: Camera, Storage access

#### iOS
- Minimum iOS version: 11.0
- Permissions: Camera, Photo Library access
- Required: Physical device for camera testing

## Project Structure

```
lib/
├── main.dart                 # App entry point and routing setup
├── models/
│   └── math_problem.dart     # Data model for math problems
├── screens/
│   ├── home_screen.dart      # Main dashboard screen
│   ├── camera_screen.dart    # Camera capture interface
│   └── problem_viewer_screen.dart # Problem detail view
├── services/
│   └── problem_service.dart  # Problem data management
└── widgets/
    └── problem_card.dart     # Reusable problem card component
```

## Key Dependencies

- **camera**: Camera functionality and photo capture
- **image_picker**: Gallery image selection
- **photo_view**: Image zoom and pan capabilities
- **go_router**: Modern navigation and routing
- **provider**: State management
- **path_provider**: File system access

## Usage

### Capturing Problems

1. **From Camera**: Tap the camera FAB to open camera screen
2. **From Gallery**: Tap the gallery FAB to select existing images
3. **View Problems**: Tap any problem card to view details

### Managing Problems

- **Delete**: Use the menu on problem cards or the delete button in viewer
- **Status Tracking**: Problems show pending/analyzing/solved status
- **Image Zoom**: Pinch to zoom and pan in the problem viewer

## Development

### Running Tests
```bash
flutter test
```

### Building for Release

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

### Code Style
The project uses Flutter's recommended linting rules. Run:
```bash
flutter analyze
```

## Architecture

The app follows a simple but scalable architecture:

- **Models**: Data structures for business logic
- **Services**: Data management and business logic
- **Screens**: Full-screen UI components
- **Widgets**: Reusable UI components
- **State Management**: Provider pattern for reactive state

## Limitations (Current Version)

- **No Backend**: This is a client-side only app - no actual problem solving
- **Local Storage**: Problems are stored locally on device
- **Demo Analysis**: Problem analysis is simulated (no actual math solving)
- **No User Accounts**: Single-device usage only

## Future Enhancements

- Backend integration for actual math problem solving
- Cloud storage and sync
- User accounts and problem sharing
- OCR text extraction from images
- Step-by-step solution display
- Multiple problem types support

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For questions or issues, please create an issue in the GitHub repository.

---

**Note**: This is a mobile client application template. Backend functionality for actual math problem solving would need to be implemented separately.
