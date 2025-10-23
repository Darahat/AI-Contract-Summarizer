import 'package:flutter_test/flutter_test.dart';
import 'package:clausewise/services/encryption_service.dart';

void main() {
  group('EncryptionService', () {
    late EncryptionService encryptionService;

    setUp(() {
      encryptionService = EncryptionService();
    });

    test('should encrypt and decrypt text correctly', () {
      const originalText = 'This is a test contract content';
      
      final encrypted = encryptionService.encrypt(originalText);
      expect(encrypted, isNotEmpty);
      expect(encrypted, isNot(equals(originalText)));
      
      final decrypted = encryptionService.decrypt(encrypted);
      expect(decrypted, equals(originalText));
    });

    test('should generate consistent hash for same content', () {
      const content = 'Test content';
      
      final hash1 = encryptionService.generateHash(content);
      final hash2 = encryptionService.generateHash(content);
      
      expect(hash1, equals(hash2));
    });

    test('should verify hash correctly', () {
      const content = 'Test content';
      final hash = encryptionService.generateHash(content);
      
      expect(encryptionService.verifyHash(content, hash), isTrue);
      expect(encryptionService.verifyHash('Different content', hash), isFalse);
    });
  });
}
