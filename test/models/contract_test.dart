import 'package:flutter_test/flutter_test.dart';
import 'package:clausewise/models/contract.dart';

void main() {
  group('Contract Model', () {
    test('should create a contract with required fields', () {
      final contract = Contract(
        id: '123',
        fileName: 'test.pdf',
        filePath: '/path/to/test.pdf',
        uploadDate: DateTime.now(),
        encryptedContent: 'encrypted_content',
      );

      expect(contract.id, equals('123'));
      expect(contract.fileName, equals('test.pdf'));
      expect(contract.status, equals(ContractStatus.pending));
      expect(contract.riskyClause, isEmpty);
    });

    test('should convert to and from JSON', () {
      final originalContract = Contract(
        id: '123',
        fileName: 'test.pdf',
        filePath: '/path/to/test.pdf',
        uploadDate: DateTime(2024, 1, 1),
        encryptedContent: 'encrypted_content',
        summary: 'Test summary',
        status: ContractStatus.completed,
      );

      final json = originalContract.toJson();
      final restoredContract = Contract.fromJson(json);

      expect(restoredContract.id, equals(originalContract.id));
      expect(restoredContract.fileName, equals(originalContract.fileName));
      expect(restoredContract.summary, equals(originalContract.summary));
      expect(restoredContract.status, equals(originalContract.status));
    });

    test('should copy with updated fields', () {
      final original = Contract(
        id: '123',
        fileName: 'test.pdf',
        filePath: '/path/to/test.pdf',
        uploadDate: DateTime.now(),
        encryptedContent: 'encrypted_content',
        status: ContractStatus.pending,
      );

      final updated = original.copyWith(
        summary: 'New summary',
        status: ContractStatus.completed,
      );

      expect(updated.id, equals(original.id));
      expect(updated.summary, equals('New summary'));
      expect(updated.status, equals(ContractStatus.completed));
    });
  });

  group('RiskClause Model', () {
    test('should create a risk clause', () {
      final riskClause = RiskClause(
        type: 'payment',
        clauseText: 'Payment terms unclear',
        explanation: 'This could lead to disputes',
        riskLevel: RiskLevel.high,
        recommendation: 'Clarify payment schedule',
      );

      expect(riskClause.type, equals('payment'));
      expect(riskClause.riskLevel, equals(RiskLevel.high));
    });

    test('should convert to and from JSON', () {
      final original = RiskClause(
        type: 'liability',
        clauseText: 'Unlimited liability',
        explanation: 'No cap on liability',
        riskLevel: RiskLevel.critical,
        recommendation: 'Add liability cap',
      );

      final json = original.toJson();
      final restored = RiskClause.fromJson(json);

      expect(restored.type, equals(original.type));
      expect(restored.riskLevel, equals(original.riskLevel));
    });
  });
}
