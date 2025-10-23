import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/contract.dart';
import '../services/ai_service.dart';
import '../services/contract_storage_service.dart';
import '../services/document_service.dart';
import '../services/encryption_service.dart';

// Services providers
final documentServiceProvider = Provider((ref) => DocumentService());
final contractStorageServiceProvider = Provider((ref) => ContractStorageService());
final encryptionServiceProvider = Provider((ref) => EncryptionService());

// AI Service provider - requires API key
final aiServiceProvider = Provider.family<AIService?, String?>((ref, apiKey) {
  if (apiKey == null || apiKey.isEmpty) return null;
  return AIService(apiKey: apiKey, provider: AIProvider.openai);
});

// Contracts list provider
final contractsProvider = StateNotifierProvider<ContractsNotifier, AsyncValue<List<Contract>>>((ref) {
  return ContractsNotifier(ref);
});

class ContractsNotifier extends StateNotifier<AsyncValue<List<Contract>>> {
  final Ref ref;
  
  ContractsNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadContracts();
  }

  Future<void> loadContracts() async {
    state = const AsyncValue.loading();
    try {
      final storage = ref.read(contractStorageServiceProvider);
      final contracts = await storage.getAllContracts();
      state = AsyncValue.data(contracts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<Contract?> uploadContract(File file, String apiKey) async {
    try {
      final storage = ref.read(contractStorageServiceProvider);
      final docService = ref.read(documentServiceProvider);
      final encryption = ref.read(encryptionServiceProvider);
      final aiService = ref.read(aiServiceProvider(apiKey));

      if (aiService == null) {
        throw Exception('AI service not configured');
      }

      // Check if user can upload more documents
      final canUpload = await storage.canUploadMore();
      if (!canUpload) {
        throw Exception('Monthly limit reached. Upgrade to Pro for unlimited documents.');
      }

      // Validate file
      if (!docService.validateFileSize(file)) {
        throw Exception('File size exceeds 10MB limit');
      }

      // Extract text from document
      final text = await docService.extractText(file);

      // Encrypt the content
      final encryptedContent = encryption.encrypt(text);

      // Create contract object
      final contract = Contract(
        id: const Uuid().v4(),
        fileName: file.path.split('/').last,
        filePath: file.path,
        uploadDate: DateTime.now(),
        encryptedContent: encryptedContent,
        status: ContractStatus.processing,
      );

      // Save contract
      await storage.saveContract(contract);
      await storage.incrementUsage();

      // Reload contracts list
      await loadContracts();

      // Process contract asynchronously
      _processContract(contract, text, aiService);

      return contract;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _processContract(Contract contract, String text, AIService aiService) async {
    try {
      final storage = ref.read(contractStorageServiceProvider);

      // Generate summary
      final summary = await aiService.generateSummary(text);

      // Detect risky clauses
      final riskyClause = await aiService.detectRiskyClause(text);

      // Update contract with results
      final updatedContract = contract.copyWith(
        summary: summary,
        riskyClause: riskyClause,
        status: ContractStatus.completed,
      );

      await storage.saveContract(updatedContract);
      await loadContracts();
    } catch (e) {
      // Update contract with error status
      final storage = ref.read(contractStorageServiceProvider);
      final errorContract = contract.copyWith(
        status: ContractStatus.error,
      );
      await storage.saveContract(errorContract);
      await loadContracts();
    }
  }

  Future<void> deleteContract(String id) async {
    try {
      final storage = ref.read(contractStorageServiceProvider);
      await storage.deleteContract(id);
      await loadContracts();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> explainClause(String clauseText, String apiKey) async {
    try {
      final aiService = ref.read(aiServiceProvider(apiKey));
      if (aiService == null) {
        throw Exception('AI service not configured');
      }
      return await aiService.explainClause(clauseText);
    } catch (e) {
      rethrow;
    }
  }
}

// Current contract provider (for viewing details)
final currentContractProvider = StateProvider<Contract?>((ref) => null);

// API Key provider (should be stored securely in production)
final apiKeyProvider = StateProvider<String?>((ref) => null);
