#!/usr/bin/env python3
"""
Simple validation script for the Flutter project structure.
This script checks if all required files and directories are present.
"""

import os
import sys

def check_file_exists(file_path, description):
    """Check if a file exists and report the result."""
    if os.path.exists(file_path):
        print(f"✅ {description}: {file_path}")
        return True
    else:
        print(f"❌ {description}: {file_path} (MISSING)")
        return False

def check_directory_exists(dir_path, description):
    """Check if a directory exists and report the result."""
    if os.path.isdir(dir_path):
        print(f"✅ {description}: {dir_path}")
        return True
    else:
        print(f"❌ {description}: {dir_path} (MISSING)")
        return False

def validate_project_structure():
    """Validate the Flutter project structure."""
    print("🔍 Validating Pythagon Flutter Project Structure")
    print("=" * 50)
    
    all_good = True
    
    # Core Flutter files
    core_files = [
        ("pubspec.yaml", "Flutter project configuration"),
        ("lib/main.dart", "Main app entry point"),
        ("analysis_options.yaml", "Dart analysis configuration"),
        (".gitignore", "Git ignore rules"),
        ("README.md", "Project documentation"),
    ]
    
    for file_path, description in core_files:
        if not check_file_exists(file_path, description):
            all_good = False
    
    # Core directories
    core_dirs = [
        ("lib", "Main source directory"),
        ("lib/screens", "Screen widgets"),
        ("lib/widgets", "Reusable widgets"),
        ("lib/models", "Data models"),
        ("lib/services", "Business logic"),
        ("lib/utils", "Utility functions"),
        ("test", "Test files"),
        ("android", "Android platform"),
        ("ios", "iOS platform"),
    ]
    
    for dir_path, description in core_dirs:
        if not check_directory_exists(dir_path, description):
            all_good = False
    
    # App-specific files
    app_files = [
        ("lib/models/math_problem.dart", "Math problem model"),
        ("lib/services/problem_service.dart", "Problem management service"),
        ("lib/screens/home_screen.dart", "Home screen"),
        ("lib/screens/camera_screen.dart", "Camera screen"),
        ("lib/screens/problem_viewer_screen.dart", "Problem viewer screen"),
        ("lib/widgets/problem_card.dart", "Problem card widget"),
    ]
    
    for file_path, description in app_files:
        if not check_file_exists(file_path, description):
            all_good = False
    
    # Platform-specific files
    platform_files = [
        ("android/app/build.gradle", "Android build configuration"),
        ("android/app/src/main/AndroidManifest.xml", "Android manifest"),
        ("android/app/src/main/kotlin/com/example/pythagon/MainActivity.kt", "Android main activity"),
        ("ios/Runner/Info.plist", "iOS configuration"),
    ]
    
    for file_path, description in platform_files:
        if not check_file_exists(file_path, description):
            all_good = False
    
    print("\n" + "=" * 50)
    if all_good:
        print("🎉 Project structure validation PASSED!")
        print("The Flutter project appears to be properly structured.")
        return 0
    else:
        print("❌ Project structure validation FAILED!")
        print("Some required files or directories are missing.")
        return 1

if __name__ == "__main__":
    sys.exit(validate_project_structure())