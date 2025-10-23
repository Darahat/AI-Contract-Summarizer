import 'package:flutter_test/flutter_test.dart';
import 'package:ai_contract_summarizer/features/auth/domain/user_model.dart';

void main() {
  group('UserModel', () {
    final testDate = DateTime(2024, 1, 1);

    test('creates user model correctly', () {
      final user = UserModel(
        id: 'user123',
        email: 'test@example.com',
        name: 'Test User',
        createdAt: testDate,
      );

      expect(user.id, 'user123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.isPremium, false);
      expect(user.monthlyUploadsUsed, 0);
      expect(user.monthlyUploadsLimit, 2);
    });

    test('hasReachedUploadLimit returns true when limit reached', () {
      final user = UserModel(
        id: 'user123',
        email: 'test@example.com',
        createdAt: testDate,
        monthlyUploadsUsed: 2,
        monthlyUploadsLimit: 2,
      );

      expect(user.hasReachedUploadLimit, true);
    });

    test('hasReachedUploadLimit returns false when under limit', () {
      final user = UserModel(
        id: 'user123',
        email: 'test@example.com',
        createdAt: testDate,
        monthlyUploadsUsed: 1,
        monthlyUploadsLimit: 2,
      );

      expect(user.hasReachedUploadLimit, false);
    });

    test('remainingUploads calculates correctly', () {
      final user = UserModel(
        id: 'user123',
        email: 'test@example.com',
        createdAt: testDate,
        monthlyUploadsUsed: 1,
        monthlyUploadsLimit: 5,
      );

      expect(user.remainingUploads, 4);
    });

    test('toJson converts model to JSON correctly', () {
      final user = UserModel(
        id: 'user123',
        email: 'test@example.com',
        name: 'Test User',
        createdAt: testDate,
        isPremium: true,
        monthlyUploadsUsed: 5,
        monthlyUploadsLimit: 10,
      );

      final json = user.toJson();

      expect(json['id'], 'user123');
      expect(json['email'], 'test@example.com');
      expect(json['name'], 'Test User');
      expect(json['isPremium'], true);
      expect(json['monthlyUploadsUsed'], 5);
      expect(json['monthlyUploadsLimit'], 10);
    });

    test('fromJson creates model from JSON correctly', () {
      final json = {
        'id': 'user123',
        'email': 'test@example.com',
        'name': 'Test User',
        'createdAt': testDate.toIso8601String(),
        'isPremium': true,
        'monthlyUploadsUsed': 5,
        'monthlyUploadsLimit': 10,
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 'user123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.isPremium, true);
      expect(user.monthlyUploadsUsed, 5);
      expect(user.monthlyUploadsLimit, 10);
    });

    test('copyWith creates modified copy', () {
      final original = UserModel(
        id: 'user123',
        email: 'test@example.com',
        createdAt: testDate,
        monthlyUploadsUsed: 1,
      );

      final modified = original.copyWith(
        monthlyUploadsUsed: 2,
        isPremium: true,
      );

      expect(modified.id, original.id);
      expect(modified.email, original.email);
      expect(modified.monthlyUploadsUsed, 2);
      expect(modified.isPremium, true);
    });
  });
}
