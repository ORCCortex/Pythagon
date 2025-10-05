# Development Guide

This document provides detailed information for developers working on the Pythagon Flutter app.

## Architecture Overview

The app follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
├── screens/                  # UI screens
├── widgets/                  # Reusable widgets
├── services/                 # Business logic
└── utils/                    # Utility functions
```

## State Management

The app uses the Provider pattern for state management:

- **ProblemService**: Manages math problems data and operations
- **Provider**: Provides reactive state updates to UI components
- **Consumer**: Widgets that listen to state changes

## Navigation

Navigation is handled by GoRouter:

- Route definitions in `main.dart`
- Type-safe navigation with parameters
- Support for deep linking (future enhancement)

## Key Components

### Models
- **MathProblem**: Core data structure for math problems
- **ProblemStatus**: Enum for problem states

### Services
- **ProblemService**: CRUD operations for problems
- Local file storage for images
- State management for UI updates

### Screens
- **HomeScreen**: Main dashboard with problem list
- **CameraScreen**: Camera interface for capture
- **ProblemViewerScreen**: Detailed problem view

### Widgets
- **ProblemCard**: Reusable problem display component

## Development Setup

### Code Style
- Follow Flutter/Dart conventions
- Use `analysis_options.yaml` for linting
- Run `flutter analyze` before commits

### Testing Strategy
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Building

#### Debug Build
```bash
flutter run --debug
```

#### Release Build
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Adding New Features

### 1. New Screen
1. Create screen file in `lib/screens/`
2. Add route in `main.dart`
3. Update navigation calls
4. Add tests in `test/screens/`

### 2. New Widget
1. Create widget file in `lib/widgets/`
2. Follow stateless/stateful pattern
3. Add documentation comments
4. Create widget tests

### 3. New Service
1. Create service file in `lib/services/`
2. Extend ChangeNotifier if needed
3. Add to providers in `main.dart`
4. Write unit tests

## Performance Considerations

### Image Handling
- Compress images before storage
- Use appropriate image widgets
- Implement lazy loading for lists

### Memory Management
- Dispose controllers properly
- Use `const` constructors
- Avoid memory leaks in listeners

### Build Optimization
- Use `const` widgets where possible
- Minimize rebuilds with proper keys
- Profile performance regularly

## Platform-Specific Notes

### Android
- Minimum SDK: 21 (Lollipop)
- Camera2 API usage
- Storage scoped permissions

### iOS
- Minimum version: 11.0
- Camera usage descriptions
- App Transport Security

## Common Issues

### Camera Permissions
```dart
// Request permissions before camera access
final status = await Permission.camera.request();
if (status.isGranted) {
  // Proceed with camera
}
```

### File Storage
```dart
// Always check file existence
if (await file.exists()) {
  // Process file
}
```

### State Updates
```dart
// Always notify listeners after state changes
_problems.add(newProblem);
notifyListeners();
```

## Debugging

### Common Debug Commands
```bash
# Flutter inspector
flutter inspector

# Performance overlay
flutter run --profile

# Device logs
flutter logs
```

### Debug Tools
- Flutter Inspector for widget tree
- Performance overlay for frame rates
- Memory profiler for leaks

## Deployment

### Pre-deployment Checklist
- [ ] All tests passing
- [ ] Code analysis clean
- [ ] Performance tested
- [ ] Permissions verified
- [ ] Version number updated

### Release Process
1. Update version in `pubspec.yaml`
2. Update changelog
3. Build release versions
4. Test on physical devices
5. Submit to app stores

## Contributing

1. Fork the repository
2. Create feature branch
3. Make changes with tests
4. Run full test suite
5. Submit pull request

### Code Review Guidelines
- Functional correctness
- Performance implications
- Code maintainability
- Test coverage
- Documentation updates

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides/language)
- [Material Design Guidelines](https://material.io/design)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Package](https://pub.dev/packages/go_router)