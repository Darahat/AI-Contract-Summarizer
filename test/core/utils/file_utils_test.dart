import 'package:flutter_test/flutter_test.dart';
import 'package:ai_contract_summarizer/core/utils/file_utils.dart';

void main() {
  group('FileUtils', () {
    group('isSupportedFile', () {
      test('returns true for supported PDF extension', () {
        expect(FileUtils.isSupportedFile('document.pdf'), true);
      });

      test('returns true for supported DOCX extension', () {
        expect(FileUtils.isSupportedFile('document.docx'), true);
      });

      test('returns true for supported TXT extension', () {
        expect(FileUtils.isSupportedFile('document.txt'), true);
      });

      test('returns false for unsupported extension', () {
        expect(FileUtils.isSupportedFile('document.jpg'), false);
      });

      test('is case insensitive', () {
        expect(FileUtils.isSupportedFile('document.PDF'), true);
        expect(FileUtils.isSupportedFile('document.DOCX'), true);
      });
    });

    group('getFileExtension', () {
      test('extracts extension correctly', () {
        expect(FileUtils.getFileExtension('document.pdf'), 'pdf');
      });

      test('handles multiple dots in filename', () {
        expect(FileUtils.getFileExtension('my.document.pdf'), 'pdf');
      });

      test('returns lowercase extension', () {
        expect(FileUtils.getFileExtension('document.PDF'), 'pdf');
      });
    });

    group('getFileNameWithoutExtension', () {
      test('extracts filename without extension', () {
        expect(
          FileUtils.getFileNameWithoutExtension('/path/to/document.pdf'),
          'document',
        );
      });

      test('handles files with multiple dots', () {
        expect(
          FileUtils.getFileNameWithoutExtension('/path/to/my.document.pdf'),
          'my.document',
        );
      });
    });

    group('formatFileSize', () {
      test('formats bytes correctly', () {
        expect(FileUtils.formatFileSize(500), '500 B');
      });

      test('formats kilobytes correctly', () {
        expect(FileUtils.formatFileSize(1024), '1.00 KB');
        expect(FileUtils.formatFileSize(2048), '2.00 KB');
      });

      test('formats megabytes correctly', () {
        expect(FileUtils.formatFileSize(1024 * 1024), '1.00 MB');
        expect(FileUtils.formatFileSize(5 * 1024 * 1024), '5.00 MB');
      });
    });
  });
}
