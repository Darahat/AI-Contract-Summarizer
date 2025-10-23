/// User model representing authenticated user data
class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? profileImageUrl;
  final DateTime createdAt;
  final bool isPremium;
  final int monthlyUploadsUsed;
  final int monthlyUploadsLimit;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.profileImageUrl,
    required this.createdAt,
    this.isPremium = false,
    this.monthlyUploadsUsed = 0,
    this.monthlyUploadsLimit = 2,
  });

  /// Creates a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isPremium: json['isPremium'] as bool? ?? false,
      monthlyUploadsUsed: json['monthlyUploadsUsed'] as int? ?? 0,
      monthlyUploadsLimit: json['monthlyUploadsLimit'] as int? ?? 2,
    );
  }

  /// Converts UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'isPremium': isPremium,
      'monthlyUploadsUsed': monthlyUploadsUsed,
      'monthlyUploadsLimit': monthlyUploadsLimit,
    };
  }

  /// Creates a copy of this UserModel with modified fields
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    DateTime? createdAt,
    bool? isPremium,
    int? monthlyUploadsUsed,
    int? monthlyUploadsLimit,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      isPremium: isPremium ?? this.isPremium,
      monthlyUploadsUsed: monthlyUploadsUsed ?? this.monthlyUploadsUsed,
      monthlyUploadsLimit: monthlyUploadsLimit ?? this.monthlyUploadsLimit,
    );
  }

  /// Checks if user has reached upload limit
  bool get hasReachedUploadLimit => monthlyUploadsUsed >= monthlyUploadsLimit;

  /// Gets remaining uploads for the month
  int get remainingUploads => monthlyUploadsLimit - monthlyUploadsUsed;
}
