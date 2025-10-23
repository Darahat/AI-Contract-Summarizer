import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DocumentService {
  /// Pick a document file from device
  Future<File?> pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick document: $e');
    }
  }

  /// Extract text from document
  Future<String> extractText(File file) async {
    try {
      final extension = file.path.split('.').last.toLowerCase();
      
      switch (extension) {
        case 'txt':
          return await file.readAsString();
        case 'pdf':
          return await _extractFromPDF(file);
        case 'doc':
        case 'docx':
          return await _extractFromWord(file);
        default:
          throw Exception('Unsupported file format: $extension');
      }
    } catch (e) {
      throw Exception('Failed to extract text: $e');
    }
  }

  Future<String> _extractFromPDF(File file) async {
    try {
      // This is a placeholder. In a real app, you'd use a PDF parsing library
      // like syncfusion_flutter_pdf or native platform channels
      final bytes = await file.readAsBytes();
      
      // For now, return a message indicating PDF processing
      return '''This is a PDF contract document. 
      
The actual text extraction would be implemented using a PDF parsing library.
For demonstration purposes, this represents the extracted contract text from: ${file.path.split('/').last}

Contract content would appear here...''';
    } catch (e) {
      throw Exception('Failed to parse PDF: $e');
    }
  }

  Future<String> _extractFromWord(File file) async {
    try {
      // This is a placeholder. In a real app, you'd use a Word parsing library
      // or native platform channels
      return '''This is a Word contract document.

The actual text extraction would be implemented using a Word parsing library.
For demonstration purposes, this represents the extracted contract text from: ${file.path.split('/').last}

Contract content would appear here...''';
    } catch (e) {
      throw Exception('Failed to parse Word document: $e');
    }
  }

  /// Validate file size (max 10MB)
  bool validateFileSize(File file, {int maxSizeInMB = 10}) {
    try {
      final fileSize = file.lengthSync();
      final maxSize = maxSizeInMB * 1024 * 1024;
      return fileSize <= maxSize;
    } catch (e) {
      return false;
    }
  }

  /// Get file size in human-readable format
  String getFileSize(File file) {
    try {
      final bytes = file.lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (e) {
      return 'Unknown';
    }
  }
}
