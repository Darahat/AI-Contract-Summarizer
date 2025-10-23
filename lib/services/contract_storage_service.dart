import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/contract.dart';
import '../models/user_subscription.dart';
import 'encryption_service.dart';

class ContractStorageService {
  final Box _contractsBox = Hive.box('contracts');
  final Box _usageBox = Hive.box('usage');
  final EncryptionService _encryptionService = EncryptionService();

  // Save contract to local storage
  Future<void> saveContract(Contract contract) async {
    try {
      await _contractsBox.put(contract.id, jsonEncode(contract.toJson()));
    } catch (e) {
      throw Exception('Failed to save contract: $e');
    }
  }

  // Get contract by ID
  Future<Contract?> getContract(String id) async {
    try {
      final data = _contractsBox.get(id);
      if (data == null) return null;
      return Contract.fromJson(jsonDecode(data));
    } catch (e) {
      throw Exception('Failed to retrieve contract: $e');
    }
  }

  // Get all contracts
  Future<List<Contract>> getAllContracts() async {
    try {
      final List<Contract> contracts = [];
      for (var key in _contractsBox.keys) {
        final data = _contractsBox.get(key);
        if (data != null) {
          contracts.add(Contract.fromJson(jsonDecode(data)));
        }
      }
      // Sort by upload date, newest first
      contracts.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
      return contracts;
    } catch (e) {
      throw Exception('Failed to retrieve contracts: $e');
    }
  }

  // Delete contract
  Future<void> deleteContract(String id) async {
    try {
      await _contractsBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete contract: $e');
    }
  }

  // Save user subscription
  Future<void> saveSubscription(UserSubscription subscription) async {
    try {
      await _usageBox.put('subscription', jsonEncode(subscription.toJson()));
    } catch (e) {
      throw Exception('Failed to save subscription: $e');
    }
  }

  // Get user subscription
  Future<UserSubscription> getSubscription() async {
    try {
      final data = _usageBox.get('subscription');
      if (data == null) {
        // Create default free subscription
        final defaultSub = UserSubscription(
          lastResetDate: DateTime.now(),
        );
        await saveSubscription(defaultSub);
        return defaultSub;
      }
      return UserSubscription.fromJson(jsonDecode(data));
    } catch (e) {
      throw Exception('Failed to retrieve subscription: $e');
    }
  }

  // Increment document usage
  Future<void> incrementUsage() async {
    try {
      final subscription = await getSubscription();
      final now = DateTime.now();
      
      // Check if we need to reset monthly usage
      final lastReset = subscription.lastResetDate;
      final needsReset = now.year != lastReset.year || now.month != lastReset.month;
      
      final updatedSubscription = subscription.copyWith(
        documentsUsedThisMonth: needsReset ? 1 : subscription.documentsUsedThisMonth + 1,
        lastResetDate: needsReset ? now : lastReset,
      );
      
      await saveSubscription(updatedSubscription);
    } catch (e) {
      throw Exception('Failed to increment usage: $e');
    }
  }

  // Check if user can upload more documents
  Future<bool> canUploadMore() async {
    try {
      final subscription = await getSubscription();
      return subscription.canUploadMore;
    } catch (e) {
      return false;
    }
  }

  // Get remaining documents this month
  Future<int> getRemainingDocuments() async {
    try {
      final subscription = await getSubscription();
      final remaining = subscription.maxDocuments - subscription.documentsUsedThisMonth;
      return remaining > 0 ? remaining : 0;
    } catch (e) {
      return 0;
    }
  }

  // Clear all data
  Future<void> clearAll() async {
    try {
      await _contractsBox.clear();
      await _usageBox.clear();
    } catch (e) {
      throw Exception('Failed to clear data: $e');
    }
  }
}
