class AppConstants {
  static const String appName = 'Pythagon';
  static const String appDescription = 'Math Homework Solver';
  
  // File paths
  static const String problemsDirectory = 'problems';
  static const String imageExtension = '.jpg';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  
  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration imageLoadingTimeout = Duration(seconds: 10);
  
  // Error messages
  static const String cameraPermissionDenied = 'Camera permission is required to capture problems';
  static const String storagePermissionDenied = 'Storage permission is required to save problems';
  static const String cameraNotAvailable = 'Camera is not available on this device';
  static const String imageLoadError = 'Failed to load image';
  static const String problemNotFound = 'Problem not found';
  static const String deletionError = 'Failed to delete problem';
  
  // Success messages
  static const String problemSaved = 'Problem saved successfully';
  static const String problemDeleted = 'Problem deleted successfully';
  static const String analysisStarted = 'Analysis started';
}