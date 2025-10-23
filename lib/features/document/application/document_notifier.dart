import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/document_repository.dart';
import '../domain/document_model.dart';

/// State for document operations
class DocumentState {
  final List<DocumentModel> documents;
  final DocumentModel? currentDocument;
  final bool isLoading;
  final bool isUploading;
  final bool isAnalyzing;
  final String? error;
  final double? uploadProgress;

  const DocumentState({
    this.documents = const [],
    this.currentDocument,
    this.isLoading = false,
    this.isUploading = false,
    this.isAnalyzing = false,
    this.error,
    this.uploadProgress,
  });

  DocumentState copyWith({
    List<DocumentModel>? documents,
    DocumentModel? currentDocument,
    bool? isLoading,
    bool? isUploading,
    bool? isAnalyzing,
    String? error,
    double? uploadProgress,
  }) {
    return DocumentState(
      documents: documents ?? this.documents,
      currentDocument: currentDocument ?? this.currentDocument,
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      error: error,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }

  DocumentState clearError() {
    return DocumentState(
      documents: documents,
      currentDocument: currentDocument,
      isLoading: isLoading,
      isUploading: isUploading,
      isAnalyzing: isAnalyzing,
    );
  }
}

/// Notifier for document state management
class DocumentNotifier extends StateNotifier<DocumentState> {
  final DocumentRepository _repository;

  DocumentNotifier(this._repository) : super(const DocumentState());

  /// Loads all documents for a user
  Future<void> loadDocuments(String userId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final documents = await _repository.getUserDocuments(userId);
      state = state.copyWith(
        documents: documents,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Uploads and analyzes a new document
  Future<DocumentModel?> uploadDocument({
    required String filePath,
    required String userId,
  }) async {
    try {
      state = state.copyWith(
        isUploading: true,
        isAnalyzing: true,
        error: null,
        uploadProgress: 0.0,
      );

      // Simulate upload progress
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(uploadProgress: 0.3);

      final document = await _repository.uploadDocument(
        filePath: filePath,
        userId: userId,
      );

      state = state.copyWith(uploadProgress: 1.0);
      await Future.delayed(const Duration(milliseconds: 200));

      // Save document
      await _repository.saveDocument(document);

      // Update state
      final updatedDocuments = [...state.documents, document];
      state = state.copyWith(
        documents: updatedDocuments,
        currentDocument: document,
        isUploading: false,
        isAnalyzing: false,
        uploadProgress: null,
      );

      return document;
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        isAnalyzing: false,
        error: e.toString(),
        uploadProgress: null,
      );
      return null;
    }
  }

  /// Selects a document to view
  void selectDocument(DocumentModel document) {
    state = state.copyWith(currentDocument: document);
  }

  /// Deletes a document
  Future<void> deleteDocument(String documentId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.deleteDocument(documentId);

      final updatedDocuments = state.documents
          .where((doc) => doc.id != documentId)
          .toList();

      state = state.copyWith(
        documents: updatedDocuments,
        currentDocument: state.currentDocument?.id == documentId
            ? null
            : state.currentDocument,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clears the current error
  void clearError() {
    state = state.clearError();
  }
}
