import 'package:hive/hive.dart';

part 'user_subscription.g.dart';

@HiveType(typeId: 5)
class UserSubscription {
  @HiveField(0)
  final SubscriptionPlan plan;
  
  @HiveField(1)
  final DateTime? expiryDate;
  
  @HiveField(2)
  final int documentsUsedThisMonth;
  
  @HiveField(3)
  final DateTime lastResetDate;
  
  @HiveField(4)
  final bool isActive;

  UserSubscription({
    this.plan = SubscriptionPlan.free,
    this.expiryDate,
    this.documentsUsedThisMonth = 0,
    required this.lastResetDate,
    this.isActive = true,
  });

  int get maxDocuments {
    switch (plan) {
      case SubscriptionPlan.free:
        return 2;
      case SubscriptionPlan.pro:
        return 999999; // Unlimited for pro users
    }
  }

  bool get canUploadMore => documentsUsedThisMonth < maxDocuments;

  UserSubscription copyWith({
    SubscriptionPlan? plan,
    DateTime? expiryDate,
    int? documentsUsedThisMonth,
    DateTime? lastResetDate,
    bool? isActive,
  }) {
    return UserSubscription(
      plan: plan ?? this.plan,
      expiryDate: expiryDate ?? this.expiryDate,
      documentsUsedThisMonth: documentsUsedThisMonth ?? this.documentsUsedThisMonth,
      lastResetDate: lastResetDate ?? this.lastResetDate,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan': plan.toString(),
      'expiryDate': expiryDate?.toIso8601String(),
      'documentsUsedThisMonth': documentsUsedThisMonth,
      'lastResetDate': lastResetDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      plan: SubscriptionPlan.values.firstWhere(
        (e) => e.toString() == json['plan'],
        orElse: () => SubscriptionPlan.free,
      ),
      expiryDate: json['expiryDate'] != null 
        ? DateTime.parse(json['expiryDate']) 
        : null,
      documentsUsedThisMonth: json['documentsUsedThisMonth'] ?? 0,
      lastResetDate: DateTime.parse(json['lastResetDate']),
      isActive: json['isActive'] ?? true,
    );
  }
}

@HiveType(typeId: 6)
enum SubscriptionPlan {
  @HiveField(0)
  free,
  
  @HiveField(1)
  pro,
}
