import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/document_notifier.dart';
import '../data/ai_service.dart';
import '../data/document_repository.dart';

/// Provider for AIService
final aiServiceProvider = Provider<AIService>((ref) {
  return AIService();
});

/// Provider for DocumentRepository
final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  final aiService = ref.watch(aiServiceProvider);
  return DocumentRepository(aiService);
});

/// Provider for DocumentNotifier
final documentProvider =
    StateNotifierProvider<DocumentNotifier, DocumentState>((ref) {
  final repository = ref.watch(documentRepositoryProvider);
  return DocumentNotifier(repository);
});
