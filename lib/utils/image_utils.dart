import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class ImageUtils {
  /// Compress image file to reduce storage space
  static Future<File> compressImage(File imageFile, {int quality = 85}) async {
    // Note: In a real implementation, you would use image compression packages
    // like flutter_image_compress. For this template, we return the original file.
    return imageFile;
  }

  /// Get image file size in bytes
  static Future<int> getImageSize(File imageFile) async {
    final stat = await imageFile.stat();
    return stat.size;
  }

  /// Check if file is a valid image
  static bool isValidImageFile(String path) {
    final extension = path.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  /// Get human readable file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Generate thumbnail from image file
  static Future<Uint8List?> generateThumbnail(File imageFile) async {
    try {
      // Note: In a real implementation, you would use packages like
      // flutter_image_compress or image to generate thumbnails
      final bytes = await imageFile.readAsBytes();
      return bytes;
    } catch (e) {
      return null;
    }
  }

  /// Copy image to app directory with unique name
  static Future<File> copyImageToAppDirectory(
    File sourceFile,
    String targetDirectory,
    String fileName,
  ) async {
    final targetPath = '$targetDirectory/$fileName';
    return await sourceFile.copy(targetPath);
  }
}