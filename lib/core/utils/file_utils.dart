import 'dart:io';
import 'package:path/path.dart' as path;

/// Utility class for file operations
class FileUtils {
  FileUtils._();

  /// Supported file extensions for contract documents
  static const List<String> supportedExtensions = ['pdf', 'docx', 'txt'];

  /// Maximum file size in bytes (10 MB)
  static const int maxFileSize = 10 * 1024 * 1024;

  /// Validates if the file extension is supported
  static bool isSupportedFile(String filePath) {
    final extension = path.extension(filePath).toLowerCase().replaceAll('.', '');
    return supportedExtensions.contains(extension);
  }

  /// Validates if the file size is within limits
  static Future<bool> isValidFileSize(File file) async {
    try {
      final size = await file.length();
      return size <= maxFileSize;
    } catch (e) {
      return false;
    }
  }

  /// Gets file extension from file path
  static String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase().replaceAll('.', '');
  }

  /// Gets file name without extension
  static String getFileNameWithoutExtension(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }

  /// Formats file size in human-readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  /// Checks if file exists
  static Future<bool> fileExists(String filePath) async {
    try {
      return await File(filePath).exists();
    } catch (e) {
      return false;
    }
  }
}
