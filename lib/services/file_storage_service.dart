import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/error/failure.dart';
import '../features/document/domain/document_model.dart';

/// Service for local file storage and management
class FileStorageService {
  static const String _documentsBoxName = 'documents';
  static const String _contractsDirectory = 'contracts';

  /// Initialize Hive storage
  Future<void> initialize() async {
    await Hive.initFlutter();
    // Register adapters if needed
    // Hive.registerAdapter(DocumentModelAdapter());
  }

  /// Get documents box
  Future<Box> _getDocumentsBox() async {
    if (!Hive.isBoxOpen(_documentsBoxName)) {
      return await Hive.openBox(_documentsBoxName);
    }
    return Hive.box(_documentsBoxName);
  }

  /// Get contracts directory path
  Future<String> getContractsDirectory() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final contractsDir = Directory('${appDir.path}/$_contractsDirectory');

      if (!await contractsDir.exists()) {
        await contractsDir.create(recursive: true);
      }

      return contractsDir.path;
    } catch (e) {
      throw FileFailure('Failed to get contracts directory: ${e.toString()}');
    }
  }

  /// Save document metadata to local storage
  Future<void> saveDocument(DocumentModel document) async {
    try {
      final box = await _getDocumentsBox();
      await box.put(document.id, document.toJson());
    } catch (e) {
      throw CacheFailure('Failed to save document: ${e.toString()}');
    }
  }

  /// Get document metadata by ID
  Future<DocumentModel?> getDocument(String documentId) async {
    try {
      final box = await _getDocumentsBox();
      final data = box.get(documentId);
      if (data == null) return null;
      return DocumentModel.fromJson(Map<String, dynamic>.from(data as Map));
    } catch (e) {
      throw CacheFailure('Failed to get document: ${e.toString()}');
    }
  }

  /// Get all documents for a user
  Future<List<DocumentModel>> getUserDocuments(String userId) async {
    try {
      final box = await _getDocumentsBox();
      final documents = <DocumentModel>[];

      for (var key in box.keys) {
        final data = box.get(key);
        if (data != null) {
          final document =
              DocumentModel.fromJson(Map<String, dynamic>.from(data as Map));
          if (document.userId == userId) {
            documents.add(document);
          }
        }
      }

      // Sort by upload date (newest first)
      documents.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
      return documents;
    } catch (e) {
      throw CacheFailure('Failed to get user documents: ${e.toString()}');
    }
  }

  /// Delete document metadata and file
  Future<void> deleteDocument(String documentId) async {
    try {
      final box = await _getDocumentsBox();
      final data = box.get(documentId);

      if (data != null) {
        final document =
            DocumentModel.fromJson(Map<String, dynamic>.from(data as Map));

        // Delete file from storage
        final file = File(document.filePath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Delete metadata
      await box.delete(documentId);
    } catch (e) {
      throw CacheFailure('Failed to delete document: ${e.toString()}');
    }
  }

  /// Copy file to contracts directory
  Future<String> saveContractFile(File sourceFile, String fileName) async {
    try {
      final contractsDir = await getContractsDirectory();
      final targetPath = '$contractsDir/$fileName';
      final targetFile = File(targetPath);

      // Copy file
      await sourceFile.copy(targetPath);

      return targetPath;
    } catch (e) {
      throw FileFailure('Failed to save contract file: ${e.toString()}');
    }
  }

  /// Get file from contracts directory
  Future<File?> getContractFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      throw FileFailure('Failed to get contract file: ${e.toString()}');
    }
  }

  /// Calculate total storage used
  Future<int> getTotalStorageUsed(String userId) async {
    try {
      final documents = await getUserDocuments(userId);
      int totalSize = 0;

      for (var document in documents) {
        totalSize += document.fileSize;
      }

      return totalSize;
    } catch (e) {
      throw CacheFailure('Failed to calculate storage: ${e.toString()}');
    }
  }

  /// Clear all documents for a user
  Future<void> clearUserDocuments(String userId) async {
    try {
      final documents = await getUserDocuments(userId);

      for (var document in documents) {
        await deleteDocument(document.id);
      }
    } catch (e) {
      throw CacheFailure('Failed to clear user documents: ${e.toString()}');
    }
  }

  /// Close storage
  Future<void> close() async {
    await Hive.close();
  }
}
