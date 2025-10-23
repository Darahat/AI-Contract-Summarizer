import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/error/failure.dart';
import '../domain/document_model.dart';
import 'ai_service.dart';

/// Repository for document operations
class DocumentRepository {
  final AIService _aiService;
  final Uuid _uuid = const Uuid();

  DocumentRepository(this._aiService);

  /// Uploads and analyzes a document
  Future<DocumentModel> uploadDocument({
    required String filePath,
    required String userId,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw const FileFailure('File does not exist');
      }

      final fileSize = await file.length();
      final fileName = file.path.split('/').last;
      final fileType = fileName.split('.').last;

      // Read file content (for text files)
      // TODO: Implement PDF/DOCX parsing
      String content = '';
      if (fileType == 'txt') {
        content = await file.readAsString();
      }

      // Create initial document model
      final document = DocumentModel(
        id: _uuid.v4(),
        userId: userId,
        fileName: fileName,
        filePath: filePath,
        fileType: fileType,
        fileSize: fileSize,
        uploadedAt: DateTime.now(),
        isAnalyzed: false,
        isEncrypted: false,
      );

      // Analyze document
      final analysis = await _aiService.analyzeDocument(content);

      // Update document with analysis results
      return document.copyWith(
        summary: analysis['summary'] as String?,
        bulletPoints: (analysis['bulletPoints'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        riskyClauses: (analysis['riskyClauses'] as List<dynamic>?)
            ?.map((e) => RiskyClause.fromJson(e as Map<String, dynamic>))
            .toList(),
        isAnalyzed: true,
      );
    } catch (e) {
      if (e is Failure) rethrow;
      throw FileFailure('Failed to upload document: ${e.toString()}');
    }
  }

  /// Gets all documents for a user
  Future<List<DocumentModel>> getUserDocuments(String userId) async {
    try {
      // TODO: Implement actual data retrieval from local storage
      await Future.delayed(const Duration(milliseconds: 500));
      return [];
    } catch (e) {
      throw CacheFailure('Failed to get documents: ${e.toString()}');
    }
  }

  /// Gets a single document by ID
  Future<DocumentModel?> getDocument(String documentId) async {
    try {
      // TODO: Implement actual data retrieval
      await Future.delayed(const Duration(milliseconds: 300));
      return null;
    } catch (e) {
      throw CacheFailure('Failed to get document: ${e.toString()}');
    }
  }

  /// Deletes a document
  Future<void> deleteDocument(String documentId) async {
    try {
      // TODO: Implement actual deletion from storage and file system
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      throw CacheFailure('Failed to delete document: ${e.toString()}');
    }
  }

  /// Saves document to local storage
  Future<void> saveDocument(DocumentModel document) async {
    try {
      // TODO: Implement actual save to local database
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      throw CacheFailure('Failed to save document: ${e.toString()}');
    }
  }

  /// Gets application documents directory
  Future<String> getDocumentsDirectory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final documentsDir = Directory('${directory.path}/contracts');
      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }
      return documentsDir.path;
    } catch (e) {
      throw FileFailure('Failed to get documents directory: ${e.toString()}');
    }
  }
}
