import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_subscription.dart';
import '../services/contract_storage_service.dart';

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, AsyncValue<UserSubscription>>((ref) {
  return SubscriptionNotifier(ref);
});

class SubscriptionNotifier extends StateNotifier<AsyncValue<UserSubscription>> {
  final Ref ref;
  
  SubscriptionNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadSubscription();
  }

  Future<void> loadSubscription() async {
    state = const AsyncValue.loading();
    try {
      final storage = ContractStorageService();
      final subscription = await storage.getSubscription();
      state = AsyncValue.data(subscription);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> upgradeToPro() async {
    try {
      final storage = ContractStorageService();
      final currentSub = await storage.getSubscription();
      
      // Set expiry to 1 year from now
      final expiryDate = DateTime.now().add(const Duration(days: 365));
      
      final updatedSub = currentSub.copyWith(
        plan: SubscriptionPlan.pro,
        expiryDate: expiryDate,
        isActive: true,
      );
      
      await storage.saveSubscription(updatedSub);
      await loadSubscription();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelSubscription() async {
    try {
      final storage = ContractStorageService();
      final currentSub = await storage.getSubscription();
      
      final updatedSub = currentSub.copyWith(
        plan: SubscriptionPlan.free,
        expiryDate: null,
        documentsUsedThisMonth: 0,
        lastResetDate: DateTime.now(),
      );
      
      await storage.saveSubscription(updatedSub);
      await loadSubscription();
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getRemainingDocuments() async {
    try {
      final storage = ContractStorageService();
      return await storage.getRemainingDocuments();
    } catch (e) {
      return 0;
    }
  }
}
