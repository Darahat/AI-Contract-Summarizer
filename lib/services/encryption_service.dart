import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';

class EncryptionService {
  late final Key _key;
  late final IV _iv;
  late final Encrypter _encrypter;

  EncryptionService({String? customKey}) {
    // Generate a key from a seed or use a custom key
    final keyString = customKey ?? _generateDefaultKey();
    _key = Key.fromUtf8(keyString.padRight(32).substring(0, 32));
    _iv = IV.fromLength(16);
    _encrypter = Encrypter(AES(_key));
  }

  String _generateDefaultKey() {
    // In production, this should be securely stored or derived from user credentials
    return 'ClauseWiseSecureKey2024Default';
  }

  /// Encrypts plain text using AES encryption
  String encrypt(String plainText) {
    try {
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  /// Decrypts encrypted text
  String decrypt(String encryptedText) {
    try {
      final encrypted = Encrypted.fromBase64(encryptedText);
      return _encrypter.decrypt(encrypted, iv: _iv);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  /// Encrypts binary data (for files)
  Uint8List encryptBytes(Uint8List data) {
    try {
      final base64Data = base64Encode(data);
      final encrypted = _encrypter.encrypt(base64Data, iv: _iv);
      return encrypted.bytes;
    } catch (e) {
      throw Exception('Byte encryption failed: $e');
    }
  }

  /// Decrypts binary data
  Uint8List decryptBytes(Uint8List encryptedData) {
    try {
      final encrypted = Encrypted(encryptedData);
      final decrypted = _encrypter.decrypt(encrypted, iv: _iv);
      return base64Decode(decrypted);
    } catch (e) {
      throw Exception('Byte decryption failed: $e');
    }
  }

  /// Generates a hash of the content for verification
  String generateHash(String content) {
    return sha256.convert(utf8.encode(content)).toString();
  }

  /// Verifies if the content matches the hash
  bool verifyHash(String content, String hash) {
    return generateHash(content) == hash;
  }
}
