import 'package:flutter_test/flutter_test.dart';
import 'package:ai_contract_summarizer/features/document/domain/document_model.dart';

void main() {
  group('RiskLevel', () {
    test('displayName returns correct string', () {
      expect(RiskLevel.low.displayName, 'Low');
      expect(RiskLevel.medium.displayName, 'Medium');
      expect(RiskLevel.high.displayName, 'High');
    });
  });

  group('RiskyClause', () {
    test('creates risky clause correctly', () {
      final clause = RiskyClause(
        id: 'clause1',
        clauseText: 'Sample clause text',
        clauseType: 'Payment Terms',
        riskLevel: RiskLevel.high,
        explanation: 'This is risky because...',
        recommendation: 'Consider changing to...',
      );

      expect(clause.id, 'clause1');
      expect(clause.clauseText, 'Sample clause text');
      expect(clause.riskLevel, RiskLevel.high);
    });

    test('toJson converts clause to JSON', () {
      final clause = RiskyClause(
        id: 'clause1',
        clauseText: 'Sample clause',
        clauseType: 'Liability',
        riskLevel: RiskLevel.medium,
        explanation: 'Explanation',
      );

      final json = clause.toJson();

      expect(json['id'], 'clause1');
      expect(json['riskLevel'], 'medium');
    });

    test('fromJson creates clause from JSON', () {
      final json = {
        'id': 'clause1',
        'clauseText': 'Sample clause',
        'clauseType': 'Liability',
        'riskLevel': 'high',
        'explanation': 'Explanation',
      };

      final clause = RiskyClause.fromJson(json);

      expect(clause.id, 'clause1');
      expect(clause.riskLevel, RiskLevel.high);
    });
  });

  group('DocumentModel', () {
    final testDate = DateTime(2024, 1, 1);

    test('creates document model correctly', () {
      final document = DocumentModel(
        id: 'doc123',
        userId: 'user123',
        fileName: 'contract.pdf',
        filePath: '/path/to/contract.pdf',
        fileType: 'pdf',
        fileSize: 1024000,
        uploadedAt: testDate,
      );

      expect(document.id, 'doc123');
      expect(document.fileName, 'contract.pdf');
      expect(document.isAnalyzed, false);
      expect(document.isEncrypted, false);
    });

    test('toJson converts document to JSON', () {
      final document = DocumentModel(
        id: 'doc123',
        userId: 'user123',
        fileName: 'contract.pdf',
        filePath: '/path/to/contract.pdf',
        fileType: 'pdf',
        fileSize: 1024000,
        uploadedAt: testDate,
        summary: 'Test summary',
        bulletPoints: ['Point 1', 'Point 2'],
        isAnalyzed: true,
      );

      final json = document.toJson();

      expect(json['id'], 'doc123');
      expect(json['summary'], 'Test summary');
      expect(json['bulletPoints'], ['Point 1', 'Point 2']);
      expect(json['isAnalyzed'], true);
    });

    test('fromJson creates document from JSON', () {
      final json = {
        'id': 'doc123',
        'userId': 'user123',
        'fileName': 'contract.pdf',
        'filePath': '/path/to/contract.pdf',
        'fileType': 'pdf',
        'fileSize': 1024000,
        'uploadedAt': testDate.toIso8601String(),
        'isAnalyzed': true,
      };

      final document = DocumentModel.fromJson(json);

      expect(document.id, 'doc123');
      expect(document.isAnalyzed, true);
    });

    test('copyWith creates modified copy', () {
      final original = DocumentModel(
        id: 'doc123',
        userId: 'user123',
        fileName: 'contract.pdf',
        filePath: '/path/to/contract.pdf',
        fileType: 'pdf',
        fileSize: 1024000,
        uploadedAt: testDate,
        isAnalyzed: false,
      );

      final modified = original.copyWith(
        summary: 'New summary',
        isAnalyzed: true,
      );

      expect(modified.id, original.id);
      expect(modified.summary, 'New summary');
      expect(modified.isAnalyzed, true);
    });
  });
}
