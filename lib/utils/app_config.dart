class AppConfig {
  // Backend API Configuration
  // Update this URL to point to your FastAPI backend
  static const String apiBaseUrl = 'http://localhost:8000/api/v1';
  
  // For mobile devices testing with local backend:
  // - iOS Simulator: use 'http://localhost:8000/api/v1'
  // - Android Emulator: use 'http://10.0.2.2:8000/api/v1'
  // - Real device: use 'http://YOUR_COMPUTER_IP:8000/api/v1'
  
  // Firebase Configuration (if needed for web version)
  static const String firebaseApiKey = 'AIzaSyDawDrFn00B7g3IeJmBloi9Vdi8qSMgOPI';
  static const String firebaseAuthDomain = 'orccortex-543d1.firebaseapp.com';
  static const String firebaseProjectId = 'orccortex-543d1';
  static const String firebaseStorageBucket = 'orccortex-543d1.firebasestorage.app';
  
  // App Settings
  static const int uploadTimeoutSeconds = 60;
  static const int maxPollAttempts = 30;
  static const int pollIntervalSeconds = 3;
  
  // File Upload Settings
  static const int maxPdfSizeMB = 50;
  static const List<String> allowedFileExtensions = ['pdf'];
}
