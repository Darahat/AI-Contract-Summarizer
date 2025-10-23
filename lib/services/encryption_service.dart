import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import '../core/error/failure.dart';

/// Service for encrypting and decrypting sensitive data
class EncryptionService {
  late encrypt.Key _key;
  late encrypt.IV _iv;
  late encrypt.Encrypter _encrypter;

  /// Initialize encryption service with a secret key
  /// In production, use a secure key derivation function and store keys securely
  void initialize(String passphrase) {
    try {
      // Generate key from passphrase
      final keyBytes = _generateKey(passphrase);
      _key = encrypt.Key(keyBytes);

      // Generate IV (in production, should be random and stored with encrypted data)
      _iv = encrypt.IV.fromLength(16);

      // Initialize encrypter with AES
      _encrypter = encrypt.Encrypter(encrypt.AES(_key));
    } catch (e) {
      throw EncryptionFailure('Failed to initialize encryption: ${e.toString()}');
    }
  }

  /// Generate encryption key from passphrase using SHA-256
  Uint8List _generateKey(String passphrase) {
    final bytes = utf8.encode(passphrase);
    final digest = sha256.convert(bytes);
    return Uint8List.fromList(digest.bytes);
  }

  /// Encrypt a string
  String encryptString(String plainText) {
    try {
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      throw EncryptionFailure('Failed to encrypt string: ${e.toString()}');
    }
  }

  /// Decrypt a string
  String decryptString(String encryptedText) {
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
      return _encrypter.decrypt(encrypted, iv: _iv);
    } catch (e) {
      throw EncryptionFailure('Failed to decrypt string: ${e.toString()}');
    }
  }

  /// Encrypt a file
  Future<File> encryptFile(File inputFile, String outputPath) async {
    try {
      // Read file content
      final bytes = await inputFile.readAsBytes();

      // Encrypt bytes
      final encrypted = _encrypter.encryptBytes(bytes, iv: _iv);

      // Write encrypted data to output file
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(encrypted.bytes);

      return outputFile;
    } catch (e) {
      throw EncryptionFailure('Failed to encrypt file: ${e.toString()}');
    }
  }

  /// Decrypt a file
  Future<File> decryptFile(File inputFile, String outputPath) async {
    try {
      // Read encrypted file content
      final encryptedBytes = await inputFile.readAsBytes();

      // Decrypt bytes
      final encrypted = encrypt.Encrypted(encryptedBytes);
      final decryptedBytes = _encrypter.decryptBytes(encrypted, iv: _iv);

      // Write decrypted data to output file
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(decryptedBytes);

      return outputFile;
    } catch (e) {
      throw EncryptionFailure('Failed to decrypt file: ${e.toString()}');
    }
  }

  /// Hash a string (one-way, for passwords)
  String hashString(String text) {
    try {
      final bytes = utf8.encode(text);
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e) {
      throw EncryptionFailure('Failed to hash string: ${e.toString()}');
    }
  }

  /// Verify hashed string
  bool verifyHash(String text, String hash) {
    try {
      final textHash = hashString(text);
      return textHash == hash;
    } catch (e) {
      return false;
    }
  }

  /// Generate secure random IV
  encrypt.IV generateRandomIV() {
    return encrypt.IV.fromSecureRandom(16);
  }

  /// Encrypt data with custom IV (returns both encrypted data and IV)
  Map<String, String> encryptWithIV(String plainText) {
    try {
      final iv = generateRandomIV();
      final encrypted = _encrypter.encrypt(plainText, iv: iv);

      return {
        'data': encrypted.base64,
        'iv': iv.base64,
      };
    } catch (e) {
      throw EncryptionFailure('Failed to encrypt with IV: ${e.toString()}');
    }
  }

  /// Decrypt data with provided IV
  String decryptWithIV(String encryptedText, String ivBase64) {
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
      final iv = encrypt.IV.fromBase64(ivBase64);
      return _encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      throw EncryptionFailure('Failed to decrypt with IV: ${e.toString()}');
    }
  }
}
